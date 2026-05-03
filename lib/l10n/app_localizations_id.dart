// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class SId extends S {
  SId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Surah Planner';

  @override
  String get navHome => 'Beranda';

  @override
  String get navMonth => 'Bulan';

  @override
  String get navHifdh => 'Hafalan';

  @override
  String get navMore => 'Lainnya';

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
  String get editorModeNormal => 'Biasa';

  @override
  String get editorModeBulkByJuz => 'Massal per juz';

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
  String get emptyNoPlanTitle => 'Belum ada rencana';

  @override
  String get emptyNoPlanSubtitle =>
      'Buat rencana untuk menugaskan bacaan sepanjang bulan.';

  @override
  String get emptyNoPlanAction => 'Buat Rencana';

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
  String get prayerNoReadings => 'Tidak ada bacaan yang ditugaskan';

  @override
  String prayerAyatCount(int count) {
    return '$count ayat';
  }

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsPreferences => 'Preferensi';

  @override
  String get settingsPrayerReminders => 'Pengingat shalat';

  @override
  String get settingsPrayerRemindersSubtitle =>
      'Beri tahu sebelum setiap shalat';

  @override
  String get settingsSurahsPerPrayer => 'Surah per shalat';

  @override
  String get settingsSurahsPerPrayerSubtitle =>
      'Jumlah surah per slot saat membuat rencana. Buat ulang rencana setelah mengubah ini.';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsLanguageSubtitle => 'Pilih bahasa yang kamu inginkan';

  @override
  String get settingsAbout => 'Tentang';

  @override
  String get settingsAboutBody =>
      'Surah Planner menyebarkan hafalan kamu—surah penuh atau rentang ayat—ke berbagai shalat sepanjang bulan. Penyimpanan rencana ke perangkat akan hadir berikutnya.';

  @override
  String get langEnglish => 'Inggris';

  @override
  String get langIndonesian => 'Indonesia';

  @override
  String get dialogCancel => 'Batal';

  @override
  String get dialogRemove => 'Hapus';

  @override
  String get backTooltip => 'Kembali';

  @override
  String get dismissTooltip => 'Tutup';
}
