# Surah Planner

A Flutter app for Muslims who are memorizing (hifdh) the Quran. Add the surahs or ayat ranges you are memorizing, and Surah Planner will spread them across your five daily prayers throughout the month.

---

## Features

- **Hifdh list** — Add full surahs or specific ayat ranges you are memorizing. Toggle entries on/off without deleting them.
- **Monthly plan** — Auto-generates a plan that assigns your hifdh entries to Fajr, Dhuhr, Asr, Maghrib, and Isha for every day of the month.
- **Fair distribution** — Uses a round-robin algorithm so every surah appears at least once before any repeats. See [docs/plan-generation-algorithm.md](docs/plan-generation-algorithm.md).
- **Regenerate** — Tap Regenerate any time to get a fresh, different plan.
- **Lock slots** — Pin a specific surah to a specific prayer so it is never reassigned.
- **Persistence** — Plans survive app restarts (stored in SQLite via Drift).
- **Bilingual** — English and Indonesian (Bahasa Indonesia) localization.

---

## Screenshots

_Coming soon._

---

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) — see `pubspec.yaml` for the minimum version
- Dart 3.x
- Android Studio / Xcode for device emulation

### Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Test

```bash
flutter test
flutter analyze
```

### Build

```bash
flutter build apk        # Android
flutter build ios        # iOS (macOS only)
flutter build macos      # macOS desktop
```

---

## Project structure

```
lib/
├── main.dart                        # Entry point, ProviderScope
├── screens/                         # Four tab screens + app shell
├── providers/                       # Riverpod state (plan, pool, locale, nav)
├── data/
│   ├── models/                      # Domain objects (MonthPlan, Surah, …)
│   ├── local/                       # Drift database schema + generated code
│   └── services/                    # Plan generator, surah seed loader
├── core/
│   ├── theme/                       # Colors, text styles, Material theme
│   └── plan_config.dart             # Shared numeric constants
├── widgets/                         # Reusable UI components
├── l10n/                            # ARB localization files
└── validators/                      # Form validation helpers

assets/
└── data/surahs.json                 # Bundled master surah list (114 entries)

docs/
└── plan-generation-algorithm.md     # How plan generation works
```

---

## Tech stack

| Layer | Library |
|---|---|
| UI | Flutter + Material 3 |
| State | [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) ^3.3.1 |
| Database | [drift](https://pub.dev/packages/drift) ^2.32.1 (SQLite) |
| i18n | flutter_localizations + ARB (EN, ID) |
| Preferences | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| SVG | [flutter_svg](https://pub.dev/packages/flutter_svg) |

---

## Documentation

- [Plan generation algorithm](docs/plan-generation-algorithm.md)

---

## Contributing

1. Fork the repo and create a branch from `main`.
2. Run `flutter analyze` and `flutter test` before opening a PR.
3. Follow the existing code style — no comments unless the *why* is non-obvious.
