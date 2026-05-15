import 'package:flutter/foundation.dart';

/// QA only. When true in debug, [appClockNow] is fixed to 1 May 2026 noon.
const bool useHardcodedTime = false;

/// Use instead of [DateTime.now] where the UI must stay consistent with Home.
DateTime appClockNow() {
  if (kDebugMode && useHardcodedTime) {
    return DateTime(2026, 5, 1, 12, 0, 0);
  }
  return DateTime.now();
}
