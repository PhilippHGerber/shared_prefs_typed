import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'class_builder.dart';
import 'extensions.dart';
import 'shared_pref_field.dart';

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

    // Validate shared_preferences import is present (required for generated part file).
    const requiredImport = 'package:shared_preferences/shared_preferences.dart';
    final hasSharedPrefsImport = classElement.library.firstFragment.libraryImports.any(
      (import) {
        final uri = import.uri;
        return uri is DirectiveUriWithRelativeUriString && uri.relativeUriString == requiredImport;
      },
    );
    if (!hasSharedPrefsImport) {
      throw InvalidGenerationSourceError(
        'Missing required import for generated code. '
        "Add: import '$requiredImport';",
        element: element,
      );
    }

    // Validate dart:developer import is present (required for error boundary logging).
    const requiredDeveloperImport = 'dart:developer';
    final hasDeveloperImport = classElement.library.firstFragment.libraryImports.any(
      (import) {
        final uri = import.uri;
        return uri is DirectiveUriWithRelativeUriString &&
            uri.relativeUriString == requiredDeveloperImport;
      },
    );
    if (!hasDeveloperImport) {
      throw InvalidGenerationSourceError(
        'Missing required import for generated code. '
        "Add: import '$requiredDeveloperImport';",
        element: element,
      );
    }

    final modeReader = annotation.read('mode');
    final isAsyncMode =
        !modeReader.isNull && modeReader.objectValue.getField('_name')?.toStringValue() == 'async';
    final generateInterface = annotation.read('generateInterface').boolValue;

    final fields = classElement.fields
        .where((FieldElement field) => field.isStatic && field.isConst)
        .map<SharedPrefField>(SharedPrefField.new)
        .toList();

    // Validate fields.
    final seenKeys = <String, SharedPrefField>{};
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
      const reservedNames = {
        'init',
        'instance',
        'resetInstance',
        'clearAll',
        'prefs',
        'initFuture',
        'onReadError',
      };
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
        buildInterface(
          publicClassName,
          classElement.generatedInterfaceName,
          fields,
          isAsync: isAsyncMode,
        ),
      );
    }

    bodyItems.add(
      buildClass(classElement, fields, isAsync: isAsyncMode, generateInterface: generateInterface),
    );

    const warning =
        '/// WARNING: Storage keys are derived from field names. '
        'Renaming a field changes its key and causes data loss '
        'unless @PrefKey is used to pin the key explicitly.\n';

    final emitter = DartEmitter(useNullSafetySyntax: true, orderDirectives: true);
    final buffer = StringBuffer()..writeln(warning);
    for (final item in bodyItems) {
      buffer.writeln(item.accept(emitter));
    }
    return DartFormatter(languageVersion: Version(3, 9, 0)).format(buffer.toString());
  }
}
