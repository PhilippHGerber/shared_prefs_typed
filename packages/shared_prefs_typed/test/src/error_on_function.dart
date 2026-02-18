// This file is used as test input for error case validation.
// ignore_for_file: invalid_annotation_target

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

// Tests that @TypedPrefs on a non-class element (e.g. a top-level function)
// reports the correct error: "`@TypedPrefs` can only be used on classes."
@TypedPrefs()
void notAClass() {}
