import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:test/test.dart';

void main() {
  group('TypedPrefs Annotation', () {
    test('can be instantiated with default (sync) mode', () {
      // ARRANGE & ACT: Instantiate the annotation.
      const annotation = TypedPrefs();

      // ASSERT: Verify the default value of the 'async' property.
      // This confirms the constructor works as expected.
      expect(annotation, isA<TypedPrefs>());
      expect(annotation.async, isFalse);
    });

    test('can be instantiated with async mode enabled', () {
      // ARRANGE & ACT: Instantiate the annotation with async set to true.
      const annotation = TypedPrefs(async: true);

      // ASSERT: Verify the value of the 'async' property is correctly set.
      expect(annotation, isA<TypedPrefs>());
      expect(annotation.async, isTrue);
    });

    test('can be instantiated with async mode explicitly disabled', () {
      // ARRANGE & ACT: Instantiate the annotation with async explicitly false.
      // ignore: avoid_redundant_argument_values
      const annotation = TypedPrefs(async: false);

      // ASSERT: Verify the value of the 'async' property is correctly set.
      expect(annotation.async, isFalse);
    });
  });

  group('PrefDateTime Annotation', () {
    test('can be instantiated with millisecondsSinceEpoch encoding', () {
      const annotation = PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch);
      expect(annotation, isA<PrefDateTime>());
      expect(annotation.encoding, DateTimeEncoding.millisecondsSinceEpoch);
    });

    test('can be instantiated with iso8601 encoding', () {
      const annotation = PrefDateTime(DateTimeEncoding.iso8601);
      expect(annotation.encoding, DateTimeEncoding.iso8601);
    });
  });

  group('DateTimeEncoding', () {
    test('has exactly two values', () {
      expect(DateTimeEncoding.values, hasLength(2));
    });
  });

  group('PrefKey Annotation', () {
    test('can be instantiated with a key', () {
      const annotation = PrefKey('my_key');
      expect(annotation, isA<PrefKey>());
      expect(annotation.key, 'my_key');
    });

    test('can be instantiated with an empty key', () {
      // The annotation itself allows empty strings; the generator validates.
      const annotation = PrefKey('');
      expect(annotation.key, '');
    });
  });
}
