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

    final classElement = element;
    final modeReader = annotation.read('mode');
    final isAsyncMode = modeReader.isNull
        ? annotation.read('async').boolValue
        : modeReader.objectValue.getField('_name')?.toStringValue() == 'async';
    final generateInterface = annotation.read('generateInterface').boolValue;

    final fields = classElement.fields
        .where((FieldElement field) => field.isStatic && field.isConst)
        .map<_SharedPrefField>(_SharedPrefField.new)
        .toList();

    // Validate fields.
    final seenKeys = <String, _SharedPrefField>{};
    for (final field in fields) {
      // Validate no duplicate SharedPreferences keys.
      final key = field.keyName;
      final existing = seenKeys[key];
      if (existing != null) {
        throw InvalidGenerationSourceError(
          'Duplicate SharedPreferences key "$key". '
          'Fields `${existing.name}` and `${field.name}` resolve to the same '
          'storage key. Use @PrefKey to assign distinct keys.',
          element: field.field,
        );
      }
      seenKeys[key] = field;

      // Validate DateTime fields have @PrefDateTime.
      if (field.isDateTime && field.dateTimeEncoding == null) {
        throw InvalidGenerationSourceError(
          'The field `${field.name}` is a DateTime but has no @PrefDateTime annotation. '
          'Add `@PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch)` or '
          '`@PrefDateTime(DateTimeEncoding.iso8601)` to specify the encoding.',
          element: field.field,
        );
      }

      // Validate against reserved generated-class member names.
      const reservedNames = {'init', 'instance', 'resetInstance'};
      if (reservedNames.contains(field.paramName)) {
        throw InvalidGenerationSourceError(
          'Field `${field.name}` produces a generated API name `${field.paramName}` '
          'that conflicts with a built-in member of the generated class. '
          'Rename the field or use @PrefKey to assign a different storage key.',
          element: field.field,
        );
      }

      // Validate type is supported (triggers error for unknown types).
      field.prefTypeName;
    }

    final publicClassName = classElement.generatedClassName;
    final bodyItems = <Spec>[];

    if (generateInterface) {
      bodyItems.add(
        _buildInterface(
          publicClassName,
          classElement.generatedInterfaceName,
          fields,
          isAsync: isAsyncMode,
        ),
      );
    }

    bodyItems.add(
      isAsyncMode
          ? _buildAsyncClass(classElement, fields, generateInterface: generateInterface)
          : _buildSyncClass(classElement, fields, generateInterface: generateInterface),
    );

    final hasListField = fields.any(
      (f) => f.nonNullableTypeReference.symbol!.startsWith('List<'),
    );

    final library = Library(
      (b) => b
        ..ignoreForFile.addAll(['unused_element', 'unused_field'])
        ..directives.addAll([
          if (hasListField) Directive.import('dart:collection'),
          Directive.import('package:meta/meta.dart'),
          Directive.import('package:shared_preferences/shared_preferences.dart'),
          Directive.import(buildStep.inputId.pathSegments.last),
        ])
        ..body.addAll(bodyItems),
    );

    const warning =
        '/// WARNING: Storage keys are derived from field names. '
        'Renaming a field changes its key and causes data loss '
        'unless @PrefKey is used to pin the key explicitly.\n';

    final emitter = DartEmitter(useNullSafetySyntax: true, orderDirectives: true);
    final formatted = DartFormatter(
      languageVersion: Version(3, 9, 0),
    ).format(library.accept(emitter).toString());
    return '$warning$formatted';
  }
}

