part of '../../screens/pool_screen.dart';

class _PoolBody extends ConsumerStatefulWidget {
  const _PoolBody({
    required this.pool,
    required this.surahs,
    required this.onAddSegment,
    required this.onEditSegment,
  });

  final List<SurahPoolEntry> pool;
  final List<Surah> surahs;
  final VoidCallback onAddSegment;
  final void Function(SurahPoolEntry entry) onEditSegment;

  @override
  ConsumerState<_PoolBody> createState() => _PoolBodyState();
}

class _PoolBodyState extends ConsumerState<_PoolBody> {
  final Set<int> _busyIds = {};
  late Map<int, Surah> _masterById;

  @override
  void initState() {
    super.initState();
    _masterById = {for (final s in widget.surahs) s.id: s};
  }

  @override
  void didUpdateWidget(_PoolBody old) {
    super.didUpdateWidget(old);
    if (old.surahs != widget.surahs) {
      _masterById = {for (final s in widget.surahs) s.id: s};
    }
  }

  Future<void> _toggle(SurahPoolEntry entry, bool enabled) async {
    setState(() => _busyIds.add(entry.id));
    try {
      await setPoolEntryEnabled(ref, entry, enabled);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context)!.hifdhToggleErrorSnackbar('$e')),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busyIds.remove(entry.id));
    }
  }

  Future<void> _confirmRemove(SurahPoolEntry entry) async {
    final master = _masterById[entry.surahId];
    final lang = Localizations.localeOf(context).languageCode;
    final label = master != null
        ? entry.displayLabel(master, lang)
        : 'Surah ${entry.surahId}';

    final ok = await showAppAlertDialog<bool>(
      context,
      title: Text(S.of(context)!.hifdhRemoveDialogTitle),
      content: Text(S.of(context)!.hifdhRemoveDialogContent(label)),
      actions: (dialogContext) {
        final loc = S.of(dialogContext)!;
        final scheme = Theme.of(dialogContext).colorScheme;
        return [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(loc.dialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: scheme.error),
            child: Text(loc.dialogRemove),
          ),
        ];
      },
    );
    if (ok != true || !mounted) return;

    setState(() => _busyIds.add(entry.id));
    try {
      await deletePoolSegment(ref, entry.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context)!.hifdhRemoveErrorSnackbar('$e')),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busyIds.remove(entry.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pool = [...widget.pool]
      ..sort((a, b) {
        final bySurahId = a.surahId.compareTo(b.surahId);
        if (bySurahId != 0) return bySurahId;
        return a.id.compareTo(b.id);
      });
    final surahs = widget.surahs;

    if (surahs.isEmpty) {
      return Center(child: Text(S.of(context)!.noSurahsLoaded));
    }
    if (pool.isEmpty) {
      final loc = S.of(context)!;
      return HifdhEmptyHeroLayout(
        semanticLabel: loc.emptyHifdhListTitle,
        title: loc.emptyHifdhListTitle,
        subtitle: loc.emptyHifdhListSubtitle,
        primaryLabel: loc.emptyHifdhListAction,
        onPrimary: widget.onAddSegment,
      );
    }

    final scheme = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        18,
        12,
        18,
        kFloatingActionButtonMargin * 2 + 56,
      ),
      itemCount: pool.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final entry = pool[i];
        final master = _masterById[entry.surahId];
        final lang = Localizations.localeOf(context).languageCode;
        final latinName =
            master?.localizedName(lang) ?? 'Surah ${entry.surahId}';
        final ayahRange = _compactAyahRange(entry);
        final busy = _busyIds.contains(entry.id);
        final paused = !entry.enabled;

        final nameAlpha = paused ? 0.52 : 1.0;
        final parenAlpha = paused ? 0.38 : 0.42;
        final arabicAlpha = paused ? 0.55 : 0.88;
        final ayahAlpha = paused ? 0.38 : 0.52;

        return Card(
          clipBehavior: Clip.antiAlias,
          color: paused
              ? Color.lerp(AppColors.white, AppColors.ink3, 0.11)!
              : AppColors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppToggle(
                  value: entry.enabled,
                  onChanged: busy ? null : (v) => _toggle(entry, v),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '#${entry.surahId}',
                                  style: AppTextStyles.cardLabel.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.ink3,
                                  ),
                                ),
                                const TextSpan(text: '  '),
                                TextSpan(
                                  text: latinName,
                                  style: AppTextStyles.cardLabel.copyWith(
                                    color: scheme.onSurface.withValues(
                                      alpha: nameAlpha,
                                    ),
                                  ),
                                ),
                                if (master != null) ...[
                                  TextSpan(
                                    text: ' (',
                                    style: AppTextStyles.cardLabel.copyWith(
                                      color: scheme.onSurface.withValues(
                                        alpha: parenAlpha,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: master.arabicName,
                                    style: AppTextStyles.arabicSecondary
                                        .copyWith(
                                          fontSize: 15,
                                          height: 1.25,
                                          color: scheme.onSurface.withValues(
                                            alpha: arabicAlpha,
                                          ),
                                        ),
                                  ),
                                  TextSpan(
                                    text: ')',
                                    style: AppTextStyles.cardLabel.copyWith(
                                      color: scheme.onSurface.withValues(
                                        alpha: parenAlpha,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (ayahRange != null) ...[
                          const SizedBox(width: 14),
                          Text(
                            ayahRange,
                            style: AppTextStyles.smallLabel.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                              color: scheme.onSurface.withValues(
                                alpha: ayahAlpha,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                AppPopupMenuButton<String>(
                  enabled: !busy,
                  onSelected: (value) {
                    if (value == 'edit') widget.onEditSegment(entry);
                    if (value == 'delete') _confirmRemove(entry);
                  },
                  itemBuilder: (ctx) {
                    final loc = S.of(ctx)!;
                    return [
                      AppPopupMenuItem(
                        value: 'edit',
                        child: Text(loc.hifdhMenuEdit),
                      ),
                      AppPopupMenuItem(
                        value: 'delete',
                        destructive: true,
                        child: Text(loc.hifdhMenuRemove),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
