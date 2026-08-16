import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

import 'extensions.dart';
import 'method_generators.dart';
import 'shared_pref_field.dart';

/// Builds the concrete class backed by `SharedPreferencesWithCache` (sync)
/// or `SharedPreferencesAsync` (async).
Class buildClass(
  ClassElement classElement,
  List<SharedPrefField> fields, {
  required bool isAsync,
  bool generateInterface = false,
}) {
  final publicClassName = classElement.generatedClassName;
  final prefsClassName = isAsync ? 'SharedPreferencesAsync' : 'SharedPreferencesWithCache';
  const prefsOptionsName = 'SharedPreferencesWithCacheOptions';

  return Class(
    (b) => b
      ..name = publicClassName
      ..docs.add(
        isAsync
            ? '/// Provides type-safe, asynchronous access to application preferences.'
            : '/// Provides type-safe, cached access to application preferences.',
      )
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
            ..name = '_onReadError'
            ..modifier = FieldModifier.final$
            ..docs.addAll([
              '/// Optional callback invoked when a stored value cannot be cast to its',
              '/// expected type (e.g. after a field type change between app versions).',
              '///',
              '/// Receives the preference key and the exception. Use this to forward',
              '/// errors to a crash reporter (Crashlytics, Sentry, etc.).',
            ])
            ..type = refer('void Function(String key, Object error)?'),
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
            )
            ..optionalParameters.add(
              Parameter(
                (p) => p
                  ..name = 'onReadError'
                  ..named = true
                  ..type = refer('void Function(String key, Object error)?'),
              ),
            )
            ..initializers.add(const Code('_onReadError = onReadError')),
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
            ..docs.add('///')
            ..docs.add(
              '/// Note: [onReadError] is captured only during the initial call to [init].',
            )
            ..docs.add(
              '/// Subsequent calls will return the existing instance and ignore new callbacks.',
            )
            ..returns = refer('Future<$publicClassName>')
            ..static = true
            ..optionalParameters.add(
              Parameter(
                (p) => p
                  ..name = 'onReadError'
                  ..named = true
                  ..type = refer('void Function(String key, Object error)?'),
              ),
            )
            ..body = const Code(
              'if (_instance != null) return Future.value(_instance!);\n'
              'return _initFuture ??= _doInit(onReadError: onReadError);',
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
            ..optionalParameters.add(
              Parameter(
                (p) => p
                  ..name = 'onReadError'
                  ..named = true
                  ..type = refer('void Function(String key, Object error)?'),
              ),
            )
            ..body = isAsync
                ? Code(
                    'try {\n'
                    '  return _instance = $publicClassName($prefsClassName(), onReadError: onReadError);\n'
                    '} catch (e) {\n'
                    '  _initFuture = null;\n'
                    '  rethrow;\n'
                    '}',
                  )
                : Code(
                    'try {\n'
                    '  final prefs = await $prefsClassName.create(cacheOptions: const $prefsOptionsName());\n'
                    '  return _instance = $publicClassName(prefs, onReadError: onReadError);\n'
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
            generateGetter(field, isAsync: isAsync),
            generateSetter(field),
            generateIsSet(field, isAsync: isAsync),
            generateRemover(field),
          ],
        ),
      )
      ..methods.add(generateClearAll(fields)),
  );
}

/// Builds the abstract interface class (emitted when `generateInterface: true`).
Class buildInterface(
  String implName,
  String interfaceName,
  List<SharedPrefField> fields, {
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
      )
      ..methods.add(
        Method(
          (m) => m
            ..name = 'clearAll'
            ..returns = refer('Future<void>'),
        ),
      ),
  );
}
