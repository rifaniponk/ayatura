part of 'pool_segment_editor_sheet.dart';

class _SurahPickerSheet extends StatefulWidget {
  const _SurahPickerSheet({
    required this.surahs,
    required this.selectedSurahId,
  });

  final List<Surah> surahs;
  final int selectedSurahId;

  @override
  State<_SurahPickerSheet> createState() => _SurahPickerSheetState();
}

class _SurahPickerSheetState extends State<_SurahPickerSheet> {
  final TextEditingController _searchCtl = TextEditingController();

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final maxScrollableContentHeight = MediaQuery.sizeOf(context).height * 0.8;
    final query = _searchCtl.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? widget.surahs
        : widget.surahs.where((surah) {
            return surah.name.toLowerCase().contains(query) ||
                surah.nameId.toLowerCase().contains(query);
          }).toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 14,
          right: 14,
          top: 8,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextFormField(
              controller: _searchCtl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: s.editorSurahLabel,
                hintText: s.editorPickerSearchHint,
                isDense: true,
                suffixIcon: _searchCtl.text.isEmpty
                    ? const Icon(Icons.search_rounded)
                    : IconButton(
                        tooltip: s.dismissTooltip,
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchCtl.clear();
                          setState(() {});
                        },
                      ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                '${filtered.length} / ${widget.surahs.length}',
                style: AppTextStyles.meta.copyWith(color: AppColors.ink3),
                textAlign: TextAlign.end,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxScrollableContentHeight,
                ),
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          s.editorPickerNoResults,
                          style: AppTextStyles.body,
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.only(bottom: 6),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 210,
                              mainAxisExtent: 60,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final surah = filtered[index];
                          final selected = surah.id == widget.selectedSurahId;
                          return Material(
                            color: selected
                                ? AppColors.green2
                                : AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: selected
                                    ? AppColors.green2
                                    : AppColors.border,
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => Navigator.of(context).pop(surah.id),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '#${surah.id}',
                                          style: AppTextStyles.meta.copyWith(
                                            color: selected
                                                ? AppColors.white
                                                : AppColors.ink3,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              surah.arabicName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.end,
                                              textDirection: TextDirection.rtl,
                                              style: AppTextStyles.meta
                                                  .copyWith(
                                                    color: selected
                                                        ? AppColors.white
                                                        : AppColors.ink2,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            surah.localizedName(languageCode),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyles.body.copyWith(
                                              color: selected
                                                  ? AppColors.white
                                                  : AppColors.ink,
                                              fontWeight: selected
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        if (selected) ...[
                                          const SizedBox(width: 6),
                                          Icon(
                                            Icons.check_circle_rounded,
                                            size: 16,
                                            color: AppColors.white,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