Class _buildSyncClass(
  ClassElement classElement,
  List<_SharedPrefField> fields, {
  bool generateInterface = false,
}) {
  final publicClassName = classElement.generatedClassName;
  const prefsClassName = 'SharedPreferencesWithCache';
  const prefsOptionsName = 'SharedPreferencesWithCacheOptions';

  return Class(
    (b) => b
      ..name = publicClassName
      ..docs.add('/// Provides type-safe, cached access to application preferences.')
      ..docs.add('///')
      ..docs.add('/// **Simple apps**: call `await $publicClassName.init()` on startup,')
      ..docs.add('/// then access values via the singleton `$publicClassName.instance`.')
      ..docs.add('///')
      ..docs.add('/// **DI & Testing**: inject a backend directly: `$publicClassName(backend)`.')
      ..implements.addAll(generateInterface ? [refer(classElement.generatedInterfaceName)] : [])
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
            ..name = '_initFuture'
            ..static = true
            ..type = refer('Future<$publicClassName>?'),
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
            ..docs.add(
              '/// Creates an instance backed by the given [$prefsClassName].',
            )
            ..docs.add('///')
            ..docs.add('/// Use this for dependency injection and testing.')
            ..docs.add('/// For global access, use [init] and [instance] instead.')
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
              "    'Call `await $publicClassName.init()` before accessing `instance`.',\n"
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
            ..docs.add('/// Initializes and returns the singleton [instance].')
            ..docs.add('///')
            ..docs.add(
              '/// Safe to call multiple times — concurrent calls share the same future',
            )
            ..docs.add('/// and do not trigger additional I/O.')
            ..returns = refer('Future<$publicClassName>')
            ..static = true
            ..body = const Code(
              'if (_instance != null) return Future.value(_instance!);\n'
              'return _initFuture ??= _doInit();',
            ),
        ),
      )
      ..methods.add(
        Method(
          (m) => m
            ..name = '_doInit'
            ..static = true
            ..returns = refer('Future<$publicClassName>')
            ..modifier = MethodModifier.async
            ..body = Code(
              'try {\n'
              '  final prefs = await $prefsClassName.create(cacheOptions: const $prefsOptionsName());\n'
              '  return _instance = $publicClassName(prefs);\n'
              '} catch (e) {\n'
              '  _initFuture = null;\n'
              '  rethrow;\n'
              '}',
            ),
        ),
      )
      ..methods.add(
        Method(
          (m) => m
            ..name = 'resetInstance'
            ..docs.add('/// Resets the singleton instance to `null`. Useful for test teardown.')
            ..annotations.add(refer('visibleForTesting'))
            ..static = true
            ..returns = refer('void')
            ..body = const Code('_instance = null;\n_initFuture = null;'),
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
  final publicClassName = classElement.generatedClassName;
  const prefsClassName = 'SharedPreferencesAsync';

  return Class(
    (b) => b
      ..name = publicClassName
      ..docs.add('/// Provides type-safe, asynchronous access to application preferences.')
      ..docs.add('///')
      ..docs.add('/// **Simple apps**: call `await $publicClassName.init()` on startup,')
      ..docs.add('/// then access values via the singleton `$publicClassName.instance`.')
      ..docs.add('///')
      ..docs.add('/// **DI & Testing**: inject a backend directly: `$publicClassName(backend)`.')
      ..implements.addAll(generateInterface ? [refer(classElement.generatedInterfaceName)] : [])
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
            ..name = '_initFuture'
            ..static = true
            ..type = refer('Future<$publicClassName>?'),
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
            ..docs.add(
              '/// Creates an instance backed by the given [$prefsClassName].',
            )
            ..docs.add('///')
            ..docs.add('/// Use this for dependency injection and testing.')
            ..docs.add('/// For global access, use [init] and [instance] instead.')
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
              "    'Call `await $publicClassName.init()` before accessing `instance`.',\n"
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
            ..docs.add('/// Initializes and returns the singleton [instance].')
            ..docs.add('///')
            ..docs.add(
              '/// Safe to call multiple times — concurrent calls share the same future',
            )
            ..docs.add('/// and do not trigger additional I/O.')
            ..returns = refer('Future<$publicClassName>')
            ..static = true
            ..body = const Code(
              'if (_instance != null) return Future.value(_instance!);\n'
              'return _initFuture ??= _doInit();',
            ),
        ),
      )
      ..methods.add(
        Method(
          (m) => m
            ..name = '_doInit'
            ..static = true
            ..returns = refer('Future<$publicClassName>')
            ..body = Code(
              'return Future.value(_instance = $publicClassName($prefsClassName()));',
            ),
        ),
      )
      ..methods.add(
        Method(
          (m) => m
            ..name = 'resetInstance'
            ..docs.add('/// Resets the singleton instance to `null`. Useful for test teardown.')
            ..annotations.add(refer('visibleForTesting'))
            ..static = true
            ..returns = refer('void')
            ..body = const Code('_instance = null;\n_initFuture = null;'),
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
  String implName,
  String interfaceName,
  List<_SharedPrefField> fields, {
  required bool isAsync,
}) {
  return Class(
    (b) => b
      ..name = interfaceName
      ..abstract = true
      ..docs.add('/// Abstract interface for [$implName].')
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
                    ? refer('Future<${field.getterTypeReference.symbol}>')
                    : field.getterTypeReference,
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
                ..name = 'contains${field.publicName}'
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
  final Code body;
  if (field.isEnum) {
    final rawExpr = "_prefs.getString('${field.keyName}')";
    if (field.isNullable && !field.hasNonNullDefault) {
      body = Code(
        'final raw = $rawExpr;\n'
        'if (raw == null) return null;\n'
        'return ${field.enumTypeName}.values.byName(raw);',
      );
    } else {
      body = Code(
        'final raw = $rawExpr;\n'
        'if (raw == null) return ${field.defaultValue};\n'
        'return ${field.enumTypeName}.values.byName(raw);',
      );
    }
  } else if (field.isDateTime) {
    body = Code(_buildDateTimeSyncGetterBody(field));
  } else if (field.isStringList) {
    body = Code(_buildStringListSyncGetterBody(field));
  } else if (field.numericListElementType != null) {
    body = Code(_buildNumericListSyncGetterBody(field));
  } else {
    final getExpr = "_prefs.get${field.prefTypeName}('${field.keyName}')";
    final defaultExpr = field.defaultValue;
    body = Code(
      'try {\n'
      "  return $getExpr${defaultExpr == 'null' ? '' : ' ?? $defaultExpr'};\n"
      '} catch (_) {\n'
      '  return $defaultExpr;\n'
      '}',
    );
  }

  return Method(
    (b) => b
      ..name = field.paramName
      ..docs.add('/// Gets the value for `${field.keyName}` from the cache.')
      ..docs.add('///')
      ..docs.add(
        '/// If the key does not exist, the default value `${field.defaultValue}` is returned.',
      )
      ..type = MethodType.getter
      ..returns = field.getterTypeReference
      ..body = body,
  );
}

Method _generateAsyncGetter(_SharedPrefField field) {
  final Code body;
  if (field.isEnum) {
    final rawExpr = "(await _prefs.getString('${field.keyName}'))";
    if (field.isNullable && !field.hasNonNullDefault) {
      body = Code(
        'final raw = $rawExpr;\n'
        'if (raw == null) return null;\n'
        'return ${field.enumTypeName}.values.byName(raw);',
      );
    } else {
      body = Code(
        'final raw = $rawExpr;\n'
        'if (raw == null) return ${field.defaultValue};\n'
        'return ${field.enumTypeName}.values.byName(raw);',
      );
    }
  } else if (field.isDateTime) {
    body = Code(_buildDateTimeAsyncGetterBody(field));
  } else if (field.isStringList) {
    body = Code(_buildStringListAsyncGetterBody(field));
  } else if (field.numericListElementType != null) {
    body = Code(_buildNumericListAsyncGetterBody(field));
  } else {
    final getExpr = "(await _prefs.get${field.prefTypeName}('${field.keyName}'))";
    final defaultExpr = field.defaultValue;
    body = Code(
      'try {\n'
      "  return $getExpr${defaultExpr == 'null' ? '' : ' ?? $defaultExpr'};\n"
      '} catch (_) {\n'
      '  return $defaultExpr;\n'
      '}',
    );
  }

  return Method(
    (b) => b
      ..name = field.paramName
      ..docs.add('/// Asynchronously gets the value for `${field.keyName}`.')
      ..docs.add('///')
      ..docs.add(
        '/// If the key does not exist, the default value `${field.defaultValue}` is returned.',
      )
      ..type = MethodType.getter
      ..returns = refer('Future<${field.getterTypeReference.symbol}>')
      ..modifier = MethodModifier.async
      ..body = body,
  );
}

Method _generateSetter(_SharedPrefField field) {
  final Code body;
  if (field.isEnum) {
    body = field.isNullable
        ? Code(
            "if (value == null) { return _prefs.remove('${field.keyName}'); } "
            "return _prefs.setString('${field.keyName}', value.name);",
          )
        : Code("return _prefs.setString('${field.keyName}', value.name);");
  } else if (field.isDateTime) {
    body = _buildDateTimeSetterBody(field);
  } else if (field.numericListElementType != null) {
    body = field.isNullable
        ? Code(
            "if (value == null) { return _prefs.remove('${field.keyName}'); } "
            "return _prefs.setStringList('${field.keyName}', value.map((e) => e.toString()).toList());",
          )
        : Code(
            "return _prefs.setStringList('${field.keyName}', value.map((e) => e.toString()).toList());",
          );
  } else {
    body = field.isNullable
        ? Code(
            "if (value == null) { return _prefs.remove('${field.keyName}'); } "
            "return _prefs.set${field.prefTypeName}('${field.keyName}', value);",
          )
        : Code("return _prefs.set${field.prefTypeName}('${field.keyName}', value);");
  }

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
    ..name = 'contains${field.publicName}'
    ..docs.add('/// Checks if a value has been explicitly set for `${field.keyName}`.')
    ..docs.add('///')
    ..docs.add('/// Returns `true` if the key exists in persistent storage, `false` otherwise.')
    ..returns = refer(isAsync ? 'Future<bool>' : 'bool')
    ..body = refer(
      '_prefs',
    ).property('containsKey').call([literalString(field.keyName)]).returned.statement,
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
    ..body = refer(
      '_prefs',
    ).property('remove').call([literalString(field.keyName)]).returned.statement,
);

//--- DateTime helpers ---//

String _buildDateTimeSyncGetterBody(_SharedPrefField field) {
  final key = field.keyName;
  final isMillis = field.dateTimeEncoding == DateTimeEncoding.millisecondsSinceEpoch;
  if (isMillis) {
    return 'try {\n'
        "  final raw = _prefs.getInt('$key');\n"
        '  if (raw == null) return null;\n'
        '  return DateTime.fromMillisecondsSinceEpoch(raw);\n'
        '} catch (_) {\n'
        '  return null;\n'
        '}';
  }
  return "final raw = _prefs.getString('$key');\n"
      'if (raw == null) return null;\n'
      'try {\n'
      'return DateTime.parse(raw);\n'
      '} catch (_) {\n'
      'return null;\n'
      '}';
}

String _buildDateTimeAsyncGetterBody(_SharedPrefField field) {
  final key = field.keyName;
  final isMillis = field.dateTimeEncoding == DateTimeEncoding.millisecondsSinceEpoch;
  if (isMillis) {
    return 'try {\n'
        "  final raw = (await _prefs.getInt('$key'));\n"
        '  if (raw == null) return null;\n'
        '  return DateTime.fromMillisecondsSinceEpoch(raw);\n'
        '} catch (_) {\n'
        '  return null;\n'
        '}';
  }
  return "final raw = (await _prefs.getString('$key'));\n"
      'if (raw == null) return null;\n'
      'try {\n'
      'return DateTime.parse(raw);\n'
      '} catch (_) {\n'
      'return null;\n'
      '}';
}

Code _buildDateTimeSetterBody(_SharedPrefField field) {
  final key = field.keyName;
  final isMillis = field.dateTimeEncoding == DateTimeEncoding.millisecondsSinceEpoch;
  final setExpr = isMillis
      ? "return _prefs.setInt('$key', value.millisecondsSinceEpoch);"
      : "return _prefs.setString('$key', value.toIso8601String());";
  // DateTime fields are always nullable.
  return Code("if (value == null) { return _prefs.remove('$key'); } $setExpr");
}

//--- String list helpers ---//

String _buildStringListSyncGetterBody(_SharedPrefField field) {
  final key = field.keyName;
  final rawExpr = "_prefs.getStringList('$key')";
  if (field.isNullable && !field.hasNonNullDefault) {
    return 'final raw = $rawExpr;\n'
        'return raw == null ? null : UnmodifiableListView(raw);';
  }
  return 'final raw = $rawExpr;\n'
      'return raw == null ? ${field.defaultValue} : UnmodifiableListView(raw);';
}

String _buildStringListAsyncGetterBody(_SharedPrefField field) {
  final key = field.keyName;
  final rawExpr = "await _prefs.getStringList('$key')";
  if (field.isNullable && !field.hasNonNullDefault) {
    return 'final raw = $rawExpr;\n'
        'return raw == null ? null : UnmodifiableListView(raw);';
  }
  return 'final raw = $rawExpr;\n'
      'return raw == null ? ${field.defaultValue} : UnmodifiableListView(raw);';
}

//--- Numeric list helpers ---//

String _buildNumericListSyncGetterBody(_SharedPrefField field) {
  final key = field.keyName;
  final elementType = field.numericListElementType!;
  final rawExpr = "_prefs.getStringList('$key')";
  if (field.isNullable && !field.hasNonNullDefault) {
    return 'final raw = $rawExpr;\n'
        'return raw == null ? null : UnmodifiableListView(raw.map($elementType.parse).toList());';
  }
  return 'final raw = $rawExpr;\n'
      'return raw == null ? ${field.defaultValue} : UnmodifiableListView(raw.map($elementType.parse).toList());';
}

String _buildNumericListAsyncGetterBody(_SharedPrefField field) {
  final key = field.keyName;
  final elementType = field.numericListElementType!;
  final rawExpr = "await _prefs.getStringList('$key')";
  if (field.isNullable && !field.hasNonNullDefault) {
    return 'final raw = $rawExpr;\n'
        'return raw == null ? null : UnmodifiableListView(raw.map($elementType.parse).toList());';
  }
  return 'final raw = $rawExpr;\n'
      'return raw == null ? ${field.defaultValue} : UnmodifiableListView(raw.map($elementType.parse).toList());';
}

//--- Helper class and extensions ---//

class _SharedPrefField {
  _SharedPrefField(this.field);
  final FieldElement field;

  static const _prefKeyChecker = TypeChecker.fromUrl(
    'package:shared_prefs_typed_annotations/src/pref_key.dart#PrefKey',
  );

  // The `!` is safe here because a `static const` field, which is the only
  // kind we process, is syntactically required to have a name.
  String get name => field.name!;

  String? get _prefKeyOverride {
    final value = _prefKeyChecker.firstAnnotationOfExact(field);
    if (value == null) return null;
    final key = value.getField('key')?.toStringValue();
    if (key != null && key.isEmpty) {
      throw InvalidGenerationSourceError(
        'The @PrefKey on field `$name` has an empty key. '
        'Provide a non-empty string.',
        element: field,
      );
    }
    return key;
  }

  /// The field name with a leading `_` stripped, used for Dart API names.
  String get _baseName => name.startsWith('_') ? name.substring(1) : name;

  /// The SharedPreferences storage key — uses `@PrefKey` override if present.
  String get keyName {
    final override = _prefKeyOverride;
    if (override != null) return override;
    return _baseName;
  }

  String get publicName => _baseName.toPascalCase();
  String get paramName => _baseName.toCamelCase();

  Reference get typeReference => refer(field.type.getDisplayString());
  bool get isNullable => field.type.nullabilitySuffix == NullabilitySuffix.question;

  Reference get nonNullableTypeReference {
    final typeString = field.type.getDisplayString();
    final nonNullableString = isNullable
        ? typeString.substring(0, typeString.length - 1)
        : typeString;
    return refer(nonNullableString);
  }

  /// True when the field is nullable but its default is not null.
  /// In this case the getter can safely return the non-nullable type.
  bool get hasNonNullDefault => isNullable && defaultValue != 'null';

  /// Return type for getters: narrows to non-nullable when [hasNonNullDefault].
  Reference get getterTypeReference => hasNonNullDefault ? nonNullableTypeReference : typeReference;

  bool get isEnum {
    final element = field.type.element;
    return element is EnumElement;
  }

  /// The enum type name (e.g. `'ThemeMode'`), only valid when [isEnum] is true.
  String get enumTypeName => nonNullableTypeReference.symbol!;

  bool get isDateTime => nonNullableTypeReference.symbol == 'DateTime';

  static const _prefDateTimeChecker = TypeChecker.fromUrl(
    'package:shared_prefs_typed_annotations/src/pref_date_time.dart#PrefDateTime',
  );

  /// Returns the [DateTimeEncoding] for this field, or `null` if no
  /// `@PrefDateTime` annotation is present.
  DateTimeEncoding? get dateTimeEncoding {
    final value = _prefDateTimeChecker.firstAnnotationOfExact(field);
    if (value == null) return null;
    final index = value.getField('encoding')?.getField('index')?.toIntValue();
    if (index == null) return null;
    return DateTimeEncoding.values[index];
  }

  static const _supportedTypes = {
    'int',
    'double',
    'bool',
    'String',
    'List<String>',
    'List<int>',
    'List<double>',
  };

  /// True when the non-nullable type is `List<String>` (not a numeric list).
  bool get isStringList => nonNullableTypeReference.symbol == 'List<String>';

  /// Returns `'int'` or `'double'` for `List<int>`/`List<double>`, `null` otherwise.
  String? get numericListElementType {
    final typeString = nonNullableTypeReference.symbol!;
    if (typeString == 'List<int>') return 'int';
    if (typeString == 'List<double>') return 'double';
    return null;
  }

  String get prefTypeName {
    if (isEnum) return 'String';
    if (isDateTime) {
      final encoding = dateTimeEncoding;
      if (encoding == null) {
        throw InvalidGenerationSourceError(
          'The field `$name` is a DateTime but has no @PrefDateTime annotation. '
          'Add `@PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch)` or '
          '`@PrefDateTime(DateTimeEncoding.iso8601)` to specify the encoding.',
          element: field,
        );
      }
      return encoding == DateTimeEncoding.millisecondsSinceEpoch ? 'Int' : 'String';
    }
    final typeString = nonNullableTypeReference.symbol!;
    if (typeString == 'List<String>') return 'StringList';
    if (typeString == 'List<int>' || typeString == 'List<double>') return 'StringList';
    if (!_supportedTypes.contains(typeString)) {
      throw InvalidGenerationSourceError(
        'The field `$name` has unsupported type `${field.type.getDisplayString()}`. '
        'Supported types are: ${_supportedTypes.join(', ')}, Enum types, '
        'DateTime (and their nullable variants).',
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
    if (isEnum) {
      final enumName = constantValue.getField('_name')?.toStringValue();
      if (enumName != null) return '$enumTypeName.$enumName';
      return 'null';
    }
    if (type.isDartCoreInt) return constantValue.toIntValue()?.toString() ?? 'null';
    if (type.isDartCoreString) {
      final s = constantValue.toStringValue();
      return s != null ? "'${_escapeDartString(s)}'" : 'null';
    }
    if (type.isDartCoreBool) return constantValue.toBoolValue()?.toString() ?? 'null';
    if (type.isDartCoreDouble) return constantValue.toDoubleValue()?.toString() ?? 'null';
    if (type.isDartCoreList) {
      final listValues = constantValue.toListValue()!;
      final typeStr = nonNullableTypeReference.symbol!;
      if (typeStr == 'List<int>') {
        final values = listValues.map((e) => e.toIntValue()!.toString()).join(', ');
        return 'const <int>[$values]';
      }
      if (typeStr == 'List<double>') {
        final values = listValues.map((e) => e.toDoubleValue()!.toString()).join(', ');
        return 'const <double>[$values]';
      }
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

extension on ClassElement {
  /// Returns the public name for the generated class.
  /// - If the annotated class starts with `_` (private), strips it: `_AppPrefs` → `AppPrefs`.
  /// - Otherwise appends `Impl`: `AppPrefs` → `AppPrefsImpl`.
  String get generatedClassName {
    final n = name!;
    return n.startsWith('_') ? n.substring(1) : '${n}Impl';
  }

  /// Returns the interface name for the generated class.
  /// Always uses the original class name (without `_` or `Impl`) + `Base`.
  /// - `_AppPrefs` → `AppPrefsBase`
  /// - `AppPrefs`  → `AppPrefsBase`
  String get generatedInterfaceName {
    final n = name!;
    return '${n.startsWith('_') ? n.substring(1) : n}Base';
  }
}
