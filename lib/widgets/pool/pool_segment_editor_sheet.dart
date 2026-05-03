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
import '../common/gradient_button.dart';

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

  Surah get _surah => widget.surahs.firstWhere(
    (s) => s.id == _surahId,
    orElse: () => widget.surahs.first,
  );

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
    final master = _surah;

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: bottomInset + 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.existing == null ? s.editorAddTitle : s.editorEditTitle,
                style: AppTextStyles.sectionHeadingSerif,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                key: ValueKey(_surahId),
                initialValue: _surahId,
                decoration: InputDecoration(
                  labelText: s.editorSurahLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required<int?>(),
                items: [
                  for (final s in surahs)
                    DropdownMenuItem(
                      value: s.id,
                      child: Text(
                        '${s.id}. ${s.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: _saving
                    ? null
                    : (v) => setState(() {
                        _surahId = v;
                      }),
              ),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                title: Text(s.editorEntireSurah),
                subtitle: Text(
                  _fullSurah ? s.editorEntireSurahOn : s.editorEntireSurahOff,
                  style: AppTextStyles.meta,
                ),
                value: _fullSurah,
                onChanged: _saving
                    ? null
                    : (v) => setState(() => _fullSurah = v),
              ),
              if (!_fullSurah) ...[
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
                      child: TextFormField(
                        controller: _startCtl,
                        decoration: InputDecoration(
                          labelText: s.editorStartAyah,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: PoolSegmentFormValidators.startAyah(master),
                        onChanged: (_) => _formKey.currentState?.validate(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _endCtl,
                        decoration: InputDecoration(
                          labelText: s.editorEndAyah,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: PoolSegmentFormValidators.endAyah(
                          master,
                          () => _startCtl.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              GradientButton(
                label: widget.existing == null
                    ? s.editorAddButton
                    : s.editorSaveButton,
                enabled: !_saving,
                onPressed: _saving ? null : _submit,
              ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ],
          ),
        ),
      ),
    );
  }
}
