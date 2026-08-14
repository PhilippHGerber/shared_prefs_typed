import 'package:code_builder/code_builder.dart';

import 'shared_pref_field.dart';

/// Generates the getter [Method] for the given [field].
Method generateGetter(SharedPrefField field, {required bool isAsync}) => Method(
  (b) => b
    ..name = field.paramName
    ..docs.add(
      isAsync
          ? '/// Asynchronously gets the value for `${field.keyName}`.'
          : '/// Gets the value for `${field.keyName}` from the cache.',
    )
    ..docs.add('///')
    ..docs.add(
      '/// If the key does not exist, the default value `${field.defaultValue}` is returned.',
    )
    ..type = MethodType.getter
    ..returns = isAsync
        ? refer('Future<${field.getterTypeReference.symbol}>')
        : field.getterTypeReference
    ..modifier = isAsync ? MethodModifier.async : null
    ..body = field.getterBody(isAsync: isAsync),
);

/// Generates the setter [Method] for the given [field].
Method generateSetter(SharedPrefField field) {
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
      ..body = field.setterBody,
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
