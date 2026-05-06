import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Surah Planner'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get navMonth;

  /// No description provided for @navHifdh.
  ///
  /// In en, this message translates to:
  /// **'Hifdh'**
  String get navHifdh;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @appBarSubtitleChaptersPool.
  ///
  /// In en, this message translates to:
  /// **'{chapters} surahs · {pool} in hifdh list'**
  String appBarSubtitleChaptersPool(int chapters, int pool);

  /// No description provided for @appBarSubtitleChaptersLoading.
  ///
  /// In en, this message translates to:
  /// **'{chapters} surahs · …'**
  String appBarSubtitleChaptersLoading(int chapters);

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorGeneric(String message);

  /// No description provided for @noSurahsLoaded.
  ///
  /// In en, this message translates to:
  /// **'No surahs loaded'**
  String get noSurahsLoaded;

  /// No description provided for @dayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayLabel;

  /// No description provided for @dayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'{day} / {total}'**
  String dayOfMonth(int day, int total);

  /// No description provided for @regeneratePlan.
  ///
  /// In en, this message translates to:
  /// **'Regenerate Plan'**
  String get regeneratePlan;

  /// No description provided for @snackbarNeedTwoSegments.
  ///
  /// In en, this message translates to:
  /// **'Need at least two items turned on in your hifdh list.'**
  String get snackbarNeedTwoSegments;

  /// No description provided for @monthScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthScreenTitle;

  /// No description provided for @monthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{month} · {chapters} surahs'**
  String monthSubtitle(String month, int chapters);

  /// No description provided for @monthScreenSubtitlePool.
  ///
  /// In en, this message translates to:
  /// **'{monthYear} · {count} in hifdh list'**
  String monthScreenSubtitlePool(String monthYear, int count);

  /// No description provided for @monthNavYearDays.
  ///
  /// In en, this message translates to:
  /// **'{monthYear} · {days, plural, one{1 day} other{{days} days}}'**
  String monthNavYearDays(String monthYear, int days);

  /// No description provided for @monthNavPreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get monthNavPreviousMonth;

  /// No description provided for @monthNavNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get monthNavNextMonth;

  /// No description provided for @monthRegenerateCompact.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get monthRegenerateCompact;

  /// No description provided for @monthNoPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'No plan for {monthYear}'**
  String monthNoPlanTitle(String monthYear);

  /// No description provided for @monthNoPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap Regenerate to create one.'**
  String get monthNoPlanSubtitle;

  /// No description provided for @monthRegeneratePlanFor.
  ///
  /// In en, this message translates to:
  /// **'Regenerate Plan for {monthYear}'**
  String monthRegeneratePlanFor(String monthYear);

  /// No description provided for @monthTodayChip.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get monthTodayChip;

  /// No description provided for @monthFullSurah.
  ///
  /// In en, this message translates to:
  /// **'Full surah'**
  String get monthFullSurah;

  /// No description provided for @monthAyatRange.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String monthAyatRange(int start, int end);

  /// No description provided for @monthPrayerEmpty.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get monthPrayerEmpty;

  /// No description provided for @prayerNameFajr.
  ///
  /// In en, this message translates to:
  /// **'FAJR'**
  String get prayerNameFajr;

  /// No description provided for @prayerNameDhuhr.
  ///
  /// In en, this message translates to:
  /// **'DHUHR'**
  String get prayerNameDhuhr;

  /// No description provided for @prayerNameAsr.
  ///
  /// In en, this message translates to:
  /// **'ASR'**
  String get prayerNameAsr;

  /// No description provided for @prayerNameMaghrib.
  ///
  /// In en, this message translates to:
  /// **'MAGHRIB'**
  String get prayerNameMaghrib;

  /// No description provided for @prayerNameIsha.
  ///
  /// In en, this message translates to:
  /// **'ISHA'**
  String get prayerNameIsha;

  /// No description provided for @monthDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String monthDayTitle(int day);

  /// No description provided for @monthDayReadings.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 planned reading across prayers} other{{count} planned readings across prayers}}'**
  String monthDayReadings(int count);

  /// No description provided for @hifdhScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Hifdh'**
  String get hifdhScreenTitle;

  /// No description provided for @hifdhSubtitleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing listed yet'**
  String get hifdhSubtitleEmpty;

  /// No description provided for @hifdhSubtitleCount.
  ///
  /// In en, this message translates to:
  /// **'{enabled} active of {total} total in hifdh list'**
  String hifdhSubtitleCount(int enabled, int total);

  /// No description provided for @hifdhIntroBanner.
  ///
  /// In en, this message translates to:
  /// **'Hifdh is Quran memorization. What you list here is used when you build your monthly plan.'**
  String get hifdhIntroBanner;

  /// No description provided for @hifdhFabAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get hifdhFabAdd;

  /// No description provided for @hifdhMenuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get hifdhMenuEdit;

  /// No description provided for @hifdhMenuRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get hifdhMenuRemove;

  /// No description provided for @hifdhRemoveDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from hifdh list?'**
  String get hifdhRemoveDialogTitle;

  /// No description provided for @hifdhRemoveDialogContent.
  ///
  /// In en, this message translates to:
  /// **'{label} will be removed from your hifdh list. Your current month plan will be cleared until you generate a new one.'**
  String hifdhRemoveDialogContent(String label);

  /// No description provided for @hifdhRemoveErrorSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Could not remove: {error}'**
  String hifdhRemoveErrorSnackbar(String error);

  /// No description provided for @hifdhSaveErrorSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Could not save: {error}'**
  String hifdhSaveErrorSnackbar(String error);

  /// No description provided for @hifdhToggleErrorSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String hifdhToggleErrorSnackbar(String error);

  /// No description provided for @hifdhDuplicateError.
  ///
  /// In en, this message translates to:
  /// **'{label} is already in your hifdh list'**
  String hifdhDuplicateError(String label);

  /// No description provided for @hifdhBulkSkippedOne.
  ///
  /// In en, this message translates to:
  /// **'1 entry was skipped — {label} is already in your hifdh list.'**
  String hifdhBulkSkippedOne(String label);

  /// No description provided for @hifdhBulkSkippedMany.
  ///
  /// In en, this message translates to:
  /// **'{count} entries were skipped — already in your hifdh list.'**
  String hifdhBulkSkippedMany(int count);

  /// No description provided for @editorAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add surah or ayat'**
  String get editorAddTitle;

  /// No description provided for @editorEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get editorEditTitle;

  /// No description provided for @editorSurahLabel.
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get editorSurahLabel;

  /// No description provided for @editorEntireSurah.
  ///
  /// In en, this message translates to:
  /// **'Entire surah'**
  String get editorEntireSurah;

  /// No description provided for @editorEntireSurahOn.
  ///
  /// In en, this message translates to:
  /// **'The entire surah is on your hifdh list.'**
  String get editorEntireSurahOn;

  /// No description provided for @editorEntireSurahOff.
  ///
  /// In en, this message translates to:
  /// **'Only the ayat range below is included.'**
  String get editorEntireSurahOff;

  /// No description provided for @editorAyatCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ayat in this surah'**
  String editorAyatCount(int count);

  /// No description provided for @editorStartAyah.
  ///
  /// In en, this message translates to:
  /// **'Start ayah'**
  String get editorStartAyah;

  /// No description provided for @editorEndAyah.
  ///
  /// In en, this message translates to:
  /// **'End ayah'**
  String get editorEndAyah;

  /// No description provided for @editorAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add to hifdh list'**
  String get editorAddButton;

  /// No description provided for @editorSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editorSaveButton;

  /// No description provided for @editorNoSurahsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No surahs available.'**
  String get editorNoSurahsAvailable;

  /// No description provided for @editorPickerSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by surah name'**
  String get editorPickerSearchHint;

  /// No description provided for @editorPickerNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get editorPickerNoResults;

  /// No description provided for @editorModeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get editorModeNormal;

  /// No description provided for @editorModeBulkByJuz.
  ///
  /// In en, this message translates to:
  /// **'Bulk by Juz'**
  String get editorModeBulkByJuz;

  /// No description provided for @editorJuzLabel.
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get editorJuzLabel;

  /// No description provided for @editorJuzOption.
  ///
  /// In en, this message translates to:
  /// **'Juz {juz}'**
  String editorJuzOption(int juz);

  /// No description provided for @editorBulkAddButton.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Add 1 to hifdh list} other{Add {count} to hifdh list}}'**
  String editorBulkAddButton(int count);

  /// No description provided for @editorAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'Already added'**
  String get editorAlreadyAdded;

  /// No description provided for @editorSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get editorSelectAll;

  /// No description provided for @editorDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get editorDeselectAll;

  /// No description provided for @emptyNoPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'No plan yet'**
  String get emptyNoPlanTitle;

  /// No description provided for @emptyNoPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generate a plan to assign readings across the month.'**
  String get emptyNoPlanSubtitle;

  /// No description provided for @emptyNoPlanAction.
  ///
  /// In en, this message translates to:
  /// **'Generate Plan'**
  String get emptyNoPlanAction;

  /// No description provided for @emptyPoolTooSmallTitle.
  ///
  /// In en, this message translates to:
  /// **'Need more for a plan'**
  String get emptyPoolTooSmallTitle;

  /// No description provided for @emptyPoolTooSmallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Include at least two surahs or ayat ranges in your hifdh list (with the switch on), then generate a plan.'**
  String get emptyPoolTooSmallSubtitle;

  /// No description provided for @emptyPoolTooSmallAction.
  ///
  /// In en, this message translates to:
  /// **'Open Hifdh'**
  String get emptyPoolTooSmallAction;

  /// No description provided for @emptyHifdhListTitle.
  ///
  /// In en, this message translates to:
  /// **'Start your hifdh list'**
  String get emptyHifdhListTitle;

  /// No description provided for @emptyHifdhListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add full surahs or ayat ranges you are memorizing. Your monthly plan will draw from this list.'**
  String get emptyHifdhListSubtitle;

  /// No description provided for @emptyHifdhListAction.
  ///
  /// In en, this message translates to:
  /// **'Add surah or ayat'**
  String get emptyHifdhListAction;

  /// No description provided for @prayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// No description provided for @prayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// No description provided for @prayerNoReadings.
  ///
  /// In en, this message translates to:
  /// **'No readings assigned'**
  String get prayerNoReadings;

  /// No description provided for @lockSlotTooltip.
  ///
  /// In en, this message translates to:
  /// **'Lock slot'**
  String get lockSlotTooltip;

  /// No description provided for @unlockSlotTooltip.
  ///
  /// In en, this message translates to:
  /// **'Unlock slot'**
  String get unlockSlotTooltip;

  /// No description provided for @slotLockedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Slot locked'**
  String get slotLockedSnackbar;

  /// No description provided for @slotUnlockedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Slot unlocked'**
  String get slotUnlockedSnackbar;

  /// No description provided for @monthClearAllLocks.
  ///
  /// In en, this message translates to:
  /// **'Clear all locks'**
  String get monthClearAllLocks;

  /// No description provided for @monthNoLocksToClear.
  ///
  /// In en, this message translates to:
  /// **'No locks to clear for this month.'**
  String get monthNoLocksToClear;

  /// No description provided for @monthClearedLocksSnackbar.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Cleared 1 lock} other{Cleared {count} locks}}'**
  String monthClearedLocksSnackbar(int count);

  /// No description provided for @prayerAyatCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ayat'**
  String prayerAyatCount(int count);

  /// No description provided for @homeNowPrayingBadge.
  ///
  /// In en, this message translates to:
  /// **'NOW PRAYING'**
  String get homeNowPrayingBadge;

  /// No description provided for @homeUpNextBadge.
  ///
  /// In en, this message translates to:
  /// **'UP NEXT'**
  String get homeUpNextBadge;

  /// No description provided for @homePrayerStartedAt.
  ///
  /// In en, this message translates to:
  /// **'started {time}'**
  String homePrayerStartedAt(String time);

  /// No description provided for @homePrayerUntilNext.
  ///
  /// In en, this message translates to:
  /// **'IN {duration} UNTIL NEXT'**
  String homePrayerUntilNext(String duration);

  /// No description provided for @readerNoVerses.
  ///
  /// In en, this message translates to:
  /// **'No verses found.'**
  String get readerNoVerses;

  /// No description provided for @readerLoadErrorRetry.
  ///
  /// In en, this message translates to:
  /// **'Could not load verses. Tap to retry.'**
  String get readerLoadErrorRetry;

  /// No description provided for @readerSourceAttribution.
  ///
  /// In en, this message translates to:
  /// **'Quran text and translation source: quran.com (Quran Foundation).'**
  String get readerSourceAttribution;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsPreferences;

  /// No description provided for @settingsSurahsPerPrayer.
  ///
  /// In en, this message translates to:
  /// **'Surahs per prayer'**
  String get settingsSurahsPerPrayer;

  /// No description provided for @settingsSurahsPerPrayerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Number of surahs per prayer slot. Regenerate to apply.'**
  String get settingsSurahsPerPrayerSubtitle;

  /// No description provided for @settingsLockPastPrayers.
  ///
  /// In en, this message translates to:
  /// **'Lock past prayers'**
  String get settingsLockPastPrayers;

  /// No description provided for @settingsLockPastPrayersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Preserve prayer slots from days before today when regenerating.'**
  String get settingsLockPastPrayersSubtitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'Surah Planner helps you keep up with your hifdh by spreading your surahs and ayat across daily prayers throughout the month. Add what you\'re memorizing, generate a plan, and review a little each day.'**
  String get settingsAboutBody;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get langIndonesian;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @dialogRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get dialogRemove;

  /// No description provided for @backTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backTooltip;

  /// No description provided for @dismissTooltip.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismissTooltip;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'id':
      return SId();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
