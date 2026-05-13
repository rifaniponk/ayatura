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
      'Butuh minimal dua surah yang aktif di daftar hafalan.';

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
      'Mulai susun bacaan Al-Qur’anmu untuk bulan ini. Ayatura akan membantu membagi hafalanmu secara seimbang ke dalam shalat 5 waktu, sehingga seluruh hafalan tetap terjaga dan terus dibaca secara rutin.';

  @override
  String get monthNoPlanPastSubtitle =>
      'Rencana hanya bisa dibuat untuk bulan ini atau bulan mendatang.';

  @override
  String monthRegeneratePlanFor(String monthYear) {
    return 'Buat rencana untuk $monthYear';
  }

  @override
  String get homeNoPlanTitle => 'Belum ada rencana';

  @override
  String get homeNoPlanHeroSubtitle =>
      'Anda belum punya rencana surah harian. Ketuk tombol dibawah ini untuk membuatnya secara otomatis untuk bulan ini.';

  @override
  String get homeNoPlanCreateThisMonth => 'Buat rencana pertamamu';

  @override
  String get homeNoPlanLearnHow => 'Pelajari cara kerjanya';

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
    return '$label akan dihapus dari daftar hafalan namun tidak akan mempengaruhi rencana bulanan kamu.';
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
  String get editorAddTitle => 'Tambah hafalan surah';

  @override
  String get editorEditTitle => 'Edit hafalan';

  @override
  String get editorSurahLabel => 'Surah';

  @override
  String get editorEntireSurah => 'Seluruh ayat';

  @override
  String get editorEntireSurahOn => 'Masukan seluruh ayat dari surah ini.';

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
  String get editorModeBulkByJuz => 'Sekaligus (per Juz)';

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
  String get emptyPoolTooSmallTitle => 'Belum ada hafalan aktif';

  @override
  String get emptyPoolTooSmallSubtitle =>
      'Tambahkan beberapa surah untuk memulai membuat rencana shalat. Setelah itu kamu bisa membuat rencana untuk satu bulan ke depan dengan mudah.';

  @override
  String get emptyPoolTooSmallAction => 'Buka Hafalan';

  @override
  String get emptyHifdhListTitle => 'Belum ada hafalan';

  @override
  String get emptyHifdhListSubtitle =>
      'Tambahkan surah lengkap atau rentang ayat yang akan kamu baca didalam shalat. Rencana bulanan kamu akan diambil dari daftar ini.';

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
      'Sumber teks Al-Quran dan terjemahan: quran.com';

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
  String get settingsLockPastPrayers => 'Kunci slot shalat yang sudah lewat';

  @override
  String get settingsLockPastPrayersSubtitle =>
      'Rencana hari sebelumnya tidak akan berubah saat membuat ulang rencana.';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsLanguageSubtitle => 'Pilih bahasa yang kamu inginkan';

  @override
  String get settingsAbout => 'Tentang';

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
  String get aboutBodyParagraph1 =>
      '<b>Ayatura</b> membantu kamu mendistribusikan <b>hafalan Surah</b> ke dalam <b>shalat lima waktu</b> secara teratur dan seimbang. Masukkan daftar hafalanmu, lalu <b>Ayatura</b> akan menyusun <b>rencana bacaan harian</b> agar seluruh hafalan tetap sering dibaca dan tidak hanya berputar di Surah yang itu-itu saja.';

  @override
  String get aboutBodyParagraph2 =>
      'Banyak orang yang memiliki <b>hafalan cukup banyak</b> sering bingung menentukan Surah apa yang ingin dibaca saat <b>shalat</b>. Akibatnya, beberapa Surah menjadi jarang dibaca dan perlahan mulai terlupa. <b>Ayatura</b> hadir untuk membantu menjaga hafalan tetap hidup melalui <b>pola bacaan yang lebih merata setiap hari</b>.';

  @override
  String get aboutPrivacyPolicy => 'Kebijakan Privasi';

  @override
  String get aboutPrivacyBody =>
      'Ayatura menyimpan semua data dan pengaturan di perangkat ini. Aplikasi ini tidak membutuhkan akun dan datamu tidak dikirim ke server.';

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
