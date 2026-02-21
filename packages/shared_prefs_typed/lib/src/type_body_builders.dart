import 'package:code_builder/code_builder.dart';
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

import 'shared_pref_field.dart';

//--- DateTime helpers ---//

/// Generates the sync getter body for a [DateTime] field.
String buildDateTimeSyncGetterBody(SharedPrefField field) {
  final key = field.keyName;
  final defaultExpr = field.defaultValue;
  final isMillis = field.dateTimeEncoding == DateTimeEncoding.millisecondsSinceEpoch;
  if (isMillis) {
    return 'try {\n'
        "  final raw = _prefs.getInt('$key');\n"
        '  if (raw == null) return $defaultExpr;\n'
        '  return DateTime.fromMillisecondsSinceEpoch(raw);\n'
        '} catch (e) {\n'
        "  _onReadError?.call('$key', e);\n"
        '  return $defaultExpr;\n'
        '}';
  }
  return "final raw = _prefs.getString('$key');\n"
      'if (raw == null) return $defaultExpr;\n'
      'try {\n'
      'return DateTime.parse(raw);\n'
      '} catch (e) {\n'
      "  _onReadError?.call('$key', e);\n"
      'return $defaultExpr;\n'
      '}';
}

/// Generates the async getter body for a [DateTime] field.
String buildDateTimeAsyncGetterBody(SharedPrefField field) {
  final key = field.keyName;
  final defaultExpr = field.defaultValue;
  final isMillis = field.dateTimeEncoding == DateTimeEncoding.millisecondsSinceEpoch;
  if (isMillis) {
    return 'try {\n'
        "  final raw = (await _prefs.getInt('$key'));\n"
        '  if (raw == null) return $defaultExpr;\n'
        '  return DateTime.fromMillisecondsSinceEpoch(raw);\n'
        '} catch (e) {\n'
        "  _onReadError?.call('$key', e);\n"
        '  return $defaultExpr;\n'
        '}';
  }
  return "final raw = (await _prefs.getString('$key'));\n"
      'if (raw == null) return $defaultExpr;\n'
      'try {\n'
      'return DateTime.parse(raw);\n'
      '} catch (e) {\n'
      "  _onReadError?.call('$key', e);\n"
      'return $defaultExpr;\n'
      '}';
}

/// Generates the setter body for a [DateTime] field.
Code buildDateTimeSetterBody(SharedPrefField field) {
  final key = field.keyName;
  final isMillis = field.dateTimeEncoding == DateTimeEncoding.millisecondsSinceEpoch;
  final setExpr = isMillis
      ? "return _prefs.setInt('$key', value.millisecondsSinceEpoch);"
      : "return _prefs.setString('$key', value.toIso8601String());";
  // DateTime fields are always nullable.
  return Code("if (value == null) { return _prefs.remove('$key'); } $setExpr");
}

//--- String list helpers ---//

/// Generates the sync getter body for a `List<String>` field.
String buildStringListSyncGetterBody(SharedPrefField field) {
  final key = field.keyName;
  final rawExpr = "_prefs.getStringList('$key')";
  if (field.isNullable && !field.hasNonNullDefault) {
    return 'final raw = $rawExpr;\n'
        'return raw == null ? null : List.unmodifiable(raw);';
  }
  return 'final raw = $rawExpr;\n'
      'return raw == null ? ${field.defaultValue} : List.unmodifiable(raw);';
}

/// Generates the async getter body for a `List<String>` field.
String buildStringListAsyncGetterBody(SharedPrefField field) {
  final key = field.keyName;
  final rawExpr = "await _prefs.getStringList('$key')";
  if (field.isNullable && !field.hasNonNullDefault) {
    return 'final raw = $rawExpr;\n'
        'return raw == null ? null : List.unmodifiable(raw);';
  }
  return 'final raw = $rawExpr;\n'
      'return raw == null ? ${field.defaultValue} : List.unmodifiable(raw);';
}

//--- Numeric list helpers ---//

