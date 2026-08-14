import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'extensions.dart';

/// Wraps [expr] in `await` when generating async code.
///
/// Set [parenthesize] when the awaited expression is embedded in a larger
/// expression (e.g. combined with `??`) so operator precedence is explicit.
String _awaitExpr(String expr, {required bool isAsync, bool parenthesize = false}) {
  if (!isAsync) return expr;
  return parenthesize ? '(await $expr)' : 'await $expr';
}

/// Wraps a [FieldElement] with computed properties used during code generation.
class SharedPrefField {
  /// Creates a [SharedPrefField] for the given [field].
  SharedPrefField(this.field);

  /// The underlying field element.
  final FieldElement field;

  static const _prefKeyChecker = TypeChecker.fromUrl(
    'package:shared_prefs_typed_annotations/src/pref_key.dart#PrefKey',
  );

  static const _prefDateTimeChecker = TypeChecker.fromUrl(
    'package:shared_prefs_typed_annotations/src/pref_date_time.dart#PrefDateTime',
  );

  static const _supportedTypes = {
    'int',
    'double',
    'bool',
    'String',
    'List<String>',
    'List<int>',
    'List<double>',
    'List<bool>',
  };

  // The `!` is safe here because a `static const` field, which is the only
  // kind we process, is syntactically required to have a name.
  /// The field's Dart identifier name.
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
  String get baseName => name.startsWith('_') ? name.substring(1) : name;

  /// The SharedPreferences storage key — uses `@PrefKey` override if present.
  String get keyName {
    final override = _prefKeyOverride;
    if (override != null) return override;
    return baseName;
  }

  /// The PascalCase public name used in generated setter/remove/contains names.
  String get publicName => baseName.toPascalCase();

  /// The camelCase name used as the generated getter name and parameter name.
  String get paramName => baseName.toCamelCase();

  /// A [Reference] for the full field type (including nullability).
  Reference get typeReference => refer(field.type.getDisplayString());

  /// Whether the field type is nullable.
  bool get isNullable => field.type.nullabilitySuffix == NullabilitySuffix.question;

  /// A [Reference] for the non-nullable variant of the field type.
  Reference get nonNullableTypeReference {
    final typeString = field.type.getDisplayString();
    final nonNullableString = isNullable
        ? typeString.substring(0, typeString.length - 1)
        : typeString;
    return refer(nonNullableString);
  }

  /// True when the field is nullable but its default is not null.
  /// In this case the getter can safely return the non-nullable type.
  bool get _hasNonNullDefault => isNullable && defaultValue != 'null';

  /// Return type for getters: narrows to non-nullable when [_hasNonNullDefault].
  Reference get getterTypeReference =>
      _hasNonNullDefault ? nonNullableTypeReference : typeReference;

  /// Whether the field type is an enum.
  bool get _isEnum {
    final element = field.type.element;
    return element is EnumElement;
  }

  /// The enum type name (e.g. `'ThemeMode'`), only valid when [_isEnum] is true.
  String get _enumTypeName => nonNullableTypeReference.symbol!;

  /// Whether the field type is [DateTime].
  bool get isDateTime => nonNullableTypeReference.symbol == 'DateTime';

  /// Returns the [DateTimeEncoding] for this field, or `null` if no
  /// `@PrefDateTime` annotation is present.
  DateTimeEncoding? get dateTimeEncoding {
    final value = _prefDateTimeChecker.firstAnnotationOfExact(field);
    if (value == null) return null;
    final index = value.getField('encoding')?.getField('index')?.toIntValue();
    if (index == null) return null;
    return DateTimeEncoding.values[index];
  }

  /// True when the non-nullable type is `List<String>` (not a numeric list).
  bool get _isStringList => nonNullableTypeReference.symbol == 'List<String>';

  /// True when the non-nullable type is `List<bool>`.
  bool get _isBoolList => nonNullableTypeReference.symbol == 'List<bool>';

  /// True when the field is a `List` whose element type is an enum.
  bool get _isEnumList {
    final type = field.type;
    if (type is! InterfaceType) return false;
    if (type.typeArguments.isEmpty) return false;
    return type.typeArguments.first.element is EnumElement;
  }

