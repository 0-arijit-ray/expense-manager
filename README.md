# Expense Manager

A private, **offline-first** personal finance app built with Flutter (Material 3). Track daily expenses, visualize spending, manage loans & EMIs, automate recurring income/expenses, follow an investment portfolio, and see your real net worth — all stored locally on device.

## Features

- **Daily expenses** — add / edit / delete income & expense transactions with categories, notes and dates. Grouped-by-day list with swipe-to-delete.
- **Dashboard** — weekly / monthly / yearly views with a cash-flow bar chart and a spending-by-category donut. Navigate across periods.
- **Loans tracker** — home / car / personal / education / gold / business loans. Auto-generates a full reducing-balance **EMI amortization schedule**. Marking an EMI paid optionally **auto-posts an expense**.
- **EMI alerts** — local notifications a configurable number of days before each due date.
- **Investment portfolio** — FDs, mutual funds, equities, gold, PPF, real estate and more, with gain/loss. A **dynamic rates** panel shows indicative interest/return rates (configurable live endpoint, with bundled reference defaults).
- **Recurring income & expenses** — mark salary, rent, subscriptions or SIPs as recurring (daily / weekly / monthly / yearly, every N units, optional end date). A built-in engine auto-posts due transactions on app launch / resume / pull-to-refresh. Any one-off expense can be made recurring straight from the add form.
- **EMI auto-pay** — loans can opt into auto-debit, which automatically marks EMIs paid (and posts the expense) once each due date passes. Everything flows into the dashboard, category splits and net worth automatically.
- **Net worth** — assets − liabilities, with a toggle to include/exclude outstanding loans, plus asset-allocation and liabilities breakdowns.
- **Modern UX** — Material 3, dynamic light/dark theme, Google Fonts, bottom-nav shell, empty states.

## Tech stack

| Concern | Choice |
| --- | --- |
| State management | [Riverpod](https://riverpod.dev) (`flutter_riverpod`) |
| Local database | [Drift](https://drift.simonbinder.eu) (reactive SQLite) |
| Navigation | `go_router` (StatefulShellRoute bottom nav) |
| Charts | `fl_chart` |
| Notifications | `flutter_local_notifications` + `timezone` |
| HTTP (rates) | `http` |

## Project structure

```
lib/
├── main.dart                 # bootstrap (prefs, notifications, ProviderScope)
├── app.dart                  # MaterialApp.router + theming
├── core/                     # theme, router, formatters, finance math, settings, date ranges
├── data/
│   ├── local/                # Drift database + tables + enums (database.g.dart is generated)
│   ├── repositories/         # expense / loan / investment repositories
│   └── providers.dart        # db + repository providers
├── services/                 # notifications, rates, recurring engine
├── shared/                   # reusable widgets
└── features/                 # dashboard, expenses, loans, investments, networth, recurring, settings
```

## Getting started

```bash
flutter pub get
# Regenerate Drift code if you change any table:
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Run the tests (finance math + recurrence):

```bash
flutter test
```

## Building for Google Play

1. **Create an upload keystore** (one time):

   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **Configure signing** — copy `android/key.properties.example` to `android/key.properties` and fill in your keystore path/passwords. This file is git-ignored. When present, release builds are signed automatically.

3. **Set the application id** if needed in `android/app/build.gradle.kts` (`applicationId`, currently `com.raylabs.expense_manager`) and the app name in `android/app/src/main/AndroidManifest.xml`.

4. **Bump the version** in `pubspec.yaml` (`version: 1.0.0+1` → `versionName+versionCode`).

5. **Build the release App Bundle** (this is what Play Store expects):

   ```bash
   flutter build appbundle --no-tree-shake-icons
   ```

   > `--no-tree-shake-icons` is required because categories store Material icon
   > codepoints in the database (dynamic `IconData`), which the icon tree-shaker
   > cannot statically analyze. The same applies to `flutter build apk`.

   Output: `build/app/outputs/bundle/release/app-release.aab`. Upload it in the Play Console. Release builds use R8 minify + resource shrinking + core-library desugaring (see `android/app/build.gradle.kts` and `proguard-rules.pro`).

## Dynamic investment rates

The "Indicative rates" panel uses `RatesService`. By default it shows bundled reference rates. To make them live, set a **Rates endpoint** URL in *Settings → Investments* that returns JSON in either of these shapes:

```json
{ "rates": { "fd_1y": { "label": "Bank FD (1yr)", "rate": 6.9, "unit": "p.a." } } }
```

```json
{ "Bank FD 1yr": 6.9, "PPF": 7.1 }
```

## Privacy

All financial data is stored in a local SQLite database on the device. The only optional network call is fetching investment rates from an endpoint you configure.
