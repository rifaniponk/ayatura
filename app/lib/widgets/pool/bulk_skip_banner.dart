part of '../../screens/pool_screen.dart';

/// Transient error banner shown after a bulk insert skips already-existing entries.
///
/// Not persisted — dismissed by tapping the close icon and cleared when the
/// pool screen is rebuilt from a clean state.
class _BulkSkipBanner extends StatelessWidget {
  const _BulkSkipBanner({
    required this.skippedIds,
    required this.surahs,
    required this.lang,
    required this.onDismiss,
    this.dismissTooltip,
  });

  final List<int> skippedIds;
  final List<Surah> surahs;
  final String lang;
  final VoidCallback onDismiss;
  final String? dismissTooltip;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final masterById = {for (final su in surahs) su.id: su};

    final String message;
    if (skippedIds.length == 1) {
      final master = masterById[skippedIds.first];
      final label = master?.localizedName(lang) ?? 'Surah ${skippedIds.first}';
      message = s.hifdhBulkSkippedOne(label);
    } else {
      message = s.hifdhBulkSkippedMany(skippedIds.length);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Material(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 20,
                  color: scheme.onErrorContainer,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.smallLabel.copyWith(
                    color: scheme.onErrorContainer,
                    height: 1.35,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                tooltip: dismissTooltip ?? s.dismissTooltip,
                color: scheme.onErrorContainer,
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