  /// The enum element type name for `List<EnumType>` fields (e.g. `'ThemeMode'`).
  String get _enumListElementTypeName {
    return (field.type as InterfaceType).typeArguments.first.element!.name!;
  }

  /// Returns `'int'` or `'double'` for `List<int>`/`List<double>`, `null` otherwise.
  String? get _numericListElementType {
    final typeString = nonNullableTypeReference.symbol!;
    if (typeString == 'List<int>') return 'int';
    if (typeString == 'List<double>') return 'double';
    return null;
  }

  /// Maps the field type to its SharedPreferences method suffix (e.g. `'Int'`, `'String'`).
  String get prefTypeName {
    if (_isEnum) return 'String';
    if (_isEnumList) return 'StringList';
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
    if (typeString == 'List<bool>') return 'StringList';
    if (!_supportedTypes.contains(typeString)) {
      throw InvalidGenerationSourceError(
        'The field `$name` has unsupported type `${field.type.getDisplayString()}`. '
        'Supported types are: ${_supportedTypes.join(', ')}, Enum types, '
        'List<Enum>, DateTime (and their nullable variants).',
        element: field,
      );
    }
    return typeString.toPascalCase();
  }

  /// The Dart expression representing the field's compile-time default value.
  String get defaultValue {
    // DateTime has no const constructors; the non-null default comes from @PrefDateTime.
    if (isDateTime) {
      final millis = _prefDateTimeChecker
          .firstAnnotationOfExact(field)
          ?.getField('defaultMillis')
          ?.toIntValue();
      if (millis != null) return 'DateTime.fromMillisecondsSinceEpoch($millis)';
      return 'null';
    }
    final constantValue = field.computeConstantValue();
    if (constantValue == null || constantValue.isNull) return 'null';

    final type = constantValue.type;
    if (type == null) return 'null';
    if (_isEnum) {
      final enumName = constantValue.getField('_name')?.toStringValue();
      if (enumName != null) return '$_enumTypeName.$enumName';
      return 'null';
    }
    if (type.isDartCoreInt) return constantValue.toIntValue()?.toString() ?? 'null';
    if (type.isDartCoreString) {
      final s = constantValue.toStringValue();
      return s != null ? "'${escapeDartString(s)}'" : 'null';
    }
    if (type.isDartCoreBool) return constantValue.toBoolValue()?.toString() ?? 'null';
    if (type.isDartCoreDouble) return constantValue.toDoubleValue()?.toString() ?? 'null';
    if (type.isDartCoreList) {
      final listValues = constantValue.toListValue()!;
      final typeStr = nonNullableTypeReference.symbol!;
      if (_isEnumList) {
        final typeName = _enumListElementTypeName;
        final values = listValues
            .map((e) {
              final enumName = e.getField('_name')?.toStringValue();
              return '$typeName.$enumName';
            })
            .join(', ');
        return 'const <$typeName>[$values]';
      }
      if (typeStr == 'List<int>') {
        final values = listValues.map((e) => e.toIntValue()!.toString()).join(', ');
        return 'const <int>[$values]';
      }
      if (typeStr == 'List<double>') {
        final values = listValues.map((e) => e.toDoubleValue()!.toString()).join(', ');
        return 'const <double>[$values]';
      }
      if (typeStr == 'List<bool>') {
        final values = listValues.map((e) => e.toBoolValue()!.toString()).join(', ');
        return 'const <bool>[$values]';
      }
      final stringValues = listValues
          .map((DartObject e) => "'${escapeDartString(e.toStringValue()!)}'")
          .join(', ');
      return 'const <String>[$stringValues]';
    }
    return 'null';
  }

  /// Returns the [Code] for this field's getter body.
  Code getterBody({required bool isAsync}) => switch (this) {
    _ when _isEnum => _enumGetterBody(isAsync: isAsync),
    _ when _isEnumList => _enumListGetterBody(isAsync: isAsync),
    _ when isDateTime => _dateTimeGetterBody(isAsync: isAsync),
    _ when _isStringList => _stringListGetterBody(isAsync: isAsync),
    _ when _isBoolList => _boolListGetterBody(isAsync: isAsync),
    _ when _numericListElementType != null => _numericListGetterBody(isAsync: isAsync),
    _ => _defaultGetterBody(isAsync: isAsync),
  };

