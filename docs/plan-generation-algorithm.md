# Plan Generation Algorithm

## Overview

`MonthPlanGenerator.generate()` builds a `MonthPlan` that assigns hifdh entries (surahs or ayat ranges) to prayer slots across every day of a given month. The algorithm has two goals:

1. **Fair distribution** — every surah in the hifdh list is assigned before any surah repeats.
2. **Variety** — each time the user taps Regenerate, a different plan is produced.

---

## The Round-Robin Deck

The core of the algorithm is `_RoundRobinDeck`. Think of it like a physical card deck:

1. Shuffle all enabled hifdh entries.
2. Deal from the deck into prayer slots, working through the month day by day.
3. When the deck runs out, reshuffle into a new order and continue.

This guarantees that **every surah appears at least once before any surah repeats** — unlike picking randomly per slot, which can leave some surahs unused for weeks while others cluster.

```
Pool: [A, B, C, D]    maxSurahsPerPrayer = 2

Cycle 1 shuffle: [C, A, D, B]
  Day 1 Fajr   → [C, A]
  Day 1 Dhuhr  → [D, B]   ← deck exhausted, reshuffle into new order

Cycle 2 shuffle: [B, D, A, C]
  Day 1 Asr    → [B, D]
  ...
```

Each prayer slot gets `min(maxSurahsPerPrayerSlot, poolSize)` surahs.

---

## Randomness

Each time the user taps **Regenerate**, `_RoundRobinDeck` calls `dart:math Random` to shuffle the pool. Each shuffle is independently random, so every regeneration produces a different plan. The plan is immediately saved to SQLite, so it persists across app restarts.

---

## Locked Slots

Slots marked `PrayerSlot.locked` in an existing plan are **copied verbatim** and do not consume deck slots. This lets users pin specific surahs to specific prayers without disturbing the rest of the plan.

---

## Empty Pool Edge Case

If `enabledPool` is empty, `generate()` still produces a full month of days — each slot is simply empty (`PrayerSlot.surahs = []`). This keeps the plan shape consistent and avoids null-checks in the UI.

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
