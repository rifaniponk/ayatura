// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Surah Planner';

  @override
  String get navHome => 'Home';

  @override
  String get navMonth => 'Month';

  @override
  String get navHifdh => 'Hifdh';

  @override
  String get navInsight => 'Insight';

  @override
  String get navSettings => 'Settings';

  @override
  String appBarSubtitleChaptersPool(int chapters, int pool) {
    return '$chapters surahs · $pool in hifdh list';
  }

  @override
  String appBarSubtitleChaptersLoading(int chapters) {
    return '$chapters surahs · …';
  }

  @override
  String errorGeneric(String message) {
    return 'Error: $message';
  }

  @override
  String get noSurahsLoaded => 'No surahs loaded';

  @override
  String get dayLabel => 'Day';

  @override
  String dayOfMonth(int day, int total) {
    return '$day / $total';
  }

  @override
  String get regeneratePlan => 'Regenerate Plan';

  @override
  String get snackbarNeedTwoSegments =>
      'Need at least two items turned on in your hifdh list.';

  @override
  String get monthScreenTitle => 'Month';

  @override
  String monthSubtitle(String month, int chapters) {
    return '$month · $chapters surahs';
  }

  @override
  String monthScreenSubtitlePool(String monthYear, int count) {
    return '$monthYear · $count in hifdh list';
  }

  @override
  String monthNavYearDays(String monthYear, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$monthYear · $_temp0';
  }

  @override
  String get monthNavPreviousMonth => 'Previous month';

  @override
  String get monthNavNextMonth => 'Next month';

  @override
  String get monthRegenerateCompact => 'Regenerate';

  @override
  String monthNoPlanTitle(String monthYear) {
    return 'No plan for $monthYear';
  }

  @override
  String get monthNoPlanSubtitle => 'Tap button below to create one.';

  @override
  String get monthNoPlanPastSubtitle =>
      'Plans can only be generated for the current or a future month.';

  @override
  String monthRegeneratePlanFor(String monthYear) {
    return 'Generate Plan for $monthYear';
  }

  @override
  String get monthTodayChip => 'Today';

  @override
  String get monthFullSurah => 'Full surah';

  @override
  String monthAyatRange(int start, int end) {
    return '$start – $end';
  }

  @override
  String get monthPrayerEmpty => '—';

  @override
  String get prayerNameFajr => 'FAJR';

  @override
  String get prayerNameDhuhr => 'DHUHR';

  @override
  String get prayerNameAsr => 'ASR';

  @override
  String get prayerNameMaghrib => 'MAGHRIB';

  @override
  String get prayerNameIsha => 'ISHA';

  @override
  String monthDayTitle(int day) {
    return 'Day $day';
  }

  @override
  String monthDayReadings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count planned readings across prayers',
      one: '1 planned reading across prayers',
    );
    return '$_temp0';
  }

  @override
  String get hifdhScreenTitle => 'Hifdh';

  @override
  String get hifdhSubtitleEmpty => 'Nothing listed yet';

  @override
  String hifdhSubtitleCount(int enabled, int total) {
    return '$enabled active of $total total in hifdh list';
  }

  @override
  String get hifdhIntroBanner =>
      'Hifdh is Quran memorization. What you list here is used when you build your monthly plan.';

  @override
  String get hifdhFabAdd => 'Add';

  @override
  String get hifdhMenuEdit => 'Edit';

  @override
  String get hifdhMenuRemove => 'Remove';

  @override
  String get hifdhRemoveDialogTitle => 'Remove from hifdh list?';

  @override
  String hifdhRemoveDialogContent(String label) {
    return '$label will be removed from your hifdh list. Your current month plan will be cleared until you generate a new one.';
  }

  @override
  String hifdhRemoveErrorSnackbar(String error) {
    return 'Could not remove: $error';
  }

  @override
  String hifdhSaveErrorSnackbar(String error) {
    return 'Could not save: $error';
  }

  @override
  String hifdhToggleErrorSnackbar(String error) {
    return 'Failed to save: $error';
  }

  @override
  String hifdhDuplicateError(String label) {
    return '$label is already in your hifdh list';
  }

  @override
  String hifdhBulkSkippedOne(String label) {
    return '1 entry was skipped — $label is already in your hifdh list.';
  }

  @override
  String hifdhBulkSkippedMany(int count) {
    return '$count entries were skipped — already in your hifdh list.';
  }

  @override
  String get editorAddTitle => 'Add surah or ayat';

  @override
  String get editorEditTitle => 'Edit entry';

  @override
  String get editorSurahLabel => 'Surah';

  @override
  String get editorEntireSurah => 'Entire surah';

  @override
  String get editorEntireSurahOn => 'The entire surah is on your hifdh list.';

  @override
  String get editorEntireSurahOff => 'Only the ayat range below is included.';

  @override
  String editorAyatCount(int count) {
    return '$count ayat in this surah';
  }

  @override
  String get editorStartAyah => 'Start ayah';

  @override
  String get editorEndAyah => 'End ayah';

  @override
  String get editorAddButton => 'Add to hifdh list';

  @override
  String get editorSaveButton => 'Save';

  @override
  String get editorNoSurahsAvailable => 'No surahs available.';

  @override
  String get editorPickerSearchHint => 'Search by surah name';

  @override
  String get editorPickerNoResults => 'No results';

  @override
  String get editorModeNormal => 'Normal';

  @override
  String get editorModeBulkByJuz => 'Bulk by Juz';

  @override
  String get editorJuzLabel => 'Juz';

  @override
  String editorJuzOption(int juz) {
    return 'Juz $juz';
  }

  @override
  String editorBulkAddButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count to hifdh list',
      one: 'Add 1 to hifdh list',
    );
    return '$_temp0';
  }

  @override
  String get editorAlreadyAdded => 'Already added';

  @override
  String get editorSelectAll => 'Select all';

  @override
  String get editorDeselectAll => 'Deselect all';

  @override
  String get emptyNoPlanTitle => 'No plan yet';

  @override
  String get emptyNoPlanSubtitle =>
      'Generate a plan to assign readings across the month.';

  @override
  String get emptyNoPlanAction => 'Generate Plan';

  @override
  String get emptyPoolTooSmallTitle => 'Need more for a plan';

  @override
  String get emptyPoolTooSmallSubtitle =>
      'Include at least two surahs or ayat ranges in your hifdh list (with the switch on), then generate a plan.';

  @override
  String get emptyPoolTooSmallAction => 'Open Hifdh';

  @override
  String get emptyHifdhListTitle => 'Start your hifdh list';

  @override
  String get emptyHifdhListSubtitle =>
      'Add full surahs or ayat ranges you are memorizing. Your monthly plan will draw from this list.';

  @override
  String get emptyHifdhListAction => 'Add surah or ayat';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get prayerNoReadings => 'No readings assigned';

  @override
  String get lockSlotTooltip => 'Lock slot';

  @override
  String get unlockSlotTooltip => 'Unlock slot';

  @override
  String get slotLockedSnackbar => 'Slot locked';

  @override
  String get slotUnlockedSnackbar => 'Slot unlocked';

  @override
  String get monthClearAllLocks => 'Clear all locks';

  @override
  String get monthNoLocksToClear => 'No locks to clear for this month.';

  @override
  String monthClearedLocksSnackbar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cleared $count locks',
      one: 'Cleared 1 lock',
    );
    return '$_temp0';
  }

  @override
  String prayerAyatCount(int count) {
    return '$count ayat';
  }

  @override
  String get homeNowPrayingBadge => 'NOW PRAYING';

  @override
  String get homeUpNextBadge => 'UP NEXT';

  @override
  String homePrayerStartedAt(String time) {
    return 'started $time';
  }

  @override
  String homePrayerUntilNext(String duration) {
    return 'IN $duration UNTIL NEXT';
  }

  @override
  String get readerNoVerses => 'No verses found.';

  @override
  String get readerLoadErrorRetry => 'Could not load verses. Tap to retry.';

  @override
  String get readerSourceAttribution =>
      'Quran text and translation source: quran.com (Quran Foundation).';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get settingsSurahsPerPrayer => 'Surahs per prayer';

  @override
  String get settingsSurahsPerPrayerSubtitle =>
      'Number of surahs per prayer slot. Regenerate to apply.';

  @override
  String get settingsLockPastPrayers => 'Lock past prayers';

  @override
  String get settingsLockPastPrayersSubtitle =>
      'Preserve prayer slots from days before today when regenerating.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Choose your preferred language';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutBody =>
      'Surah Planner helps you keep up with your hifdh by spreading your surahs and ayat across daily prayers throughout the month. Add what you\'re memorizing, generate a plan, and review a little each day.';

  @override
  String get insightTitle => 'Insight';

  @override
  String get insightSubtitle =>
      'Hifdh frequency counter across all saved monthly plans.';

  @override
  String get insightEmpty => 'No active hifdh entries yet.';

  @override
  String insightAssignmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Assigned $count times',
      one: 'Assigned 1 time',
    );
    return '$_temp0';
  }

  @override
  String get langEnglish => 'English';

  @override
  String get langIndonesian => 'Indonesian';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogRemove => 'Remove';

  @override
  String get backTooltip => 'Back';

  @override
  String get dismissTooltip => 'Dismiss';

  @override
  String get widgetDescription => 'Surah Planner prayer widget';

  @override
  String get widgetEmptyNoPlanTitle => 'No plan generated yet';

  @override
  String get widgetEmptyNoPlanSubtitle => 'Open the app to get started';

  @override
  String get widgetEmptyPlanExpiredTitle => 'Plan expired';

  @override
  String get widgetEmptyPlanExpiredSubtitle => 'Open the app to regenerate';

  @override
  String get widgetEmptyStaleTitle => 'Widget data outdated';

  @override
  String get widgetEmptyStaleSubtitle => 'Open the app to refresh the widget';

  @override
  String get widgetTomorrowMarker => 'TOMORROW';

  @override
  String get widgetBeforeFajr => 'BEFORE FAJR';
}
