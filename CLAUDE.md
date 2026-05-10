# Claude Code Instructions

Follow `AGENTS.md` as the baseline policy.

## Required Rules

- Keep one primary class per Dart file by default.
- A widget and its matching state class may live in the same Dart file.
- Split unrelated classes in touched Dart files into separate files.
- Run `dart format .` before every commit and include its changes.
- Do not hardcode user-facing text; add translation keys and use `lib/l10n`.
- Use colors and typography from `lib/core/theme/*` (including font sizes); avoid new ad-hoc values.
- If a new color or typography token is truly needed, add it under `lib/core/theme` first.
