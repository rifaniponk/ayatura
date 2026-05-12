part of 'pool_segment_editor_sheet.dart';

class _BulkByJuzPanel extends ConsumerWidget {
  const _BulkByJuzPanel({
    super.key,
    required this.saving,
    required this.selectedJuz,
    required this.surahs,
    required this.lang,
    required this.checkedIds,
    required this.onJuzChanged,
    required this.onToggleSurah,
    required this.onSelectAll,
    required this.onDeselectAll,
    required this.onSubmit,
  });

  final bool saving;
  final int selectedJuz;
  final List<Surah> surahs;
  final String lang;
  final Set<int> checkedIds;
  final ValueChanged<int?> onJuzChanged;
  final void Function(int surahId, bool checked) onToggleSurah;
  final void Function(Set<int> poolSurahIds) onSelectAll;
  final VoidCallback onDeselectAll;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final poolAsync = ref.watch(poolEntriesAsyncProvider);
    final pool = poolAsync.maybeWhen(data: (p) => p, orElse: () => null);

    if (pool == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final poolSurahIds = pool.map((e) => e.surahId).toSet();
    final inJuz = surahsBelongingToJuz(surahs, selectedJuz);
    final bulkCount = checkedIds.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppDropdownButtonFormField<int>(
          key: ValueKey('juz_$selectedJuz'),
          initialValue: selectedJuz,
          decoration: mergeAppInputDecoration(
            context,
            InputDecoration(labelText: s.editorJuzLabel),
          ),
          items: [
            for (var j = 1; j <= 30; j++)
              DropdownMenuItem(value: j, child: Text(s.editorJuzOption(j))),
          ],
          onChanged: saving ? null : onJuzChanged,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            TextButton(
              onPressed: saving ? null : () => onSelectAll(poolSurahIds),
              child: Text(s.editorSelectAll),
            ),
            TextButton(
              onPressed: saving ? null : onDeselectAll,
              child: Text(s.editorDeselectAll),
            ),
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: (MediaQuery.sizeOf(context).height * 0.50) - 100,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: inJuz.length,
            itemBuilder: (context, index) {
              final surah = inJuz[index];
              final already = poolSurahIds.contains(surah.id);
              final label = '${surah.id}. ${surah.localizedName(lang)}';

              if (already) {
                return ListTile(
                  leading: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.ink3,
                  ),
                  title: Text(label, style: TextStyle(color: AppColors.ink3)),
                  subtitle: Text(
                    s.editorAlreadyAdded,
                    style: AppTextStyles.meta.copyWith(color: AppColors.ink3),
                  ),
                );
              }

              final checked = checkedIds.contains(surah.id);
              return CheckboxListTile(
                value: checked,
                onChanged: saving
                    ? null
                    : (v) => onToggleSurah(surah.id, v ?? false),
                title: Text(label),
                controlAffinity: ListTileControlAffinity.leading,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        GradientButton(
          label: s.editorBulkAddButton(bulkCount),
          enabled: !saving && bulkCount > 0,
          onPressed: saving || bulkCount == 0 ? null : onSubmit,
        ),
      ],
    );
  }
}
