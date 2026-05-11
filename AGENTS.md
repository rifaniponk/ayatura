# Agent Instructions

These rules apply to all AI coding agents working in this repository.

## Dart File Structure

- Keep one primary class per Dart file by default.
- A widget and its matching state class may live in the same Dart file, for example `MyWidget` and `_MyWidgetState`.
- If a touched file has unrelated classes, split them into separate files.

## Commit Gate

- Always run `dart format .` before creating any commit.
- If formatting changes files, include those changes in the same commit.
- Do not commit unless the format step has been executed.

## Localization

- Do not hardcode user-facing text in widgets, screens, dialogs, snackbars, or labels.
- Add and use translation keys via `lib/l10n`.
- Any newly introduced UI text must be localized through the app localization system.

## Writing Style

- Do not use `--` or em dashes (`—`) in user-facing text, comments, commit messages, or other wording you add; use commas, colons, parentheses, or separate sentences instead.

## Design System (Color & Typography)

- Use existing design tokens from `lib/core/theme/*` for colors and typography.
- Do not introduce new ad-hoc color values or font sizes unless truly necessary.
- If a new color or typography token is required, add it under `lib/core/theme` first, then consume it from there.
