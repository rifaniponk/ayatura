// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ayatura';

  @override
  String get brandLogoLabel => 'Ayatura logo';

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
    return '$chapters surahs · $pool in Hifdh list';
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
  String get noSurahsLoaded => 'Surahs are not available';

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
      'You need at least two active surahs in your Hifdh list.';

  @override
  String get monthScreenTitle => 'Month';

  @override
  String monthSubtitle(String month, int chapters) {
    return '$month · $chapters surahs';
  }

  @override
  String monthScreenSubtitlePool(String monthYear, int count) {
    return '$monthYear · $count in Hifdh list';
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
    return 'No plan yet for $monthYear';
  }

  @override
  String get monthNoPlanSubtitle =>
      'Start planning your Quran reading for this month. Ayatura helps you spread your Hifdh evenly across the five daily prayers, so everything you have memorized stays fresh and is read regularly.';

  @override
  String get monthNoPlanPastSubtitle =>
      'Plans can only be created for this month or a future month.';

  @override
  String monthRegeneratePlanFor(String monthYear) {
    return 'Create plan for $monthYear';
  }

  @override
  String get homeNoPlanTitle => 'No plan yet';

  @override
  String get homeNoPlanHeroSubtitle =>
      'You do not have a daily surah plan yet. Tap the button below to create one automatically for this month.';

  @override
  String get homeNoPlanCreateThisMonth => 'Create your first plan';

  @override
  String get homeNoPlanLearnHow => 'Learn how it works';

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
  String get hifdhSubtitleEmpty => 'Nothing added yet';

  @override
  String hifdhSubtitleCount(int enabled, int total) {
    return '$enabled active of $total total in Hifdh list';
  }

  @override
  String get hifdhIntroBanner =>
      'Surahs you add here will be used to create your monthly plan.';

  @override
  String get hifdhFabAdd => 'Add';

  @override
  String get hifdhMenuEdit => 'Edit';

  @override
  String get hifdhMenuRead => 'Read';

  @override
  String get hifdhMenuRemove => 'Remove';

  @override
  String get hifdhRemoveDialogTitle => 'Remove from Hifdh list?';

  @override
  String hifdhRemoveDialogContent(String label) {
    return '$label will be removed from your Hifdh list, but this will not affect your existing monthly plan.';
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
    return 'Could not save: $error';
  }

  @override
  String hifdhDuplicateError(String label) {
    return '$label is already in your Hifdh list';
  }

  @override
  String hifdhBulkSkippedOne(String label) {
    return '1 item was skipped because $label is already in your Hifdh list.';
  }

  @override
  String hifdhBulkSkippedMany(int count) {
    return '$count items were skipped because they are already in your Hifdh list.';
  }

  @override
  String get editorAddTitle => 'Add surah to Hifdh';

  @override
  String get editorEditTitle => 'Edit Hifdh';

  @override
  String get editorSurahLabel => 'Surah';

  @override
  String get editorEntireSurah => 'Entire surah';

  @override
  String get editorEntireSurahOn => 'Include every ayah in this surah.';

  @override
  String get editorEntireSurahOff =>
      'Only the ayah range below will be included.';

  @override
  String editorAyatCount(int count) {
    return '$count ayat in this surah';
  }

  @override
  String get editorStartAyah => 'Start ayah';

  @override
  String get editorEndAyah => 'End ayah';

  @override
  String get editorAddButton => 'Add to Hifdh list';

  @override
  String get editorSaveButton => 'Save';

  @override
  String get editorNoSurahsAvailable => 'No surahs available.';

  @override
  String get editorPickerSearchHint => 'Search by surah name';

  @override
  String get editorPickerNoResults => 'No results';

  @override
  String get editorModeNormal => '1 surah';

  @override
  String get editorModeBulkByJuz => 'Bulk add by Juz';

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
      other: 'Add $count to Hifdh list',
      one: 'Add 1 to Hifdh list',
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
  String get emptyPoolTooSmallTitle => 'No active Hifdh yet';

  @override
  String get emptyPoolTooSmallSubtitle =>
      'Add some surahs to start building a prayer plan. After that, you can easily create a plan for the month ahead.';

  @override
  String get emptyPoolTooSmallAction => 'Open Hifdh';

  @override
  String get emptyHifdhListTitle => 'No Hifdh yet';

  @override
  String get emptyHifdhListSubtitle =>
      'Add a full surah or an ayah range that you want to read during prayer. Your monthly plan will be created from this list.';

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
  String get monthClearAllLocks => 'Unlock all';

  @override
  String get monthNoLocksToClear => 'No locks to clear for this month.';

  @override
  String monthClearedLocksSnackbar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count locks unlocked',
      one: '1 lock unlocked',
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
    return '$duration UNTIL NEXT';
  }

  @override
  String get readerNoVerses => 'No verses found.';

  @override
  String get readerLoadErrorRetry => 'Could not load verses. Tap to retry.';

  @override
  String get readerSourceAttribution =>
      'Source of Quran text and translation: quran.com';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get settingsSurahsPerPrayer => 'Surahs per prayer';

  @override
  String get settingsSurahsPerPrayerSubtitle =>
      'Number of surahs per prayer slot. Regenerate the plan to apply changes.';

  @override
  String get settingsLockPastPrayers => 'Lock past prayer slots';

  @override
  String get settingsLockPastPrayersSubtitle =>
      'Plans for previous days will not change when you regenerate the plan.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Choose your preferred language';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutTileTitle => 'About Ayatura';

  @override
  String get settingsAboutTileSubtitle => 'Version and privacy';

  @override
  String get settingsFeedbackTileTitle => 'Send feedback';

  @override
  String get settingsFeedbackTileSubtitle =>
      'Share thoughts or report issues in a short form';

  @override
  String get settingsFeedbackLaunchFailed =>
      'Could not open the feedback form. Check your connection and try again.';

  @override
  String get aboutTitle => 'About';

  @override
  String aboutVersionBuild(String version, String buildNumber) {
    return 'Version $version ($buildNumber)';
  }

  @override
  String get aboutBodyParagraph1 =>
      '<b>Ayatura</b> helps you spread your <b>memorized surahs</b> across the <b>five daily prayers</b> in a steady, balanced way. Enter your Hifdh list, and <b>Ayatura</b> will build a <b>daily reading plan</b> so everything you have memorized is recited regularly instead of cycling through the same few surahs.';

  @override
  String get aboutBodyParagraph2 =>
      'Many people with <b>many memorized surahs</b> often struggle to choose which surah to read during <b>prayer</b>. As a result, some surahs are rarely read and may slowly be forgotten. <b>Ayatura</b> helps keep your <b>Hifdh alive</b> through a <b>more balanced daily reading pattern</b>.';

  @override
  String get aboutPrivacyPolicy => 'Privacy Policy';

  @override
  String get aboutPrivacyBody =>
      'Ayatura stores all data and settings on this device. This app does not require an account, and your data is not sent to a server.';

  @override
  String get aboutCopyright => 'Copyright 2026 Ayatura. All rights reserved.';

  @override
  String get insightTitle => 'Insight';

  @override
  String get insightSubtitle =>
      'Hifdh frequency counter across all saved monthly plans.';

  @override
  String get insightEmpty => 'No active Hifdh yet.';

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
  String get dialogClose => 'Close';

  @override
  String get dialogRemove => 'Remove';

  @override
  String get backTooltip => 'Back';

  @override
  String get dismissTooltip => 'Close';

  @override
  String get widgetDescription => 'Ayatura prayer plan widget';

  @override
  String get widgetEmptyNoPlanTitle => 'No plan yet';

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
}
