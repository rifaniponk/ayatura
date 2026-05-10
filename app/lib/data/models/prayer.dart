/// The five daily prayers in order.
enum Prayer {
  fajr,
  dhuhr,
  asr,
  maghrib,
  isha;

  /// Short 3-char label used in the month-view grid.
  String get shortLabel {
    switch (this) {
      case Prayer.fajr:
        return 'FAJ';
      case Prayer.dhuhr:
        return 'DHU';
      case Prayer.asr:
        return 'ASR';
      case Prayer.maghrib:
        return 'MAG';
      case Prayer.isha:
        return 'ISH';
    }
  }

  /// Full display name.
  String get label {
    switch (this) {
      case Prayer.fajr:
        return 'Fajr';
      case Prayer.dhuhr:
        return 'Dhuhr';
      case Prayer.asr:
        return 'Asr';
      case Prayer.maghrib:
        return 'Maghrib';
      case Prayer.isha:
        return 'Isha';
    }
  }
}
