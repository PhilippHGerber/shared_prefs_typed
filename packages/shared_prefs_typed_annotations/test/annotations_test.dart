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
}
