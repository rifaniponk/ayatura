import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';
import '../../data/models/surah.dart';
import '../../data/models/surah_pool_entry.dart';
import '../../validators/pool_segment_form_validators.dart';
import '../../providers/pool_mutations.dart';
import '../../providers/surah_data_providers.dart';
import '../common/app_dropdown_button.dart';
import '../common/app_text_form_field.dart';
import '../common/gradient_button.dart';

/// Surahs that overlap [juz] under the standard Hafs mushaf division.
List<Surah> surahsBelongingToJuz(List<Surah> surahs, int juz) {
  final list = surahs
      .where((s) => s.startJuz <= juz && s.endJuz >= juz)
      .toList();
  list.sort((a, b) => a.id.compareTo(b.id));
  return list;
}

Future<void> showPoolSegmentEditor(
  BuildContext context, {
  required List<Surah> surahs,
  SurahPoolEntry? existing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) =>
        _PoolSegmentEditorSheet(surahs: surahs, existing: existing),
  );
}

class _PoolSegmentEditorSheet extends ConsumerStatefulWidget {
  const _PoolSegmentEditorSheet({required this.surahs, this.existing});

  final List<Surah> surahs;
  final SurahPoolEntry? existing;

  @override
  ConsumerState<_PoolSegmentEditorSheet> createState() =>
      _PoolSegmentEditorSheetState();
}

