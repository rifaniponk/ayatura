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
  String get navMore => 'More';

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
  String get prayerNoReadings => 'No readings assigned';

  @override
  String prayerAyatCount(int count) {
    return '$count ayat';
  }

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
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Choose your preferred language';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutBody =>
      'Surah Planner spreads what you list for hifdh—full surahs or ayat ranges—across prayers through the month. Saving plans to your device is coming next.';

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
}
