import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:source_gen/source_gen.dart';

/// Generates a user-friendly, singleton service class for type-safe access
/// to SharedPreferences.
class TypedPrefsGenerator extends GeneratorForAnnotation<TypedPrefs> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@TypedPrefs` can only be used on classes.',
        element: element,
      );
    }

    if (element.name?.startsWith('_') == false) {
      throw InvalidGenerationSourceError(
        'The annotated class name must start with an underscore (`_`) to indicate it is private.',
        element: element,
      );
    }

    final classElement = element;
    final isAsyncMode = annotation.read('async').boolValue;

    final fields = classElement.fields
        .where((FieldElement field) => field.isStatic && field.isConst)
        .map<_SharedPrefField>(_SharedPrefField.new)
        .toList();

    final generatedClass = isAsyncMode
        ? _buildAsyncClass(classElement, fields)
        : _buildSyncClass(classElement, fields);

    final library = Library(
      (b) => b
        ..ignoreForFile.addAll(['unused_element', 'unnecessary_cast', 'unused_field'])
        ..directives.addAll([
          Directive.import('package:shared_preferences/shared_preferences.dart'),
          Directive.import(buildStep.inputId.pathSegments.last),
        ])
        ..body.add(generatedClass),
    );

    final emitter = DartEmitter(useNullSafetySyntax: true, orderDirectives: true);
    return DartFormatter(
      languageVersion: Version(3, 9, 0),
    ).format(library.accept(emitter).toString());
  }
}

Class _buildSyncClass(ClassElement classElement, List<_SharedPrefField> fields) {
  final publicClassName = classElement.name?.substring(1);
  const prefsClassName = 'SharedPreferencesWithCache';
  const prefsOptionsName = 'SharedPreferencesWithCacheOptions';

  return Class(
    (b) => b
      ..name = publicClassName
      ..docs.add('/// Provides type-safe, cached access to application preferences.')
      ..docs.add('///')
      ..docs.add('/// Use `await $publicClassName.init()` on app startup,')
      ..docs.add('/// then access values via the singleton `instance`.')
      ..fields.add(
        Field(
          (f) => f
            ..name = 'instance'
            ..static = true
            ..modifier = FieldModifier.final$
            ..assignment = Code('$publicClassName._()'),
        ),
      )
      ..fields.add(
        Field(
          (f) => f
            ..name = '_prefs'
            ..type = refer(prefsClassName)
            ..static = true
            ..late = true,
        ),
      )
      ..constructors.add(Constructor((c) => c..name = '_'))
      ..methods.add(
        Method(
          (m) => m
            ..name = 'init'
            ..docs.add('/// Initializes the preferences service.')
            ..returns = refer('Future<void>')
            ..static = true
            ..modifier = MethodModifier.async
            ..body = const Code(
              '_prefs = await $prefsClassName.create(cacheOptions: const $prefsOptionsName());',
            ),
        ),
      )
      ..methods.addAll(
        fields.expand(
          (field) => [
            _generateSyncGetter(field),
            _generateSetter(field),
            _generateIsSet(field, isAsync: false),
            _generateRemover(field),
          ],
        ),
      ),
  );
}

Class _buildAsyncClass(ClassElement classElement, List<_SharedPrefField> fields) {
  final publicClassName = classElement.name?.substring(1);
  const prefsClassName = 'SharedPreferencesAsync';

  return Class(
    (b) => b
      ..name = publicClassName
      ..docs.add('/// Provides type-safe, asynchronous access to application preferences.')
      ..docs.add('///')
      ..docs.add('/// Use `await $publicClassName.init()` on app startup,')
      ..docs.add('/// then access values via the singleton `instance`.')
      ..fields.add(
        Field(
          (f) => f
            ..name = 'instance'
            ..static = true
            ..modifier = FieldModifier.final$
            ..assignment = Code('$publicClassName._()'),
        ),
      )
      ..fields.add(
        Field(
          (f) => f
            ..name = '_prefs'
            ..type = refer(prefsClassName)
            ..static = true
            ..late = true,
        ),
      )
      ..constructors.add(Constructor((c) => c..name = '_'))
      ..methods.add(
        Method(
          (m) => m
            ..name = 'init'
            ..returns = refer('Future<void>')
            ..static = true
            ..modifier = MethodModifier.async
            ..body = const Code('_prefs = $prefsClassName(); return;'),
        ),
      )
      ..methods.addAll(
        fields.expand(
          (field) => [
            _generateAsyncGetter(field),
            _generateSetter(field),
            _generateIsSet(field, isAsync: true),
            _generateRemover(field),
          ],
        ),
      ),
  );
}

//--- Method Generators (No changes needed here as they depend on _SharedPrefField) ---//

Method _generateSyncGetter(_SharedPrefField field) => Method(
      (b) => b
        ..name = field.paramName
        ..docs.add('/// Gets the value for `${field.keyName}` from the cache.')
        ..docs.add('///')
        ..docs.add(
          '/// If the key does not exist, the default value `${field.defaultValue}` is returned.',
        )
        ..type = MethodType.getter
        ..returns = field.typeReference
        ..body = Code(
          "return _prefs.get${field.prefTypeName}('${field.keyName}') ?? ${field.defaultValue};",
        ),
    );

Method _generateAsyncGetter(_SharedPrefField field) => Method(
      (b) => b
        ..name = field.paramName
        ..docs.add('/// Asynchronously gets the value for `${field.keyName}`.')
        ..docs.add('///')
        ..docs.add(
          '/// If the key does not exist, the default value `${field.defaultValue}` is returned.',
        )
        ..type = MethodType.getter
        ..returns = refer('Future<${field.typeReference.symbol}>')
        ..modifier = MethodModifier.async
        ..body = Code(
          "return (await _prefs.get${field.prefTypeName}('${field.keyName}')) ?? ${field.defaultValue};",
        ),
    );

Method _generateSetter(_SharedPrefField field) {
  final body = field.isNullable
      ? Code(
          "if (value == null) { return _prefs.remove('${field.keyName}'); } "
          "return _prefs.set${field.prefTypeName}('${field.keyName}', value as ${field.nonNullableTypeReference.symbol});",
        )
      : Code("return _prefs.set${field.prefTypeName}('${field.keyName}', value);");

  final docComments = <String>[
    '/// Asynchronously sets the value for `${field.keyName}`.',
  ];

  if (field.isNullable) {
    docComments.addAll([
      '///',
      '/// If the provided [value] is `null`, the preference is removed from storage.',
    ]);
  }

  return Method(
    (b) => b
      ..name = 'set${field.publicName}'
      ..docs.addAll(docComments)
      ..returns = refer('Future<void>')
      ..requiredParameters.add(
        Parameter(
          (p) => p
            ..name = 'value'
            ..type = field.typeReference,
        ),
      )
      ..body = body,
  );
}

Method _generateIsSet(_SharedPrefField field, {required bool isAsync}) => Method(
      (b) => b
        ..name = 'isSet${field.publicName}'
        ..docs.add('/// Checks if a value has been explicitly set for `${field.keyName}`.')
        ..docs.add('///')
        ..docs.add('/// Returns `true` if the key exists in persistent storage, `false` otherwise.')
        ..returns = refer(isAsync ? 'Future<bool>' : 'bool')
        ..body = Code("return _prefs.containsKey('${field.keyName}');"),
    );

Method _generateRemover(_SharedPrefField field) => Method(
      (b) => b
        ..name = 'remove${field.publicName}'
        ..docs.add('/// Removes the stored value for `${field.keyName}`.')
        ..docs.add('///')
        ..docs.add(
          '/// After calling this, the getter will return the default value (`${field.defaultValue}`).',
        )
        ..returns = refer('Future<void>')
        ..body = Code("return _prefs.remove('${field.keyName}');"),
    );

//--- Helper class and extensions ---//

class _SharedPrefField {
  _SharedPrefField(this.field);
  final FieldElement field;

  // The `!` is safe here because a `static const` field, which is the only
  // kind we process, is syntactically required to have a name.
  String get name => field.name!;

  String get keyName => name.startsWith('_') ? name.substring(1) : name;
  String get publicName => keyName.toPascalCase();
  String get paramName => keyName.toCamelCase();

  Reference get typeReference => refer(field.type.getDisplayString());
  bool get isNullable => field.type.nullabilitySuffix == NullabilitySuffix.question;

  Reference get nonNullableTypeReference {
    final typeString = field.type.getDisplayString();
    final nonNullableString =
        isNullable ? typeString.substring(0, typeString.length - 1) : typeString;
    return refer(nonNullableString);
  }

  String get prefTypeName {
    final typeString = nonNullableTypeReference.symbol!;
    if (typeString == 'List<String>') return 'StringList';
    return typeString.toPascalCase();
  }

  String get defaultValue {
    final constantValue = field.computeConstantValue();
    if (constantValue == null || constantValue.isNull) return 'null';

    final type = constantValue.type;
    if (type == null) return 'null';
    if (type.isDartCoreInt) return constantValue.toIntValue().toString();
    if (type.isDartCoreString) {
      return "'${constantValue.toStringValue()!.replaceAll("'", r"\'")}'";
    }
    if (type.isDartCoreBool) return constantValue.toBoolValue().toString();
    if (type.isDartCoreDouble) return constantValue.toDoubleValue().toString();
    if (type.isDartCoreList) {
      final listValues = constantValue.toListValue()!;
      final stringValues = listValues
          .map((DartObject e) => "'${e.toStringValue()!.replaceAll("'", r"\'")}'")
          .join(', ');
      return 'const <String>[$stringValues]';
    }
    return 'null';
  }
}

extension on String {
  String toPascalCase() => isEmpty ? '' : this[0].toUpperCase() + substring(1);
  String toCamelCase() => isEmpty ? '' : this[0].toLowerCase() + substring(1);
}
