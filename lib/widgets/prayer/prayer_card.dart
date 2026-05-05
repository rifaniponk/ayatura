import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/plan.dart';
import '../../data/models/prayer.dart';
import '../../data/models/surah.dart';

enum PrayerCardHighlight { normal, past, upcoming, current }

/// A single prayer slot card (e.g. home timeline).
///
/// [masterBySurahId] maps Quran surah number → canonical [Surah] for labels.
class PrayerCard extends StatelessWidget {
  const PrayerCard({
    super.key,
    required this.prayer,
    required this.slot,
    required this.masterBySurahId,
    this.prayerTime,
    this.highlight = PrayerCardHighlight.normal,
    this.badgeLabel,
    this.trailingMeta,
    this.subtitle,
    this.progress,
    this.progressLeftLabel,
    this.progressRightLabel,
    this.onTap,
    this.onToggleLock,
  });

  final Prayer prayer;
  final PrayerSlot slot;
  final Map<int, Surah> masterBySurahId;
  final String? prayerTime;
  final PrayerCardHighlight highlight;
  final String? badgeLabel;
  final String? trailingMeta;
  final String? subtitle;
  final double? progress;
  final String? progressLeftLabel;
  final String? progressRightLabel;
  final VoidCallback? onTap;
  final VoidCallback? onToggleLock;

  String _localizedName(S s) => switch (prayer) {
    Prayer.fajr => s.prayerFajr,
    Prayer.dhuhr => s.prayerDhuhr,
    Prayer.asr => s.prayerAsr,
    Prayer.maghrib => s.prayerMaghrib,
    Prayer.isha => s.prayerIsha,
  };

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final isCurrent = highlight == PrayerCardHighlight.current;
    final isUpcoming = highlight == PrayerCardHighlight.upcoming;
    final isPast = highlight == PrayerCardHighlight.past;
    final cardOpacity = isPast ? 0.72 : 1.0;
    final hasBadge = badgeLabel != null && badgeLabel!.isNotEmpty;

