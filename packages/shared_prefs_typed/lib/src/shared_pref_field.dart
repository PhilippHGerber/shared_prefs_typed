import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'extensions.dart';

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
  bool get hasNonNullDefault => isNullable && defaultValue != 'null';

  /// Return type for getters: narrows to non-nullable when [hasNonNullDefault].
  Reference get getterTypeReference => hasNonNullDefault ? nonNullableTypeReference : typeReference;

  /// Whether the field type is an enum.
  bool get isEnum {
    final element = field.type.element;
    return element is EnumElement;
  }

  /// The enum type name (e.g. `'ThemeMode'`), only valid when [isEnum] is true.
  String get enumTypeName => nonNullableTypeReference.symbol!;

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
  bool get isStringList => nonNullableTypeReference.symbol == 'List<String>';

  /// True when the non-nullable type is `List<bool>`.
  bool get isBoolList => nonNullableTypeReference.symbol == 'List<bool>';

  /// True when the field is a `List` whose element type is an enum.
  bool get isEnumList {
    final type = field.type;
    if (type is! InterfaceType) return false;
    if (type.typeArguments.isEmpty) return false;
    return type.typeArguments.first.element is EnumElement;
  }

  /// The enum element type name for `List<EnumType>` fields (e.g. `'ThemeMode'`).
  String get enumListElementTypeName {
    return (field.type as InterfaceType).typeArguments.first.element!.name!;
  }

  /// Returns `'int'` or `'double'` for `List<int>`/`List<double>`, `null` otherwise.
  String? get numericListElementType {
    final typeString = nonNullableTypeReference.symbol!;
    if (typeString == 'List<int>') return 'int';
    if (typeString == 'List<double>') return 'double';
    return null;
  }

  /// Maps the field type to its SharedPreferences method suffix (e.g. `'Int'`, `'String'`).
  String get prefTypeName {
    if (isEnum) return 'String';
    if (isEnumList) return 'StringList';
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
    if (isEnum) {
      final enumName = constantValue.getField('_name')?.toStringValue();
      if (enumName != null) return '$enumTypeName.$enumName';
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
      if (isEnumList) {
        final typeName = enumListElementTypeName;
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
}

/// Escapes a string value for use in a single-quoted Dart string literal.
String escapeDartString(String value) => value
    .replaceAll(r'\', r'\\')
    .replaceAll("'", r"\'")
    .replaceAll(r'$', r'\$')
    .replaceAll('\n', r'\n')
    .replaceAll('\r', r'\r')
    .replaceAll('\t', r'\t');
