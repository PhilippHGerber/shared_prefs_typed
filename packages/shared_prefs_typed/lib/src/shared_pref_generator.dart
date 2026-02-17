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
    final generateInterface = annotation.read('generateInterface').boolValue;

    final fields = classElement.fields
        .where((FieldElement field) => field.isStatic && field.isConst)
        .map<_SharedPrefField>(_SharedPrefField.new)
        .toList();

    final publicClassName = classElement.name!.substring(1);
    final bodyItems = <Spec>[];

    if (generateInterface) {
      bodyItems.add(_buildInterface(publicClassName, fields, isAsync: isAsyncMode));
    }

    bodyItems.add(
      isAsyncMode
          ? _buildAsyncClass(classElement, fields, generateInterface: generateInterface)
          : _buildSyncClass(classElement, fields, generateInterface: generateInterface),
    );

    final library = Library(
      (b) => b
        ..ignoreForFile.addAll(['unused_element', 'unused_field'])
        ..directives.addAll([
          Directive.import('package:shared_preferences/shared_preferences.dart'),
          Directive.import(buildStep.inputId.pathSegments.last),
        ])
        ..body.addAll(bodyItems),
    );

    final emitter = DartEmitter(useNullSafetySyntax: true, orderDirectives: true);
    return DartFormatter(
      languageVersion: Version(3, 9, 0),
    ).format(library.accept(emitter).toString());
  }
}