    final cardDecoration = switch (highlight) {
      PrayerCardHighlight.current => BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.green, AppColors.green2],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.green2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x331F7A6B),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      PrayerCardHighlight.upcoming => BoxDecoration(
        color: const Color(0xFFFFFEFB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.goldOverlay30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0FC5A630),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      _ => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: slot.locked
              ? AppColors.goldOverlay30
              : const Color(0x0F0F3D2E),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withAlpha(18),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    };

    final titleColor = isCurrent ? AppColors.gold : AppColors.green;
    final primaryTextColor = isCurrent ? AppColors.white : AppColors.ink;
    final metaColor = isCurrent
        ? AppColors.white14.withAlpha(220)
        : AppColors.ink3;

    if (isCurrent) {
      return GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: cardOpacity,
          child: Container(
            decoration: cardDecoration,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Stack(
              children: [
                Positioned(
                  right: -58,
                  top: -52,
                  child: Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0x20D4AF37),
                    ),
                  ),
                ),
                Positioned(
                  right: -20,
                  top: -38,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0x261F7A6B),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (hasBadge)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(
                                color: AppColors.goldOverlay30,
                              ),
                              color: const Color(0x262C6B52),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const _NowPrayingDot(),
                                const SizedBox(width: 8),
                                Text(
                                  badgeLabel!,
                                  style: AppTextStyles.prayerCardBadge.copyWith(
                                    color: AppColors.gold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            slot.locked
                                ? Icons.lock_rounded
                                : Icons.lock_open_rounded,
                            size: 18,
                            color: slot.locked
                                ? AppColors.gold
                                : AppColors.white,
                          ),
                          tooltip: slot.locked
                              ? s.unlockSlotTooltip
                              : s.lockSlotTooltip,
                          onPressed: onToggleLock,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _localizedName(s),
                          style: AppTextStyles.prayerCurrentTitle.copyWith(
                            color: AppColors.gold,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              subtitle!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: const Color(0xCCE7EEEA),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        minHeight: 6,
                        value: progress?.clamp(0.0, 1.0) ?? 0.0,
                        backgroundColor: const Color(0x3AFFFFFF),
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: const SizedBox.shrink()),
                        if (progressRightLabel != null)
                          Text(
                            progressRightLabel!,
                            style: AppTextStyles.prayerCardProgressMeta
                                .copyWith(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0x3382A78E)),
                        color: const Color(0x16000504),
                      ),
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._buildSurahRows(
                            s: s,
                            lang: lang,
                            textColor: AppColors.white,
                            metaColor: const Color(0xB7FFFFFF),
                            indexGradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF7C9252), Color(0xFF3A6F5D)],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: cardOpacity,
        child: Container(
          decoration: cardDecoration,
          padding: EdgeInsets.fromLTRB(14, isCurrent ? 10 : 2, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (hasBadge)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.goldOverlay30
                            : AppColors.goldOverlay12,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        badgeLabel!,
                        style: AppTextStyles.prayerCardBadge.copyWith(
                          color: isCurrent ? AppColors.gold : AppColors.green,
                          letterSpacing: 0.8,
                        ),
                      ),
                    )
                  else
                    Text(
                      _localizedName(s).toUpperCase(),
                      style: AppTextStyles.prayerLabel.copyWith(
                        color: titleColor,
                      ),
                    ),
                  if (hasBadge) const SizedBox(width: 10),
                  if (hasBadge)
                    Text(
                      _localizedName(s),
                      style: AppTextStyles.prayerHighlightedTitle.copyWith(
                        color: isCurrent ? AppColors.gold : AppColors.green,
                      ),
                    ),
                  const Spacer(),
                  if (prayerTime != null)
                    Text(
                      prayerTime!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isCurrent ? AppColors.white : AppColors.ink2,
                      ),
                    ),
                  if (trailingMeta != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      trailingMeta!,
                      style: AppTextStyles.smallLabel.copyWith(
                        color: isCurrent ? AppColors.gold : AppColors.ink2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  if (!hasBadge && isPast) ...[
                    const SizedBox(width: 6),
                    Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: isCurrent ? AppColors.gold : AppColors.green2,
                    ),
                  ],
                  IconButton(
                    icon: Icon(
                      slot.locked
                          ? Icons.lock_rounded
                          : Icons.lock_open_rounded,
                      size: 18,
                      color: slot.locked
                          ? AppColors.gold
                          : (isCurrent ? AppColors.white : AppColors.ink3),
                    ),
                    tooltip: slot.locked
                        ? s.unlockSlotTooltip
                        : s.lockSlotTooltip,
                    onPressed: onToggleLock,
                  ),
                ],
              ),
              if (!hasBadge && (isCurrent || isUpcoming))
                Text(
                  _localizedName(s).toUpperCase(),
                  style: AppTextStyles.prayerLabel.copyWith(color: titleColor),
                ),
              ..._buildSurahRows(
                s: s,
                lang: lang,
                textColor: primaryTextColor,
                metaColor: metaColor,
                indexGradient: AppColors.buttonGradient,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSurahRows({
    required S s,
    required String lang,
    required Color textColor,
    required Color metaColor,
    required Gradient indexGradient,
  }) {
    if (slot.surahs.isEmpty) {
      return [
        Text(
          s.prayerNoReadings,
          style: AppTextStyles.meta.copyWith(
            color: metaColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ];
    }
    return slot.surahs
        .asMap()
        .entries
        .map((entry) {
          final idx = entry.key;
          final ps = entry.value;
          final master = masterBySurahId[ps.surahId];
          final label = master != null
              ? ps.displayLabel(master, lang)
              : 'Surah ${ps.surahId}';
          final verses = master != null ? ps.verseSpan(master) : 0;
          return Padding(
            padding: EdgeInsets.only(top: idx == 0 ? 0 : 10),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    gradient: indexGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${idx + 1}',
                      style: AppTextStyles.meta.copyWith(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.surahNamePrayerCard.copyWith(
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  s.prayerAyatCount(verses),
                  style: AppTextStyles.prayerCardVerseCount.copyWith(
                    color: metaColor,
                  ),
                ),
              ],
            ),
          );
        })
        .toList(growable: false);
  }
}

class _NowPrayingDot extends StatefulWidget {
  const _NowPrayingDot();

  @override
  State<_NowPrayingDot> createState() => _NowPrayingDotState();
}

class _NowPrayingDotState extends State<_NowPrayingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 0.92,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _glow = Tween<double>(
      begin: 0.55,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Transform.scale(
          scale: _scale.value,
          child: Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x99D4AF37).withValues(alpha: _glow.value),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Color(
                    0x55D4AF37,
                  ).withValues(alpha: 0.55 * _glow.value),
                  blurRadius: 6,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