class _PoolSegmentEditorSheetState
    extends ConsumerState<_PoolSegmentEditorSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late int? _surahId;
  late bool _fullSurah;
  late TextEditingController _startCtl;
  late TextEditingController _endCtl;
  bool _saving = false;

  bool _bulkMode = false;
  int _selectedJuz = 30;
  final Set<int> _bulkCheckedSurahIds = {};

  Surah get _surah => widget.surahs.firstWhere(
    (s) => s.id == _surahId,
    orElse: () => widget.surahs.first,
  );

  bool get _isAdd => widget.existing == null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _surahId =
        e?.surahId ??
        (widget.surahs.isNotEmpty ? widget.surahs.first.id : null);
    _fullSurah = e?.isFullSurah ?? true;
    _startCtl = TextEditingController(
      text: e != null && !e.isFullSurah && e.startAyah != null
          ? '${e.startAyah}'
          : '',
    );
    _endCtl = TextEditingController(
      text: e != null && !e.isFullSurah && e.endAyah != null
          ? '${e.endAyah}'
          : '',
    );
  }

  @override
  void dispose() {
    _startCtl.dispose();
    _endCtl.dispose();
    super.dispose();
  }

  void _seedBulkSelection(List<SurahPoolEntry> pool) {
    final inPool = pool.map((e) => e.surahId).toSet();
    _bulkCheckedSurahIds
      ..clear()
      ..addAll(
        surahsBelongingToJuz(
          widget.surahs,
          _selectedJuz,
        ).where((s) => !inPool.contains(s.id)).map((s) => s.id),
      );
  }

  Future<void> _loadBulkSelection() async {
    if (_saving || !_isAdd) return;
    final pool = await ref.read(poolEntriesAsyncProvider.future);
    if (!mounted || !_bulkMode) return;
    setState(() => _seedBulkSelection(pool));
  }

  Future<void> _onJuzChanged(int? juz) async {
    if (juz == null || _saving) return;
    final requested = juz;
    setState(() => _selectedJuz = requested);
    final pool = await ref.read(poolEntriesAsyncProvider.future);
    if (!mounted || _selectedJuz != requested) return;
    setState(() => _seedBulkSelection(pool));
  }

  void _bulkSelectAll(Set<int> poolSurahIds) {
    setState(() {
      _bulkCheckedSurahIds
        ..clear()
        ..addAll(
          surahsBelongingToJuz(
            widget.surahs,
            _selectedJuz,
          ).where((s) => !poolSurahIds.contains(s.id)).map((s) => s.id),
        );
    });
  }

  void _bulkDeselectAll() {
    setState(() => _bulkCheckedSurahIds.clear());
  }

  Future<void> _submit() async {
    final sid = _surahId;
    if (sid == null || !mounted) return;

    final formOk = _formKey.currentState?.validate() ?? false;
    if (!formOk) return;

    int? start;
    int? end;
    if (!_fullSurah) {
      start = int.tryParse(_startCtl.text.trim());
      end = int.tryParse(_endCtl.text.trim());
    }

    setState(() => _saving = true);
    try {
      final existing = widget.existing;
      if (existing == null) {
        await insertPoolSegment(
          ref: ref,
          surahId: sid,
          isFullSurah: _fullSurah,
          startAyah: _fullSurah ? null : start!,
          endAyah: _fullSurah ? null : end!,
        );
      } else {
        await replacePoolSegment(
          ref: ref,
          entry: SurahPoolEntry(
            id: existing.id,
            surahId: sid,
            isFullSurah: _fullSurah,
            startAyah: _fullSurah ? null : start!,
            endAyah: _fullSurah ? null : end!,
            enabled: existing.enabled,
          ),
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context)!.hifdhSaveErrorSnackbar('$e'))),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _submitBulk() async {
    if (_bulkCheckedSurahIds.isEmpty || !mounted) return;
    setState(() => _saving = true);
    try {
      await bulkInsertFullSurahPoolSegments(
        ref: ref,
        surahIds: List<int>.from(_bulkCheckedSurahIds),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context)!.hifdhSaveErrorSnackbar('$e'))),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final surahs = widget.surahs;
    final s = S.of(context)!;
    if (_surahId == null || surahs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(s.editorNoSurahsAvailable, style: AppTextStyles.body),
      );
    }

    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: bottomInset + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.existing == null ? s.editorAddTitle : s.editorEditTitle,
            style: AppTextStyles.sectionHeadingSerif,
          ),
          const SizedBox(height: 16),
          if (_isAdd) ...[
            SegmentedButton<bool>(
              segments: [
                ButtonSegment<bool>(
                  value: false,
                  label: Text(s.editorModeNormal),
                ),
                ButtonSegment<bool>(
                  value: true,
                  label: Text(s.editorModeBulkByJuz),
                ),
              ],
              emptySelectionAllowed: false,
              showSelectedIcon: false,
              selected: {_bulkMode},
              onSelectionChanged: _saving
                  ? null
                  : (next) {
                      final bulk = next.single;
                      setState(() => _bulkMode = bulk);
                      if (bulk) _loadBulkSelection();
                    },
            ),
            const SizedBox(height: 16),
          ],
          if (_isAdd && _bulkMode)
            _BulkByJuzPanel(
              saving: _saving,
              selectedJuz: _selectedJuz,
              surahs: surahs,
              lang: Localizations.localeOf(context).languageCode,
              checkedIds: _bulkCheckedSurahIds,
              onJuzChanged: _onJuzChanged,
              onToggleSurah: (id, checked) {
                setState(() {
                  if (checked) {
                    _bulkCheckedSurahIds.add(id);
                  } else {
                    _bulkCheckedSurahIds.remove(id);
                  }
                });
              },
              onSelectAll: _bulkSelectAll,
              onDeselectAll: _bulkDeselectAll,
              onSubmit: _submitBulk,
            )
          else
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: _NormalSegmentFields(
                  saving: _saving,
                  surahs: surahs,
                  surahId: _surahId!,
                  fullSurah: _fullSurah,
                  master: _surah,
                  existing: widget.existing,
                  startCtl: _startCtl,
                  endCtl: _endCtl,
                  formKey: _formKey,
                  onSurahChanged: (v) => setState(() => _surahId = v),
                  onFullSurahChanged: (v) => setState(() => _fullSurah = v),
                  onSubmit: _submit,
                ),
              ),
            ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppDropdownButtonFormField<int>(
          key: ValueKey(surahId),
          initialValue: surahId,
          decoration: mergeAppInputDecoration(
            context,
            InputDecoration(labelText: s.editorSurahLabel),
          ),
          validator: FormBuilderValidators.required<int?>(),
          items: [
            for (final surah in surahs)
              DropdownMenuItem(
                value: surah.id,
                child: Text(
                  '${surah.id}. ${surah.localizedName(Localizations.localeOf(context).languageCode)}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: saving ? null : onSurahChanged,
        ),
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

class _BulkByJuzPanel extends ConsumerWidget {
  const _BulkByJuzPanel({
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
          constraints: const BoxConstraints(maxHeight: 320),
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