  /// Returns the [Code] for this field's setter body.
  Code get setterBody => switch (this) {
    _ when _isEnum => _enumSetterBody(),
    _ when _isEnumList => _enumListSetterBody(),
    _ when _isBoolList => _boolListSetterBody(),
    _ when isDateTime => _dateTimeSetterBody(),
    _ when _numericListElementType != null => _numericListSetterBody(),
    _ => _defaultSetterBody(),
  };

  Code _enumGetterBody({required bool isAsync}) {
    final key = keyName;
    final defaultExpr = defaultValue;
    final rawExpr = _awaitExpr("_prefs.getString('$key')", isAsync: isAsync, parenthesize: true);
    if (isNullable && !_hasNonNullDefault) {
      return Code(
        'try {\n'
        '  final raw = $rawExpr;\n'
        '  if (raw == null) return null;\n'
        '  return $_enumTypeName.values.byName(raw);\n'
        '} catch (e) {\n'
        "  _onReadError?.call('$key', e);\n"
        '  return null;\n'
        '}',
      );
    }
    return Code(
      'try {\n'
      '  final raw = $rawExpr;\n'
      '  if (raw == null) return $defaultExpr;\n'
      '  return $_enumTypeName.values.byName(raw);\n'
      '} catch (e) {\n'
      "  _onReadError?.call('$key', e);\n"
      '  return $defaultExpr;\n'
      '}',
    );
  }

  Code _enumListGetterBody({required bool isAsync}) {
    final key = keyName;
    final typeName = _enumListElementTypeName;
    final defaultExpr = isNullable && !_hasNonNullDefault ? 'null' : defaultValue;
    final rawExpr = _awaitExpr("_prefs.getStringList('$key')", isAsync: isAsync);
    final successExpr = 'List.unmodifiable(raw.map($typeName.values.byName).toList())';
    return Code(
      'try {\n'
      '  final raw = $rawExpr;\n'
      '  return raw == null ? $defaultExpr : $successExpr;\n'
      '} catch (e) {\n'
      "  _onReadError?.call('$key', e);\n"
      '  return $defaultExpr;\n'
      '}',
    );
  }

  Code _dateTimeGetterBody({required bool isAsync}) {
    final key = keyName;
    final defaultExpr = defaultValue;
    final isMillis = dateTimeEncoding == DateTimeEncoding.millisecondsSinceEpoch;
    if (isMillis) {
      final rawExpr = _awaitExpr("_prefs.getInt('$key')", isAsync: isAsync, parenthesize: true);
      return Code(
        'try {\n'
        '  final raw = $rawExpr;\n'
        '  if (raw == null) return $defaultExpr;\n'
        '  return DateTime.fromMillisecondsSinceEpoch(raw);\n'
        '} catch (e) {\n'
        "  _onReadError?.call('$key', e);\n"
        '  return $defaultExpr;\n'
        '}',
      );
    }
    final rawExpr = _awaitExpr("_prefs.getString('$key')", isAsync: isAsync, parenthesize: true);
    return Code(
      'final raw = $rawExpr;\n'
      'if (raw == null) return $defaultExpr;\n'
      'try {\n'
      'return DateTime.parse(raw);\n'
      '} catch (e) {\n'
      "  _onReadError?.call('$key', e);\n"
      'return $defaultExpr;\n'
      '}',
    );
  }

  Code _stringListGetterBody({required bool isAsync}) {
    final key = keyName;
    final rawExpr = _awaitExpr("_prefs.getStringList('$key')", isAsync: isAsync);
    if (isNullable && !_hasNonNullDefault) {
      return Code(
        'final raw = $rawExpr;\n'
        'return raw == null ? null : List.unmodifiable(raw);',
      );
    }
    return Code(
      'final raw = $rawExpr;\n'
      'return raw == null ? $defaultValue : List.unmodifiable(raw);',
    );
  }

