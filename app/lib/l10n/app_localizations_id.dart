// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class SId extends S {
  SId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Ayatura';

  @override
  String get brandLogoLabel => 'Logo Ayatura';

  @override
  String get navHome => 'Beranda';

  @override
  String get navMonth => 'Bulan';

  @override
  String get navHifdh => 'Hafalan';

  @override
  String get navInsight => 'Insight';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String appBarSubtitleChaptersPool(int chapters, int pool) {
    return '$chapters surah · $pool dalam daftar hafalan';
  }

  @override
  String appBarSubtitleChaptersLoading(int chapters) {
    return '$chapters surah · …';
  }

  @override
  String errorGeneric(String message) {
    return 'Galat: $message';
  }

  @override
  String get noSurahsLoaded => 'Surah tidak tersedia';

  @override
  String get dayLabel => 'Hari';

  @override
  String dayOfMonth(int day, int total) {
    return '$day / $total';
  }

  @override
  String get regeneratePlan => 'Buat Ulang Rencana';

  @override
  String get snackbarNeedTwoSegments =>
      'Butuh minimal dua item yang aktif di daftar hafalan.';

  @override
  String get monthScreenTitle => 'Bulan';

  @override
  String monthSubtitle(String month, int chapters) {
    return '$month · $chapters surah';
  }

  @override
  String monthScreenSubtitlePool(String monthYear, int count) {
    return '$monthYear · $count dalam daftar hafalan';
  }

  @override
  String monthNavYearDays(String monthYear, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari',
    );
    return '$monthYear · $_temp0';
  }

  @override
  String get monthNavPreviousMonth => 'Bulan sebelumnya';

  @override
  String get monthNavNextMonth => 'Bulan berikutnya';

  @override
  String get monthRegenerateCompact => 'Buat ulang';

  @override
  String monthNoPlanTitle(String monthYear) {
    return 'Belum ada rencana untuk $monthYear';
  }

  @override
  String get monthNoPlanSubtitle =>
      'Ketuk tombol dibawah ini untuk membuatnya.';

  @override
  String get monthNoPlanPastSubtitle =>
      'Rencana hanya bisa dibuat untuk bulan ini atau bulan mendatang.';

  @override
  String monthRegeneratePlanFor(String monthYear) {
    return 'Buat rencana untuk $monthYear';
  }

  @override
  String get homeNoPlanTitle => 'Belum ada rencana untuk hari ini';

  @override
  String get homeNoPlanCreateThisMonth => 'Buat rencana untuk bulan ini';

  @override
  String get monthTodayChip => 'Hari ini';

  @override
  String get monthFullSurah => 'Surah penuh';

  @override
  String monthAyatRange(int start, int end) {
    return '$start – $end';
  }

  @override
  String get monthPrayerEmpty => '—';

  @override
  String get prayerNameFajr => 'SUBUH';

  @override
  String get prayerNameDhuhr => 'DZUHUR';

  @override
  String get prayerNameAsr => 'ASHAR';

  @override
  String get prayerNameMaghrib => 'MAGHRIB';

  @override
  String get prayerNameIsha => 'ISYA';

  @override
  String monthDayTitle(int day) {
    return 'Hari $day';
  }

  @override
  String monthDayReadings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bacaan direncanakan di berbagai shalat',
    );
    return '$_temp0';
  }

  @override
  String get hifdhScreenTitle => 'Hafalan';

  @override
  String get hifdhSubtitleEmpty => 'Belum ada yang ditambahkan';

  @override
  String hifdhSubtitleCount(int enabled, int total) {
    return '$enabled aktif dari total $total hafalan';
  }

  @override
  String get hifdhIntroBanner =>
      'Hafalan yang kamu daftarkan di sini akan digunakan saat membuat rencana bulanan.';

  @override
  String get hifdhFabAdd => 'Tambah';

  @override
  String get hifdhMenuEdit => 'Edit';

  @override
  String get hifdhMenuRemove => 'Hapus';

  @override
  String get hifdhRemoveDialogTitle => 'Hapus dari daftar hafalan?';

  @override
  String hifdhRemoveDialogContent(String label) {
    return '$label akan dihapus dari daftar hafalan kamu. Rencana bulan ini akan dihapus sampai kamu membuat yang baru.';
  }

  @override
  String hifdhRemoveErrorSnackbar(String error) {
    return 'Gagal menghapus: $error';
  }

  @override
  String hifdhSaveErrorSnackbar(String error) {
    return 'Gagal menyimpan: $error';
  }

  @override
  String hifdhToggleErrorSnackbar(String error) {
    return 'Gagal menyimpan: $error';
  }

  @override
  String hifdhDuplicateError(String label) {
    return '$label sudah ada di daftar hafalan kamu';
  }

  @override
  String hifdhBulkSkippedOne(String label) {
    return '1 entri dilewati — $label sudah ada di daftar hafalan kamu.';
  }

  @override
  String hifdhBulkSkippedMany(int count) {
    return '$count entri dilewati — sudah ada di daftar hafalan kamu.';
  }

  @override
  String get editorAddTitle => 'Tambah surah atau ayat';

  @override
  String get editorEditTitle => 'Edit entri';

  @override
  String get editorSurahLabel => 'Surah';

  @override
  String get editorEntireSurah => 'Seluruh surah';

  @override
  String get editorEntireSurahOn =>
      'Seluruh surah ada dalam daftar hafalan kamu.';

  @override
  String get editorEntireSurahOff =>
      'Hanya rentang ayat di bawah yang disertakan.';

  @override
  String editorAyatCount(int count) {
    return '$count ayat dalam surah ini';
  }

  @override
  String get editorStartAyah => 'Ayat awal';

  @override
  String get editorEndAyah => 'Ayat akhir';

  @override
  String get editorAddButton => 'Tambah ke daftar hafalan';

  @override
  String get editorSaveButton => 'Simpan';

  @override
  String get editorNoSurahsAvailable => 'Tidak ada surah yang tersedia.';

  @override
  String get editorPickerSearchHint => 'Cari nama surah';

  @override
  String get editorPickerNoResults => 'Tidak ada hasil';

  @override
  String get editorModeNormal => '1 Surah';

  @override
  String get editorModeBulkByJuz => 'Bayak Surah (per Juz)';

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
      other: 'Tambah $count ke daftar hafalan',
    );
    return '$_temp0';
  }

  @override
  String get editorAlreadyAdded => 'Sudah ditambahkan';

  @override
  String get editorSelectAll => 'Pilih semua';

  @override
  String get editorDeselectAll => 'Batalkan pilihan';

  @override
  String get emptyPoolTooSmallTitle => 'Hafalan kurang';

  @override
  String get emptyPoolTooSmallSubtitle =>
      'Tambahkan setidaknya dua surah atau rentang ayat di daftar hafalan (dengan sakelar aktif), lalu buat rencana.';

  @override
  String get emptyPoolTooSmallAction => 'Buka Hafalan';

  @override
  String get emptyHifdhListTitle => 'Mulai daftar hafalan';

  @override
  String get emptyHifdhListSubtitle =>
      'Tambahkan surah lengkap atau rentang ayat yang sedang kamu hafal. Rencana bulanan kamu akan diambil dari daftar ini.';

  @override
  String get emptyHifdhListAction => 'Tambah surah atau ayat';

  @override
  String get prayerFajr => 'Subuh';

  @override
  String get prayerDhuhr => 'Dzuhur';

  @override
  String get prayerAsr => 'Ashar';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isya';

  @override
  String get prayerNoReadings => 'Tidak ada bacaan yang ditugaskan';

  @override
  String get lockSlotTooltip => 'Kunci slot';

  @override
  String get unlockSlotTooltip => 'Buka kunci slot';

  @override
  String get slotLockedSnackbar => 'Slot dikunci';

  @override
  String get slotUnlockedSnackbar => 'Kunci slot dibuka';

  @override
  String get monthClearAllLocks => 'Buka semua kunci';

  @override
  String get monthNoLocksToClear => 'Tidak ada slot terkunci untuk bulan ini.';

  @override
  String monthClearedLocksSnackbar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kunci dibuka',
      one: '1 kunci dibuka',
    );
    return '$_temp0';
  }

  @override
  String prayerAyatCount(int count) {
    return '$count ayat';
  }

  @override
  String get homeNowPrayingBadge => 'SEDANG SHALAT';

  @override
  String get homeUpNextBadge => 'BERIKUTNYA';

  @override
  String homePrayerStartedAt(String time) {
    return 'mulai $time';
  }

  @override
  String homePrayerUntilNext(String duration) {
    return '$duration LAGI MENUJU BERIKUTNYA';
  }

  @override
  String get readerNoVerses => 'Ayat tidak ditemukan.';

  @override
  String get readerLoadErrorRetry =>
      'Tidak bisa memuat ayat. Ketuk untuk mencoba lagi.';

  @override
  String get readerSourceAttribution =>
      'Sumber teks Al-Quran dan terjemahan: quran.com (Quran Foundation).';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsPreferences => 'Preferensi';

  @override
  String get settingsSurahsPerPrayer => 'Surah per shalat';

  @override
  String get settingsSurahsPerPrayerSubtitle =>
      'Jumlah surah per slot shalat. Buat ulang rencana untuk menerapkan.';

  @override
  String get settingsLockPastPrayers => 'Kunci shalat yang sudah lewat';

  @override
  String get settingsLockPastPrayersSubtitle =>
      'Pertahankan slot shalat sebelum hari ini saat membuat ulang rencana.';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsLanguageSubtitle => 'Pilih bahasa yang kamu inginkan';

  @override
  String get settingsAbout => 'Tentang';

  @override
  String get settingsAboutBody =>
      'Ayatura membantu kamu membangun kebiasaan membaca Surah secara konsisten, baik untuk menghafal, muraja’ah, maupun membiasakan Al-Qur’an hadir di setiap shalat. Kamu bisa menambahkan hafalan Surah sendiri, membuat rencana bacaan bulanan untuk shalat lima waktu, lalu menjalankannya setiap hari.';

  @override
  String get settingsAboutTileTitle => 'Tentang Ayatura';

  @override
  String get settingsAboutTileSubtitle => 'Versi dan privasi';

  @override
  String get aboutTitle => 'Tentang';

  @override
  String aboutVersionBuild(String version, String buildNumber) {
    return 'Versi $version ($buildNumber)';
  }

  @override
  String get aboutPrivacyPolicy => 'Kebijakan Privasi';

  @override
  String get aboutPrivacyBody =>
      'Ayatura menyimpan data rencana dan pengaturan di perangkat ini. Aplikasi ini tidak membutuhkan akun, dan data perencanaan Quranmu tidak dikirim ke server oleh aplikasi.';

  @override
  String get aboutCopyright => 'Copyright 2026 Ayatura. Semua hak dilindungi.';

  @override
  String get insightTitle => 'Insight';

  @override
  String get insightSubtitle =>
      'Penghitung frekuensi hafalan di semua rencana bulanan yang tersimpan.';

  @override
  String get insightEmpty => 'Belum ada entri hafalan aktif.';

  @override
  String insightAssignmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ditugaskan $count kali',
      one: 'Ditugaskan 1 kali',
    );
    return '$_temp0';
  }

  @override
  String get langEnglish => 'Inggris';

  @override
  String get langIndonesian => 'Indonesia';

  @override
  String get dialogCancel => 'Batal';

  @override
  String get dialogClose => 'Tutup';

  @override
  String get dialogRemove => 'Hapus';

  @override
  String get backTooltip => 'Kembali';

  @override
  String get dismissTooltip => 'Tutup';

  @override
  String get widgetDescription => 'Widget rencana shalat Ayatura';

  @override
  String get widgetEmptyNoPlanTitle => 'Belum ada rencana';

  @override
  String get widgetEmptyNoPlanSubtitle => 'Buka aplikasi untuk memulai';

  @override
  String get widgetEmptyPlanExpiredTitle => 'Rencana kedaluwarsa';

  @override
  String get widgetEmptyPlanExpiredSubtitle =>
      'Buka aplikasi untuk membuat ulang';

  @override
  String get widgetEmptyStaleTitle => 'Data widget perlu diperbarui';

  @override
  String get widgetEmptyStaleSubtitle =>
      'Buka aplikasi untuk menyegarkan widget';

  @override
  String get widgetTomorrowMarker => 'BESOK';
}
