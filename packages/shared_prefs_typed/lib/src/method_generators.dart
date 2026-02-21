import 'package:code_builder/code_builder.dart';

import 'shared_pref_field.dart';
import 'type_body_builders.dart';

/// Generates the synchronous getter [Method] for the given [field].
Method generateSyncGetter(SharedPrefField field) {
  final Code body;
  if (field.isEnum) {
    final key = field.keyName;
    final defaultExpr = field.defaultValue;
    final rawExpr = "_prefs.getString('$key')";
    if (field.isNullable && !field.hasNonNullDefault) {
      body = Code(
        'try {\n'
        '  final raw = $rawExpr;\n'
        '  if (raw == null) return null;\n'
        '  return ${field.enumTypeName}.values.byName(raw);\n'
        '} catch (e) {\n'
        "  _onReadError?.call('$key', e);\n"
        '  return null;\n'
        '}',
      );
    } else {
      body = Code(
        'try {\n'
        '  final raw = $rawExpr;\n'
        '  if (raw == null) return $defaultExpr;\n'
        '  return ${field.enumTypeName}.values.byName(raw);\n'
        '} catch (e) {\n'
        "  _onReadError?.call('$key', e);\n"
        '  return $defaultExpr;\n'
        '}',
      );
    }
  } else if (field.isEnumList) {
    body = Code(buildEnumListSyncGetterBody(field));
  } else if (field.isDateTime) {
    body = Code(buildDateTimeSyncGetterBody(field));
  } else if (field.isStringList) {
    body = Code(buildStringListSyncGetterBody(field));
  } else if (field.isBoolList) {
    body = Code(buildBoolListSyncGetterBody(field));
  } else if (field.numericListElementType != null) {
    body = Code(buildNumericListSyncGetterBody(field));
  } else {
    final key = field.keyName;
    final defaultExpr = field.defaultValue;
    final getExpr = "_prefs.get${field.prefTypeName}('$key')";
    body = Code(
      'try {\n'
      "  return $getExpr${defaultExpr == 'null' ? '' : ' ?? $defaultExpr'};\n"
      '} catch (e) {\n'
      "  _onReadError?.call('$key', e);\n"
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

/// Generates the asynchronous getter [Method] for the given [field].
Method generateAsyncGetter(SharedPrefField field) {
  final Code body;
  if (field.isEnum) {
    final key = field.keyName;
    final defaultExpr = field.defaultValue;
    final rawExpr = "(await _prefs.getString('$key'))";
    if (field.isNullable && !field.hasNonNullDefault) {
      body = Code(
        'try {\n'
        '  final raw = $rawExpr;\n'
        '  if (raw == null) return null;\n'
        '  return ${field.enumTypeName}.values.byName(raw);\n'
        '} catch (e) {\n'
        "  _onReadError?.call('$key', e);\n"
        '  return null;\n'
        '}',
      );
    } else {
      body = Code(
        'try {\n'
        '  final raw = $rawExpr;\n'
        '  if (raw == null) return $defaultExpr;\n'
        '  return ${field.enumTypeName}.values.byName(raw);\n'
        '} catch (e) {\n'
        "  _onReadError?.call('$key', e);\n"
        '  return $defaultExpr;\n'
        '}',
      );
    }
  } else if (field.isEnumList) {
    body = Code(buildEnumListAsyncGetterBody(field));
  } else if (field.isDateTime) {
    body = Code(buildDateTimeAsyncGetterBody(field));
  } else if (field.isStringList) {
    body = Code(buildStringListAsyncGetterBody(field));
  } else if (field.isBoolList) {
    body = Code(buildBoolListAsyncGetterBody(field));
  } else if (field.numericListElementType != null) {
    body = Code(buildNumericListAsyncGetterBody(field));
  } else {
    final key = field.keyName;
    final defaultExpr = field.defaultValue;
    final getExpr = "(await _prefs.get${field.prefTypeName}('$key'))";
    body = Code(
      'try {\n'
      "  return $getExpr${defaultExpr == 'null' ? '' : ' ?? $defaultExpr'};\n"
      '} catch (e) {\n'
      "  _onReadError?.call('$key', e);\n"
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

/// Generates the setter [Method] for the given [field].
Method generateSetter(SharedPrefField field) {
  final Code body;
  if (field.isEnum) {
    body = field.isNullable
        ? Code(
            "if (value == null) { return _prefs.remove('${field.keyName}'); } "
            "return _prefs.setString('${field.keyName}', value.name);",
          )
        : Code("return _prefs.setString('${field.keyName}', value.name);");
  } else if (field.isEnumList) {
    body = field.isNullable
        ? Code(
            "if (value == null) { return _prefs.remove('${field.keyName}'); } "
            "return _prefs.setStringList('${field.keyName}', value.map((e) => e.name).toList());",
          )
        : Code(
            "return _prefs.setStringList('${field.keyName}', value.map((e) => e.name).toList());",
          );
  } else if (field.isBoolList) {
    body = field.isNullable
        ? Code(
            "if (value == null) { return _prefs.remove('${field.keyName}'); } "
            "return _prefs.setStringList('${field.keyName}', value.map((e) => e.toString()).toList());",
          )
        : Code(
            "return _prefs.setStringList('${field.keyName}', value.map((e) => e.toString()).toList());",
          );
  } else if (field.isDateTime) {
    body = buildDateTimeSetterBody(field);
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

/// Generates the `contains*` existence check [Method] for the given [field].
Method generateIsSet(SharedPrefField field, {required bool isAsync}) => Method(
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

/// Generates the `remove*` [Method] for the given [field].
Method generateRemover(SharedPrefField field) => Method(
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

/// Generates the `clearAll` [Method] that removes all managed preferences.
Method generateClearAll(List<SharedPrefField> fields) {
  final String body;
  if (fields.isEmpty) {
    body = 'return Future.value();';
  } else {
    final removes = fields.map((f) => "_prefs.remove('${f.keyName}')").join(',\n    ');
    body = 'return Future.wait([\n    $removes,\n  ]);';
  }
  return Method(
    (b) => b
      ..name = 'clearAll'
      ..docs.add('/// Removes all preferences managed by this class from storage.')
      ..docs.add('///')
      ..docs.add('/// After calling this, all getters return their default values.')
      ..docs.add('///')
      ..docs.add(
        '/// **Note:** This operation is not atomic. Concurrent writes during this',
      )
      ..docs.add(
        '/// operation may result in keys remaining in storage.',
      )
      ..returns = refer('Future<void>')
      ..body = Code(body),
  );
}