Class _buildSyncClass(
  ClassElement classElement,
  List<_SharedPrefField> fields, {
  bool generateInterface = false,
}) {
  final publicClassName = classElement.name!.substring(1);
  const prefsClassName = 'SharedPreferencesWithCache';
  const prefsOptionsName = 'SharedPreferencesWithCacheOptions';

  return Class(
    (b) => b
      ..name = publicClassName
      ..docs.add('/// Provides type-safe, cached access to application preferences.')
      ..docs.add('///')
      ..docs.add('/// Use `await $publicClassName.init()` on app startup,')
      ..docs.add('/// then access values via the singleton `instance`,')
      ..docs.add('/// or create an instance directly: `$publicClassName(prefs)`.')
      ..implements.addAll(generateInterface ? [refer('${publicClassName}Base')] : [])
      ..fields.add(
        Field(
          (f) => f
            ..name = '_instance'
            ..static = true
            ..type = refer('$publicClassName?'),
        ),
      )
      ..fields.add(
        Field(
          (f) => f
            ..name = '_prefs'
            ..type = refer(prefsClassName)
            ..modifier = FieldModifier.final$,
        ),
      )
      ..constructors.add(
        Constructor(
          (c) => c
            ..requiredParameters.add(
              Parameter(
                (p) => p
                  ..name = '_prefs'
                  ..toThis = true,
              ),
            ),
        ),
      )
      ..methods.add(
        Method(
          (m) => m
            ..name = 'instance'
            ..docs.add(
              '/// The singleton instance. Throws a [StateError] if [init] has not been called.',
            )
            ..static = true
            ..type = MethodType.getter
            ..returns = refer(publicClassName)
            ..body = Code(
              'final i = _instance;\n'
              'if (i == null) {\n'
              '  throw StateError(\n'
              "    '$publicClassName has not been initialized. '\n"
              "    'Call `await $publicClassName.init()` before accessing `instance`, '\n"
              "    'or use the $publicClassName(prefs) constructor directly.',\n"
              '  );\n'
              '}\n'
              'return i;',
            ),
        ),
      )
      ..methods.add(
        Method(
          (m) => m
            ..name = 'init'
            ..docs.add('/// Initializes the preferences service.')
            ..returns = refer('Future<void>')
            ..static = true
            ..modifier = MethodModifier.async
            ..body = Code(
              'final prefs = await $prefsClassName.create(cacheOptions: const $prefsOptionsName());\n'
              '_instance = $publicClassName(prefs);',
            ),
        ),
      )
      ..methods.add(
        Method(
          (m) => m
            ..name = 'resetInstance'
            ..docs.add('/// Resets the singleton instance to `null`. Useful for test teardown.')
            ..static = true
            ..returns = refer('void')
            ..body = const Code('_instance = null;'),
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

Class _buildAsyncClass(
  ClassElement classElement,
  List<_SharedPrefField> fields, {
  bool generateInterface = false,
}) {
  final publicClassName = classElement.name!.substring(1);
  const prefsClassName = 'SharedPreferencesAsync';

  return Class(
    (b) => b
      ..name = publicClassName
      ..docs.add('/// Provides type-safe, asynchronous access to application preferences.')
      ..docs.add('///')
      ..docs.add('/// Use `await $publicClassName.init()` on app startup,')
      ..docs.add('/// then access values via the singleton `instance`,')
      ..docs.add('/// or create an instance directly: `$publicClassName(prefs)`.')
      ..implements.addAll(generateInterface ? [refer('${publicClassName}Base')] : [])
      ..fields.add(
        Field(
          (f) => f
            ..name = '_instance'
            ..static = true
            ..type = refer('$publicClassName?'),
        ),
      )
      ..fields.add(
        Field(
          (f) => f
            ..name = '_prefs'
            ..type = refer(prefsClassName)
            ..modifier = FieldModifier.final$,
        ),
      )
      ..constructors.add(
        Constructor(
          (c) => c
            ..requiredParameters.add(
              Parameter(
                (p) => p
                  ..name = '_prefs'
                  ..toThis = true,
              ),
            ),
        ),
      )
      ..methods.add(
        Method(
          (m) => m
            ..name = 'instance'
            ..docs.add(
              '/// The singleton instance. Throws a [StateError] if [init] has not been called.',
            )
            ..static = true
            ..type = MethodType.getter
            ..returns = refer(publicClassName)
            ..body = Code(
              'final i = _instance;\n'
              'if (i == null) {\n'
              '  throw StateError(\n'
              "    '$publicClassName has not been initialized. '\n"
              "    'Call `await $publicClassName.init()` before accessing `instance`, '\n"
              "    'or use the $publicClassName(prefs) constructor directly.',\n"
              '  );\n'
              '}\n'
              'return i;',
            ),
        ),
      )
      ..methods.add(
        Method(
          (m) => m
            ..name = 'init'
            ..docs.add('/// Initializes the preferences service.')
            ..returns = refer('Future<void>')
            ..static = true
            ..modifier = MethodModifier.async
            ..body = Code('_instance = $publicClassName($prefsClassName());'),
        ),
      )
      ..methods.add(
        Method(
          (m) => m
            ..name = 'resetInstance'
            ..docs.add('/// Resets the singleton instance to `null`. Useful for test teardown.')
            ..static = true
            ..returns = refer('void')
            ..body = const Code('_instance = null;'),
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

Class _buildInterface(
  String publicClassName,
  List<_SharedPrefField> fields, {
  required bool isAsync,
}) {
  final interfaceName = '${publicClassName}Base';

  return Class(
    (b) => b
      ..name = interfaceName
      ..abstract = true
      ..docs.add('/// Abstract interface for [$publicClassName].')
      ..docs.add('///')
      ..docs.add('/// Implement or mock this for dependency injection and testing.')
      ..methods.addAll(
        fields.expand(
          (field) => [
            Method(
              (m) => m
                ..name = field.paramName
                ..type = MethodType.getter
                ..returns = isAsync
                    ? refer('Future<${field.typeReference.symbol}>')
                    : field.typeReference,
            ),
            Method(
              (m) => m
                ..name = 'set${field.publicName}'
                ..returns = refer('Future<void>')
                ..requiredParameters.add(
                  Parameter(
                    (p) => p
                      ..name = 'value'
                      ..type = field.typeReference,
                  ),
                ),
            ),
            Method(
              (m) => m
                ..name = 'isSet${field.publicName}'
                ..returns = refer(isAsync ? 'Future<bool>' : 'bool'),
            ),
            Method(
              (m) => m
                ..name = 'remove${field.publicName}'
                ..returns = refer('Future<void>'),
            ),
          ],
        ),
      ),
  );
}

//--- Method Generators (No changes needed here as they depend on _SharedPrefField) ---//

Method _generateSyncGetter(_SharedPrefField field) {
  final getExpr = "_prefs.get${field.prefTypeName}('${field.keyName}')";
  final body = field.defaultValue == 'null'
      ? 'return $getExpr;'
      : 'return $getExpr ?? ${field.defaultValue};';

  return Method(
    (b) => b
      ..name = field.paramName
      ..docs.add('/// Gets the value for `${field.keyName}` from the cache.')
      ..docs.add('///')
      ..docs.add(
        '/// If the key does not exist, the default value `${field.defaultValue}` is returned.',
      )
      ..type = MethodType.getter
      ..returns = field.typeReference
      ..body = Code(body),
  );
}

Method _generateAsyncGetter(_SharedPrefField field) {
  final getExpr = "(await _prefs.get${field.prefTypeName}('${field.keyName}'))";
  final body = field.defaultValue == 'null'
      ? 'return $getExpr;'
      : 'return $getExpr ?? ${field.defaultValue};';

  return Method(
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
      ..body = Code(body),
  );
}

Method _generateSetter(_SharedPrefField field) {
  final body = field.isNullable
      ? Code(
          "if (value == null) { return _prefs.remove('${field.keyName}'); } "
          "return _prefs.set${field.prefTypeName}('${field.keyName}', value);",
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
    final nonNullableString = isNullable
        ? typeString.substring(0, typeString.length - 1)
        : typeString;
    return refer(nonNullableString);
  }

  static const _supportedTypes = {'int', 'double', 'bool', 'String', 'List<String>'};

  String get prefTypeName {
    final typeString = nonNullableTypeReference.symbol!;
    if (typeString == 'List<String>') return 'StringList';
    if (!_supportedTypes.contains(typeString)) {
      throw InvalidGenerationSourceError(
        'The field `$name` has unsupported type `${field.type.getDisplayString()}`. '
        'Supported types are: ${_supportedTypes.join(', ')} (and their nullable variants).',
        element: field,
      );
    }
    return typeString.toPascalCase();
  }

  String get defaultValue {
    final constantValue = field.computeConstantValue();
    if (constantValue == null || constantValue.isNull) return 'null';

    final type = constantValue.type;
    if (type == null) return 'null';
    if (type.isDartCoreInt) return constantValue.toIntValue().toString();
    if (type.isDartCoreString) {
      return "'${_escapeDartString(constantValue.toStringValue()!)}'";
    }
    if (type.isDartCoreBool) return constantValue.toBoolValue().toString();
    if (type.isDartCoreDouble) return constantValue.toDoubleValue().toString();
    if (type.isDartCoreList) {
      final listValues = constantValue.toListValue()!;
      final stringValues = listValues
          .map((DartObject e) => "'${_escapeDartString(e.toStringValue()!)}'")
          .join(', ');
      return 'const <String>[$stringValues]';
    }
    return 'null';
  }
}

/// Escapes a string value for use in a single-quoted Dart string literal.
String _escapeDartString(String value) => value
    .replaceAll(r'\', r'\\')
    .replaceAll("'", r"\'")
    .replaceAll(r'$', r'\$')
    .replaceAll('\n', r'\n')
    .replaceAll('\r', r'\r')
    .replaceAll('\t', r'\t');

extension on String {
  String toPascalCase() => isEmpty ? '' : this[0].toUpperCase() + substring(1);
  String toCamelCase() => isEmpty ? '' : this[0].toLowerCase() + substring(1);
}
