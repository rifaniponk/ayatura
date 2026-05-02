import 'package:flutter/widgets.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'models/surah.dart';

/// [FormBuilderValidators]-based rules for pool ayah fields (partial segments).
abstract final class PoolSegmentFormValidators {
  static List<FormFieldValidator<String>> _ayahInSurah(Surah master) => [
    FormBuilderValidators.required<String>(),
    FormBuilderValidators.integer(),
    FormBuilderValidators.min<String>(1),
    FormBuilderValidators.max<String>(master.ayatCount),
  ];

  /// Start ayah: required integer in \[1, master.ayatCount\].
  static FormFieldValidator<String> startAyah(Surah master) =>
      FormBuilderValidators.compose(_ayahInSurah(master));

  /// End ayah: same bounds plus must be ≥ start ayah (reads live start field text).
  static FormFieldValidator<String> endAyah(
    Surah master,
    String Function() startFieldText,
  ) => FormBuilderValidators.compose([
    ..._ayahInSurah(master),
    (String? val) {
      final start = int.tryParse(startFieldText().trim());
      final end = int.tryParse(val?.trim() ?? '');
      if (start == null || end == null) return null;
      if (start > end) return 'Start ayah cannot be after end ayah.';
      return null;
    },
  ]);
}
