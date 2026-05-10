# Ayatura — Daily Surah Planner

A monorepo containing the Flutter app and landing page for Ayatura, a planner for Muslims who are memorizing (hifdh) the Quran.

---

## Repository structure

```
ayatura/
├── app/        ← Flutter mobile app (Android & iOS)
├── landing/    ← Landing page (web)
└── .github/    ← CI/CD workflows
```

---

## app/

A Flutter app that helps Muslims spread their hifdh entries across the five daily prayers throughout the month.

### Features

- **Hifdh list** — Add full surahs or specific ayat ranges you are memorizing. Toggle entries on/off without deleting them.
- **Monthly plan** — Auto-generates a plan that assigns your hifdh entries to Fajr, Dhuhr, Asr, Maghrib, and Isha for every day of the month.
- **Fair distribution** — Uses a round-robin algorithm so every surah appears at least once before any repeats. See [app/docs/plan-generation-algorithm.md](app/docs/plan-generation-algorithm.md).
- **Regenerate** — Tap Regenerate any time to get a fresh, different plan.
- **Lock slots** — Pin a specific surah to a specific prayer so it is never reassigned.
- **Persistence** — Plans survive app restarts (stored in SQLite via Drift).
- **Bilingual** — English and Indonesian (Bahasa Indonesia) localization.

### Getting started

#### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) — see `app/pubspec.yaml` for the minimum version
- Dart 3.x
- Android Studio / Xcode for device emulation

#### Run

```bash
cd app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

#### Run environments

```bash
flutter run                          # dev
flutter run -t lib/main_prod.dart    # prod
```

#### Test

```bash
cd app
flutter test
flutter analyze
```

#### Build

```bash
cd app
flutter build apk -t lib/main_prod.dart     # Android (prod)
flutter build ios -t lib/main_prod.dart     # iOS (macOS only, prod)
flutter build macos -t lib/main_prod.dart   # macOS desktop (prod)
```

### Project structure

```
app/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── screens/                     # Tab screens + app shell
│   ├── providers/                   # Riverpod state (plan, pool, locale, nav)
│   ├── data/
│   │   ├── models/                  # Domain objects (MonthPlan, Surah, …)
│   │   ├── local/                   # Drift database schema + generated code
│   │   └── services/               # Plan generator, surah seed loader
│   ├── core/
│   │   ├── theme/                   # Colors, text styles, Material theme
│   │   └── plan_config.dart         # Shared numeric constants
│   ├── widgets/                     # Reusable UI components
│   ├── l10n/                        # ARB localization files
│   └── validators/                  # Form validation helpers
├── assets/
│   └── data/surahs.json             # Bundled master surah list (114 entries)
├── docs/
│   └── plan-generation-algorithm.md
└── pubspec.yaml
```

### Tech stack

| Layer | Library |
|---|---|
| UI | Flutter + Material 3 |
| State | [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) ^3.3.1 |
| Database | [drift](https://pub.dev/packages/drift) ^2.32.1 (SQLite) |
| i18n | flutter_localizations + ARB (EN, ID) |
| Preferences | [shared_preferences](https://pub.dev/packages/shared_preferences) |

---

## landing/

Landing page for Ayatura. Framework TBD.

---

## Contributing

1. Fork the repo and create a branch from `main`.
2. For app changes, run `flutter analyze` and `flutter test` from the `app/` directory before opening a PR.
3. Follow the existing code style — no comments unless the *why* is non-obvious.
