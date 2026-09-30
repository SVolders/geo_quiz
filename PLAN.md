# Flutter.Playground — GeoQuiz

Learning project. Goal: touch every important part of the Flutter ecosystem through one app that stays fun to build.

**App concept:** a geography quiz/game. Flags, countries, capitals, borders, maps. Multiple game modes, offline-capable, animated, tested, deployable to Android/iOS/Web.

**Audience:** experienced mobile dev, new to Flutter/Dart. So: skip hand-holding, go straight for the idiomatic architecture Flutter teams actually use.

---

## 1. Learning goals

Each milestone exists to force one ecosystem topic. Ordered so nothing is learned twice.

| # | Topic | Why it matters in Flutter |
|---|---|---|
| 1 | Widget tree, composition, `const` | Flutter has no XML/Storyboard. Layout *is* code. Composition replaces inheritance. |
| 2 | Null safety, sealed classes, pattern matching | Dart 3 features. `switch` on sealed types replaces visitor/enum hell. |
| 3 | Code generation (`build_runner`) | Freezed / json_serializable / riverpod_generator are near-universal. Learn the loop early. |
| 4 | Async: `Future`, `Stream`, `async*` | Whole framework is async-first. `FutureBuilder`/`StreamBuilder` vs state mgmt. |
| 5 | State management (Riverpod) | The thing every Flutter interview asks. Providers, `ref.watch`, autodispose, families. |
| 6 | Repository pattern + DI | How you keep API/DB/UI separated without a DI framework like Hilt or Swinject. |
| 7 | Navigation (`go_router`) | Declarative routing, deep links, web URLs, nested shells. |
| 8 | Persistence (Drift / shared_preferences) | Local-first behaviour, migrations, reactive queries. |
| 9 | Maps & custom painting | `flutter_map`, `CustomPainter`, hit-testing, gesture handling. |
| 10 | Animation | Implicit, explicit, `AnimationController`, `flutter_animate`, hero, staggered. |
| 11 | Theming & adaptive UI | Material 3, dark mode, `LayoutBuilder`, responsive breakpoints, platform adaptivity. |
| 12 | Testing | Unit, widget, golden, integration. `mocktail`, `ProviderScope` overrides. |
| 13 | Build & ship | Flavors, `--dart-define`, web build, GitHub Actions, Play/TestFlight. |
| 14 | Performance | DevTools, rebuild profiling, `RepaintBoundary`, image caching, `ListView.builder`. |

---

## 2. Data sources (all free, no API key, no auth)

| Data | Endpoint / source | Notes |
|---|---|---|
| Countries (name, flag, capital, region, population, area, borders, currencies, languages, latlng) | `https://restcountries.com/v3.1/all?fields=name,cca2,cca3,capital,region,subregion,population,area,borders,flags,latlng,currencies,languages` | Always pass `fields=`. Full payload is ~1.5 MB. |
| Flag images (PNG/SVG, sized) | `https://flagcdn.com/w320/be.png`, `https://flagcdn.com/be.svg` | Lowercase ISO-3166-1 alpha-2. Widths: 20, 40, 80, 160, 320, 640, 1280. |
| Map tiles | OpenStreetMap: `https://tile.openstreetmap.org/{z}/{x}/{y}.png` | Free, but set a real `userAgentPackageName` and respect the tile usage policy. For heavy use switch to a free-tier provider (Stadia / Carto / MapTiler). |
| Country polygons | Natural Earth 110m Admin 0 countries, as GeoJSON | Ship as a bundled asset (~250 KB simplified). Do not fetch at runtime. |
| Weather (bonus mode) | `https://api.open-meteo.com/v1/forecast?latitude=..&longitude=..` | No key. |
| Street-level imagery (stretch) | Mapillary API (free key) | Only if you go full GeoGuessr. |

**Rule:** fetch once, cache to local DB, serve from DB. The API is a seeding source, not a runtime dependency. That is what makes the offline milestone easy later.

---

## 3. Game modes (feature roadmap)

Build in this order. Each one adds a mechanic, not just a screen.

