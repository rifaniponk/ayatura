import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/providers.dart';
import '../widgets/insight/insight_body.dart';

class InsightScreen extends ConsumerWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final frequencyAsync = ref.watch(hifdhFrequencyProvider);
    final surahsAsync = ref.watch(surahsAsyncProvider);

    return switch ((frequencyAsync, surahsAsync)) {
      (AsyncError(:final error), _) || (_, AsyncError(:final error)) => Center(
        child: Text(s.errorGeneric('$error')),
      ),
      (AsyncData(value: final frequencies), AsyncData(value: final surahs)) =>
        InsightBody(frequencies: frequencies, surahs: surahs),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
