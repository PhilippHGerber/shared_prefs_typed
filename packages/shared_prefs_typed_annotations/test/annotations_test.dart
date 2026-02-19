import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:test/test.dart';

void main() {
  group('TypedPrefs — mode parameter', () {
    test('defaults to null when neither mode nor async is set', () {
      const annotation = TypedPrefs();
      expect(annotation.mode, isNull);
    });

    test('accepts mode: PrefsMode.cached', () {
      const annotation = TypedPrefs(mode: PrefsMode.cached);
      expect(annotation.mode, PrefsMode.cached);
    });

    test('accepts mode: PrefsMode.async', () {
      const annotation = TypedPrefs(mode: PrefsMode.async);
      expect(annotation.mode, PrefsMode.async);
    });
  });

  group('TypedPrefs — deprecated async parameter (backwards compatibility)', () {
    test('async defaults to false', () {
      const annotation = TypedPrefs();
      // ignore: deprecated_member_use_from_same_package
      expect(annotation.async, isFalse);
    });

    test('async: true is still accepted', () {
      // ignore: deprecated_member_use_from_same_package
      const annotation = TypedPrefs(async: true);
      // ignore: deprecated_member_use_from_same_package
      expect(annotation.async, isTrue);
    });

    test('async: false is still accepted', () {
      // ignore: deprecated_member_use_from_same_package, avoid_redundant_argument_values
      const annotation = TypedPrefs(async: false);
      // ignore: deprecated_member_use_from_same_package
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

  group('PrefsMode', () {
    test('has exactly two values', () {
      expect(PrefsMode.values, hasLength(2));
    });

    test('cached is the first value (index 0)', () {
      expect(PrefsMode.cached.index, 0);
    });

    test('async is the second value (index 1)', () {
      expect(PrefsMode.async.index, 1);
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