/// Generates the sync getter body for a `List<int>` or `List<double>` field.
String buildNumericListSyncGetterBody(SharedPrefField field) {
  final key = field.keyName;
  final elementType = field.numericListElementType!;
  final defaultExpr = field.isNullable && !field.hasNonNullDefault ? 'null' : field.defaultValue;
  final rawExpr = "_prefs.getStringList('$key')";
  final successExpr = 'List.unmodifiable(raw.map($elementType.parse).toList())';
  return 'try {\n'
      '  final raw = $rawExpr;\n'
      '  return raw == null ? $defaultExpr : $successExpr;\n'
      '} catch (e) {\n'
      "  _onReadError?.call('$key', e);\n"
      '  return $defaultExpr;\n'
      '}';
}

/// Generates the async getter body for a `List<int>` or `List<double>` field.
String buildNumericListAsyncGetterBody(SharedPrefField field) {
  final key = field.keyName;
  final elementType = field.numericListElementType!;
  final defaultExpr = field.isNullable && !field.hasNonNullDefault ? 'null' : field.defaultValue;
  final rawExpr = "await _prefs.getStringList('$key')";
  final successExpr = 'List.unmodifiable(raw.map($elementType.parse).toList())';
  return 'try {\n'
      '  final raw = $rawExpr;\n'
      '  return raw == null ? $defaultExpr : $successExpr;\n'
      '} catch (e) {\n'
      "  _onReadError?.call('$key', e);\n"
      '  return $defaultExpr;\n'
      '}';
}

//--- Enum list helpers ---//

/// Generates the sync getter body for a `List<Enum>` field.
String buildEnumListSyncGetterBody(SharedPrefField field) {
  final key = field.keyName;
  final typeName = field.enumListElementTypeName;
  final defaultExpr = field.isNullable && !field.hasNonNullDefault ? 'null' : field.defaultValue;
  final rawExpr = "_prefs.getStringList('$key')";
  final successExpr = 'List.unmodifiable(raw.map($typeName.values.byName).toList())';
  return 'try {\n'
      '  final raw = $rawExpr;\n'
      '  return raw == null ? $defaultExpr : $successExpr;\n'
      '} catch (e) {\n'
      "  _onReadError?.call('$key', e);\n"
      '  return $defaultExpr;\n'
      '}';
}

/// Generates the async getter body for a `List<Enum>` field.
String buildEnumListAsyncGetterBody(SharedPrefField field) {
  final key = field.keyName;
  final typeName = field.enumListElementTypeName;
  final defaultExpr = field.isNullable && !field.hasNonNullDefault ? 'null' : field.defaultValue;
  final rawExpr = "await _prefs.getStringList('$key')";
  final successExpr = 'List.unmodifiable(raw.map($typeName.values.byName).toList())';
  return 'try {\n'
      '  final raw = $rawExpr;\n'
      '  return raw == null ? $defaultExpr : $successExpr;\n'
      '} catch (e) {\n'
      "  _onReadError?.call('$key', e);\n"
      '  return $defaultExpr;\n'
      '}';
}

//--- Bool list helpers ---//

/// Generates the sync getter body for a `List<bool>` field.
String buildBoolListSyncGetterBody(SharedPrefField field) {
  final key = field.keyName;
  final defaultExpr = field.isNullable && !field.hasNonNullDefault ? 'null' : field.defaultValue;
  final rawExpr = "_prefs.getStringList('$key')";
  const successExpr = "List.unmodifiable(raw.map((e) => e == 'true').toList())";
  return 'final raw = $rawExpr;\n'
      'return raw == null ? $defaultExpr : $successExpr;';
}

/// Generates the async getter body for a `List<bool>` field.
String buildBoolListAsyncGetterBody(SharedPrefField field) {
  final key = field.keyName;
  final defaultExpr = field.isNullable && !field.hasNonNullDefault ? 'null' : field.defaultValue;
  final rawExpr = "await _prefs.getStringList('$key')";
  const successExpr = "List.unmodifiable(raw.map((e) => e == 'true').toList())";
  return 'final raw = $rawExpr;\n'
      'return raw == null ? $defaultExpr : $successExpr;';
}