1. **Flag to Country** — 4-way multiple choice. The baseline loop.
2. **Country to Flag** — reverse. Proves the quiz engine is generic, not copy-pasted.
3. **Capital quiz** — same engine, different field. Forces an abstraction: `Question` as a sealed type.
4. **Flagdle** — guess the country from its flag, 5 tries, daily seed, share-as-emoji result. Forces deterministic RNG from date, streak persistence, clipboard.
5. **Map mode: tap the country** — show a name, user taps the map. Forces polygon hit-testing.
6. **Map mode: name that shape** — render one country outline via `CustomPainter`, no map tiles. Forces coordinate projection and path drawing.
7. **Border chains** — "get from Portugal to Poland by land in the fewest steps". BFS over the `borders` graph. Genuinely fun, genuinely a real algorithm.
8. **Higher / Lower** — population, area. Forces a card-swipe UI and different animation.
9. **Time attack / survival** — 60 s, wrong answer ends it. Forces a ticking stream and an `AnimationController` synced to real time.
10. **Stretch: multiplayer** — pass-and-play first (no backend), then Firebase or Supabase if you still care.

---

## 4. Architecture

Layered, feature-first. This is the layout most serious Flutter codebases converge on.

```
lib/
  main.dart                     # runApp + ProviderScope only
  app/
    app.dart                    # MaterialApp.router
    router.dart                 # go_router config
    theme/
      app_theme.dart            # Material 3 ColorScheme, light + dark
      app_typography.dart
  core/
    network/
      dio_client.dart           # base options, interceptors, retry
      api_exception.dart
    error/
      failure.dart              # sealed Failure type
      result.dart               # Result<T> = Success | Failure
    extensions/
    utils/
  data/
    models/
      country_dto.dart          # freezed + json_serializable
    datasources/
      countries_remote_ds.dart  # dio -> DTOs
      countries_local_ds.dart   # drift -> entities
    repositories/
      countries_repository_impl.dart
  domain/
    entities/
      country.dart              # freezed, no json, pure
    repositories/
      countries_repository.dart # abstract
    usecases/
      get_random_question.dart
      find_border_path.dart     # the BFS
  features/
    quiz/
      application/
        quiz_controller.dart    # Riverpod Notifier
        quiz_state.dart         # freezed sealed state
      presentation/
        quiz_screen.dart
        widgets/
          answer_button.dart
          score_bar.dart
    flagdle/
    map_game/
    stats/
    settings/
  shared/
    widgets/
      flag_image.dart
      app_scaffold.dart
      error_view.dart
      loading_view.dart
test/
integration_test/
assets/
  geo/ne_110m_countries.geojson
```

**Why `domain/` and `data/` are separate:** lets you swap restcountries for a bundled JSON without touching a widget. Also makes the repo mockable in tests, which is milestone 11.

**Do not over-engineer early.** For M1–M2, `data/` + `features/` is enough. Introduce `domain/` at M4 when the second game mode proves the abstraction is real. Premature layering is the number one way learning projects die.

---

## 5. Package list

Install as you reach the milestone that needs it, not all at once.

**State / codegen**
- `flutter_riverpod` + `riverpod_annotation` + `riverpod_generator` — state management
- `freezed` + `freezed_annotation` — immutable data classes, unions, `copyWith`
- `json_serializable` + `json_annotation` — JSON
- `build_runner` — the codegen runner

**Network**
- `dio` — HTTP with interceptors and cancel tokens. Better than `http` once you want retries.
- `connectivity_plus` — online/offline detection

**Storage**
- `drift` + `drift_dev` + `sqlite3_flutter_libs` — reactive SQL
- `shared_preferences` — settings and high scores only
- `path_provider` — file paths

**Navigation**
- `go_router`

**Maps / geo**
- `flutter_map` + `latlong2` — OSM map widget
- `flutter_map_cancellable_tile_provider` — avoids wasted tile fetches
- `geojson_vi` or a hand-rolled parser — polygon parsing
- `maps_toolkit` — point-in-polygon, distance. Or write it; it is about 20 lines.

**UI / UX**
- `cached_network_image` — flag caching
- `flutter_svg` — SVG flags
- `flutter_animate` — declarative animation chains
- `confetti` — win effect
- `google_fonts`
- `shimmer` — skeleton loaders

**Dev / test**
- `mocktail` — mocking without codegen
- `golden_toolkit`, or the built-in `matchesGoldenFile`
- `very_good_analysis` or `flutter_lints` — lint rules
- `integration_test` (ships with the SDK)

---

## 6. Milestones

Each milestone is one branch, one PR to yourself, one thing learned. Estimates assume evenings.

### M0 — Setup (1 evening)
- `flutter create --org eu.niko.playground --platforms android,ios,web geo_quiz`
- Add `very_good_analysis`, tighten `analysis_options.yaml`
- `git init`, check `.gitignore`. Decide on `*.g.dart` / `*.freezed.dart`: commit them, it keeps CI simple.
- Run on an Android emulator and in Chrome. Confirm hot reload works.
- **Done when:** the counter app runs on two platforms and you have deleted it.

