part of 'pool_segment_editor_sheet.dart';

class _NormalSegmentFields extends StatelessWidget {
  const _NormalSegmentFields({
    required this.saving,
    required this.surahs,
    required this.surahId,
    required this.fullSurah,
    required this.master,
    required this.existing,
    required this.startCtl,
    required this.endCtl,
    required this.formKey,
    required this.onSurahChanged,
    required this.onFullSurahChanged,
    required this.onSubmit,
    this.duplicateError,
  });

  final bool saving;
  final List<Surah> surahs;
  final int surahId;
  final bool fullSurah;
  final Surah master;
  final SurahPoolEntry? existing;
  final TextEditingController startCtl;
  final TextEditingController endCtl;
  final GlobalKey<FormState> formKey;
  final ValueChanged<int?> onSurahChanged;
  final ValueChanged<bool> onFullSurahChanged;
  final VoidCallback onSubmit;
  final String? duplicateError;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final languageCode = Localizations.localeOf(context).languageCode;
    final selectedSurah = surahs.firstWhere((surah) => surah.id == surahId);
    final selectedLabel =
        '${selectedSurah.id}. ${selectedSurah.localizedName(languageCode)}';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextFormField(
          key: ValueKey(surahId),
          initialValue: selectedLabel,
          readOnly: true,
          enabled: !saving,
          decoration: mergeAppInputDecoration(
            context,
            InputDecoration(
              labelText: s.editorSurahLabel,
              suffixIcon: const Icon(Icons.search_rounded),
            ),
          ),
          validator: FormBuilderValidators.required<String>(),
          onTap: saving
              ? null
              : () async {
                  final pickedId = await showModalBottomSheet<int>(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.85,
                    ),
                    builder: (ctx) => _SurahPickerSheet(
                      surahs: surahs,
                      selectedSurahId: surahId,
                    ),
                  );
                  if (pickedId != null && pickedId != surahId) {
                    onSurahChanged(pickedId);
                  }
                },
        ),
        if (duplicateError != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const SizedBox(width: 4),
              Icon(Icons.warning_amber_rounded, size: 14, color: scheme.error),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  duplicateError!,
                  style: AppTextStyles.meta.copyWith(color: scheme.error),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          title: Text(s.editorEntireSurah),
          subtitle: Text(
            fullSurah ? s.editorEntireSurahOn : s.editorEntireSurahOff,
            style: AppTextStyles.meta,
          ),
          value: fullSurah,
          onChanged: saving ? null : onFullSurahChanged,
        ),
        if (!fullSurah) ...[
          const SizedBox(height: 8),
          Text(
            s.editorAyatCount(master.ayatCount),
            style: AppTextStyles.meta.copyWith(color: AppColors.ink3),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextFormField(
                  controller: startCtl,
                  decoration: InputDecoration(labelText: s.editorStartAyah),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: PoolSegmentFormValidators.startAyah(master),
                  onChanged: (_) => formKey.currentState?.validate(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextFormField(
                  controller: endCtl,
                  decoration: InputDecoration(labelText: s.editorEndAyah),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: PoolSegmentFormValidators.endAyah(
                    master,
                    () => startCtl.text,
                  ),
                  onChanged: (_) => formKey.currentState?.validate(),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        GradientButton(
          label: existing == null ? s.editorAddButton : s.editorSaveButton,
          enabled: !saving,
          onPressed: saving ? null : onSubmit,
        ),
      ],
    );
  }
}