  Code _numericListGetterBody({required bool isAsync}) {
    final key = keyName;
    final elementType = _numericListElementType!;
    final defaultExpr = isNullable && !_hasNonNullDefault ? 'null' : defaultValue;
    final rawExpr = _awaitExpr("_prefs.getStringList('$key')", isAsync: isAsync);
    final successExpr = 'List.unmodifiable(raw.map($elementType.parse).toList())';
    return Code(
      'try {\n'
      '  final raw = $rawExpr;\n'
      '  return raw == null ? $defaultExpr : $successExpr;\n'
      '} catch (e) {\n'
      "  _onReadError?.call('$key', e);\n"
      '  return $defaultExpr;\n'
      '}',
    );
  }

  Code _boolListGetterBody({required bool isAsync}) {
    final key = keyName;
    final defaultExpr = isNullable && !_hasNonNullDefault ? 'null' : defaultValue;
    final rawExpr = _awaitExpr("_prefs.getStringList('$key')", isAsync: isAsync);
    const successExpr = "List.unmodifiable(raw.map((e) => e == 'true').toList())";
    return Code(
      'final raw = $rawExpr;\n'
      'return raw == null ? $defaultExpr : $successExpr;',
    );
  }

  Code _defaultGetterBody({required bool isAsync}) {
    final key = keyName;
    final defaultExpr = defaultValue;
    final getExpr = _awaitExpr(
      "_prefs.get$prefTypeName('$key')",
      isAsync: isAsync,
      parenthesize: true,
    );
    return Code(
      'try {\n'
      "  return $getExpr${defaultExpr == 'null' ? '' : ' ?? $defaultExpr'};\n"
      '} catch (e) {\n'
      "  _onReadError?.call('$key', e);\n"
      '  return $defaultExpr;\n'
      '}',
    );
  }

  Code _enumSetterBody() => isNullable
      ? Code(
          "if (value == null) { return _prefs.remove('$keyName'); } "
          "return _prefs.setString('$keyName', value.name);",
        )
      : Code("return _prefs.setString('$keyName', value.name);");

  Code _enumListSetterBody() => isNullable
      ? Code(
          "if (value == null) { return _prefs.remove('$keyName'); } "
          "return _prefs.setStringList('$keyName', value.map((e) => e.name).toList());",
        )
      : Code(
          "return _prefs.setStringList('$keyName', value.map((e) => e.name).toList());",
        );

  Code _boolListSetterBody() => isNullable
      ? Code(
          "if (value == null) { return _prefs.remove('$keyName'); } "
          "return _prefs.setStringList('$keyName', value.map((e) => e.toString()).toList());",
        )
      : Code(
          "return _prefs.setStringList('$keyName', value.map((e) => e.toString()).toList());",
        );

  Code _dateTimeSetterBody() {
    final key = keyName;
    final isMillis = dateTimeEncoding == DateTimeEncoding.millisecondsSinceEpoch;
    final setExpr = isMillis
        ? "return _prefs.setInt('$key', value.millisecondsSinceEpoch);"
        : "return _prefs.setString('$key', value.toIso8601String());";
    // DateTime fields are always nullable.
    return Code("if (value == null) { return _prefs.remove('$key'); } $setExpr");
  }

  Code _numericListSetterBody() => isNullable
      ? Code(
          "if (value == null) { return _prefs.remove('$keyName'); } "
          "return _prefs.setStringList('$keyName', value.map((e) => e.toString()).toList());",
        )
      : Code(
          "return _prefs.setStringList('$keyName', value.map((e) => e.toString()).toList());",
        );

  Code _defaultSetterBody() => isNullable
      ? Code(
          "if (value == null) { return _prefs.remove('$keyName'); } "
          "return _prefs.set$prefTypeName('$keyName', value);",
        )
      : Code("return _prefs.set$prefTypeName('$keyName', value);");
}

/// Escapes a string value for use in a single-quoted Dart string literal.
String escapeDartString(String value) => value
    .replaceAll(r'\', r'\\')
    .replaceAll("'", r"\'")
    .replaceAll(r'$', r'\$')
    .replaceAll('\n', r'\n')
    .replaceAll('\r', r'\r')
    .replaceAll('\t', r'\t');