### M1 — Static UI, no data (1–2 evenings)
- Hardcode 10 countries in a Dart list.
- Build the quiz screen: flag image, 4 buttons, score.
- All state in `StatefulWidget` + `setState`, **on purpose**. You need to feel why it hurts.
- **Learn:** widget tree, `Column` / `Row` / `Expanded` / `Stack`, `const`, `Theme.of(context)`, hot reload.
- **Done when:** playable with fake data.

### M2 — Real data (2 evenings)
- `dio` client, `CountryDto` with freezed + json_serializable.
- `build_runner watch` running in a terminal, permanently.
- Repository returning `List<Country>`.
- Loading / error / empty states.
- **Learn:** the codegen loop, async, `FutureBuilder`, JSON edge cases. restcountries has messy optional fields: `capital` can be missing, `borders` can be absent entirely.
- **Trap:** `?fields=` is mandatory or you download 1.5 MB every launch.
- **Done when:** real flags appear, and airplane mode shows a proper error view instead of a red screen.

### M3 — Riverpod (2 evenings)
- Rip out every `setState`.
- `@riverpod` providers: `countriesRepository`, `countriesList` (async), `quizController` (Notifier).
- `ProviderScope` at the root. `ref.watch` in `build`, `ref.read` in callbacks.
- **Learn:** provider types, `AsyncValue` and `.when(data/loading/error)`, autodispose, `ref.invalidate` for "new game".
- **Trap:** calling `ref.read` inside `build`, or mutating state in place instead of copying. Both silently break rebuilds.
- **Done when:** zero `StatefulWidget` outside animation code.

### M4 — Generic quiz engine, 3 modes (2 evenings)
- `sealed class Question` with `FlagQuestion`, `CapitalQuestion`, `ReverseFlagQuestion`.
- `switch` pattern matching to render each.
- Mode picker screen, `go_router` routes with typed params.
- **Learn:** Dart 3 sealed classes and exhaustive switch, declarative routing, deep links (`/quiz/flags`).
- **Done when:** adding a fourth mode touches one file.

### M5 — Persistence and offline (2 evenings)
- Drift DB: `countries` table, `game_results` table.
- First launch: fetch, then store. After that: read from DB, refresh in the background.
- Stats screen: best score per mode, accuracy per country ("you always miss Kyrgyzstan").
- **Learn:** Drift schema, reactive `.watch()` streams, migrations, seeding.
- **Done when:** the app fully works in airplane mode after one online launch.

### M6 — Flagdle and daily seed (1–2 evenings)
- Deterministic country-of-the-day: seed `Random` with days-since-epoch.
- 5 guesses, per-guess hints: same continent, population higher or lower, distance plus compass bearing to the target.
- Emoji share string to clipboard.
- Streak tracking.
- **Learn:** haversine distance and bearing, clipboard, date handling, `SharedPreferences` vs DB tradeoff.
- **Done when:** two devices on the same date get the same country.

### M7 — Maps (3 evenings, the big one)
- `flutter_map` with OSM tiles and a correct user agent.
- Load the Natural Earth GeoJSON from assets, parse into polygons.
- `PolygonLayer` rendering, tap, ray-casting point-in-polygon, resolve to a country.
- Game: "tap Peru". Highlight correct/wrong, animate the camera to the answer.
- **Learn:** map controllers, coordinate systems (WGS84 vs Web Mercator), hit-testing, asset loading, performance with ~200 polygons.
- **Traps:** multipolygons (Indonesia), and Russia crossing the antimeridian. Simplify the GeoJSON offline (mapshaper.org) or the frame budget dies.
- **Done when:** tapping works at every zoom level without jank.

### M8 — CustomPainter shape mode (2 evenings)
- Take one country polygon, normalise it to a unit box, draw with `Path` + `CustomPainter`.
- Animate the stroke drawing itself in, via `PathMetric.extractPath`.
- **Learn:** `CustomPainter`, `Canvas`, `Path`, transforms, `shouldRepaint`, `RepaintBoundary`.
- **Done when:** a country outline draws itself in ~800 ms and looks good.

### M9 — Border-chain puzzle (1–2 evenings)
- Build an adjacency graph from `borders` (cca3 codes).
- BFS shortest path. Validate the user's chain.
- **Learn:** pure-Dart algorithm work and testing it properly. This is your cleanest testable domain logic — use it to learn `test/`.
- **Done when:** `findPath('PRT', 'POL')` is unit-tested with 5 cases, including "no land route".

