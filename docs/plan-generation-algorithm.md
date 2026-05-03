# Plan Generation Algorithm

## Overview

`MonthPlanGenerator.generate()` builds a `MonthPlan` that assigns hifdh entries (surahs or ayat ranges) to prayer slots across every day of a given month. The algorithm is designed around two goals:

1. **Fair distribution** — every surah in the hifdh list appears roughly the same number of times before any surah repeats.
2. **Controlled randomness** — plans look varied day-to-day, but the same inputs always produce the same result (except when the user explicitly regenerates).

---

## The Round-Robin Deck

The core of the algorithm is `_RoundRobinDeck`. Think of it like a physical card deck:

1. Shuffle all enabled hifdh entries.
2. Deal one card at a time into prayer slots, left to right through the month.
3. When the deck runs out, reshuffle and start a new cycle.

This guarantees that **every surah is assigned at least once before any surah repeats** — unlike independent random sampling per slot, which can leave some surahs unused for weeks while others cluster.

```
Pool: [A, B, C, D]    maxSurahsPerPrayer = 2

Cycle 1 shuffle: [C, A, D, B]
  Day 1 Fajr   → [C, A]
  Day 1 Dhuhr  → [D, B]   ← deck exhausted, reshuffle

Cycle 2 shuffle: [B, D, A, C]
  Day 1 Asr    → [B, D]
  ...
```

Each prayer slot gets `min(maxSurahsPerPrayerSlot, poolSize)` surahs from the deck.

---

## Determinism and Seeds

The shuffle at each cycle is produced by `_XorShift32`, a fast deterministic PRNG. The seed for cycle `n` is:

```
seed_n = (baseSeed XOR (n × 0x9e3779b9)) & 0x7FFFFFFF
```

`baseSeed` itself is derived from the month, year, and an optional salt:

```dart
baseSeed = (year × 100_000 + month × 1_000 + salt) & 0x7FFFFFFF
```

| Scenario | Salt | Result |
|---|---|---|
| First generation | `0` (default) | Same pool + same month → identical plan every time |
| User taps Regenerate | `DateTime.now().millisecondsSinceEpoch` | Different plan each tap |

Since plans are persisted to SQLite, strict reproducibility is no longer critical — the database is the source of truth. Determinism on first generation is a convenience: clearing and regenerating without tapping the button gives a consistent starting point.

---

## Locked Slots

Slots marked `PrayerSlot.locked` in an existing plan are **copied verbatim** and do not consume deck slots. This lets users pin specific surahs to specific prayers without disturbing the rest of the plan.

---

## Empty Pool Edge Case

If `enabledPool` is empty, `generate()` still produces a full month of days — each slot is simply empty (`PrayerSlot.surahs = []`). This avoids null-checks in the UI and keeps the plan shape consistent.

---

## Configuration

| Constant | Location | Default | Meaning |
|---|---|---|---|
| `maxSurahsPerPrayerSlot` | `lib/core/plan_config.dart` | `10` | Max surahs assigned to a single prayer slot |

---

## Key files

| File | Role |
|---|---|
| `lib/data/services/month_plan_generator.dart` | Algorithm implementation |
| `lib/core/plan_config.dart` | Numeric limits |
| `lib/providers/month_plan_provider.dart` | Calls `generate()`, persists result |
| `lib/data/local/app_database.dart` | `savePlan` / `loadLatestPlan` |
| `test/month_plan_generator_test.dart` | Unit tests for the generator |
