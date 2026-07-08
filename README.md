# NCW Fireworks — Retail Management App

A UI-only Flutter project for **NCW Fireworks Retail**, built to match the sidebar
structure of the existing web app:

- **Dashboard**
- **Creation** → Party, Product
- **Billing** → Quotation, Estimation
- **Stock Adjustment**

This is a front-end scaffold only. Every list/detail screen currently runs on
in-memory dummy data (see `lib/data/dummy/dummy_data.dart`) so the app is fully
interactive (add/edit/delete, search, filter) without a backend. It's structured
so a Supabase (or any) backend can be wired in later with minimal changes.

## Tech stack

- **Flutter** (Android + iOS)
- **GetX** for state management, routing, and dependency injection
- **google_fonts**, **fl_chart**, **intl**, **animate_do** for UI polish

## Project structure

```
lib/
  core/
    theme/          # colors, text styles, ThemeData
    utils/           # responsive helpers
  data/
    models/          # Party, Product, Quotation, Estimation, StockAdjustment
    dummy/            # in-memory mock data (swap for repositories later)
  routes/            # route names + GetX page table
  widgets/           # shared widgets: drawer, scaffold, cards, badges, empty states
  modules/
    auth/            # login screen
    dashboard/       # stats, charts, recent activity
    party/           # Creation → Party (list + form)
    product/         # Creation → Product (list + form)
    quotation/       # Billing → Quotation (list + form)
    estimation/      # Billing → Estimation (list + form)
    stock_adjustment/ # Stock Adjustment (list + form)
```

Each module follows the same **binding → controller → view** pattern used
across Sri Softwarez's other GetX projects, so it should feel immediately
familiar.

## Getting started

This environment doesn't have the Flutter SDK installed, so the platform
folders (`android/`, `ios/`, etc.) aren't included — only `lib/` and the
project config. To run it:

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) if you haven't already.
2. Unzip this project, then from the project root run:
   ```bash
   flutter create . --project-name ncw_fireworks --platforms=android,ios
   ```
   This generates the `android/` and `ios/` platform folders around the
   existing `lib/` and `pubspec.yaml` without touching your Dart code.
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run it:
   ```bash
   flutter run
   ```

## Login screen

The login screen is UI-only right now — entering any username/password and
tapping **Sign in** takes you straight to the Dashboard after a short
simulated loading delay. Swap `LoginController.login()` in
`lib/modules/auth/login_controller.dart` for a real Supabase auth call
when the backend is ready.

## Wiring up the backend later

Each controller (`PartyController`, `ProductController`,
`QuotationController`, `EstimationController`, `StockAdjustmentController`)
currently seeds itself from `DummyData` in `onInit()` and mutates an in-memory
`RxList`. To connect Supabase:

1. Add a `data/repositories/` layer that talks to Supabase.
2. Replace the `DummyData.xxx()` seed calls with repository fetches.
3. Replace local list mutations (`insert`, `remove`, field updates) with
   repository calls, then refresh local state from the response.

The models in `lib/data/models/` are intentionally close to what a Supabase
table would look like, so mapping `fromJson`/`toJson` later should be
straightforward.

## Design

The theme is a "fireworks night sky" palette — deep midnight/navy background
with gold, ember-orange, magenta, and teal accent gradients used across
stat cards, charts, and status badges. All colors and text styles are
centralized in `lib/core/theme/` for easy tweaking.