### M10 — Polish pass (2–3 evenings)
- Material 3 seeded colour scheme, full dark mode.
- `flutter_animate`: flag flip, score count-up, staggered answer buttons.
- Hero transition from list to detail.
- Haptics, optional sound, confetti on a new high score.
- Skeleton loaders, empty states, pull-to-refresh.
- Responsive: two columns on tablet and web via `LayoutBuilder`.
- **Learn:** implicit vs explicit animation, `ThemeExtension`, adaptive layout.
- **Done when:** it does not look like a tutorial app.

### M11 — Tests (2 evenings)
- Unit: BFS, question generator, distance math, DTO to entity mapping.
- Widget: quiz screen with `ProviderScope(overrides: [repoProvider.overrideWith(fakeRepo)])`.
- Golden: answer button states, flag card.
- Integration: a full game run on an emulator.
- **Learn:** `pumpWidget`, `pump` vs `pumpAndSettle`, `mocktail`, provider overrides, golden flakiness across platforms.
- **Done when:** `flutter test` is green and meaningful, and one deliberately introduced bug turns it red.

### M12 — Ship (1–2 evenings)
- Flavors: dev and prod, `--dart-define` for the base URL.
- App icons and splash: `flutter_launcher_icons`, `flutter_native_splash`.
- `flutter build web --release`, deploy to GitHub Pages.
- GitHub Action: analyze plus test on push; build web and deploy on tag.
- Android signed release AAB. iOS if you have a Mac.
- **Learn:** build config, CI, web renderer tradeoffs, `--base-href` for Pages.
- **Done when:** you can send someone a URL.

### M13 — Performance (1 evening)
- DevTools: widget rebuild profiler, timeline, memory.
- Find and fix unnecessary rebuilds, unbounded `ListView`, uncached images, expensive work in `build`.
- **Learn:** `const` propagation, `ref.watch(...select(...))`, `RepaintBoundary`, image cache sizing.
- **Done when:** 60 fps scrolling a 250-country list on a mid-range device, and you can explain one fix you made.

---

## 7. Notes from mobile-native experience

Things that surprise people coming from Android or iOS:

- **No layout files.** Deeply nested widget constructors *are* the layout. Extract widgets aggressively; a `build` over roughly 60 lines is a smell.
- **`const` is a performance feature**, not just style. `const` widgets skip rebuild. The linter will nag. Obey it.
- **Rebuild is not repaint.** Flutter rebuilds large subtrees constantly and that is fine. Do not optimise until DevTools says so.
- **No Activity or ViewController lifecycle** in the form you know. You get `initState` / `dispose` on `State`, plus `AppLifecycleListener` for foreground and background.
- **`BuildContext` is the DI container** for inherited things (`Theme`, `MediaQuery`, `Navigator`). Riverpod's `ref` is the DI container for your own.
- **Hot reload preserves state; hot restart does not.** If something looks impossible, hot restart before debugging.
- **Codegen is normal.** `dart run build_runner watch -d` running permanently is the standard workflow, not a hack.
- **Packages die.** Check pub.dev "last published" and the Flutter Favorite badge before depending on something.
- **Web is real but weird.** CanvasKit is heavy (~1.5 MB), and text selection and scroll physics differ. Fine for a demo.

---

## 8. Definition of done (whole project)

- Works offline after the first launch
- Five or more game modes sharing one engine
- Persistent stats and streaks
- Light and dark, phone, tablet and web
- `flutter analyze` clean under `very_good_analysis`
- Meaningful test suite, green in CI
- Deployed web build with a public URL
- README with screenshots and an architecture diagram

---

## 9. Stretch ideas (after M13)

- Spaced repetition: resurface the countries you get wrong (SM-2 algorithm)
- Mapillary street-view round, which turns it into actual GeoGuessr
- Pass-and-play multiplayer, then real-time via Supabase
- Localisation (`flutter_localizations`, ARB files): NL / FR / EN
- Home-screen widgets via `home_widget`, which drops you into platform channels — familiar ground
- Accessibility pass: `Semantics`, screen reader, contrast, large text
- Melos monorepo split: `packages/geo_core`, `packages/geo_ui`

---

## 10. First commands

```bash
flutter create --org eu.niko.playground --platforms android,ios,web geo_quiz
```

```bash
cd geo_quiz && flutter pub add dio flutter_riverpod riverpod_annotation freezed_annotation json_annotation go_router cached_network_image
```

```bash
cd geo_quiz && flutter pub add --dev build_runner riverpod_generator freezed json_serializable very_good_analysis mocktail
```

```bash
cd geo_quiz && dart run build_runner watch -d
```
