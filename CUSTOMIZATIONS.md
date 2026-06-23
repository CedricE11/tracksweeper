# Tracksweeper Customizations

This document lists the user-visible customizations applied on top of vanilla [Traccar](https://github.com/traccar/traccar). Use it as a smoke-test checklist after any upstream Traccar merge, and as orientation when working on tracksweeper-specific behavior.

## Outside the trips report

- **Setting for changing visible report types** — Per-user setting (Settings → User → Reports Visible) controlling which entries appear in the reports menu. Stored as a comma-separated string in `user.attributes.visibleReports`.

- **Map area height bumped from 40% to 55%** — `containerMap.flexBasis: '55%'` in `traccar-web/src/reports/common/useReportStyles.js`. Affects all reports globally.

- **Custom App Version scheme** — App Version follows `6.12.2-swp.0.1.x` (upstream Traccar version + `-swp.0.1.<patch>` prerelease suffix). Lives in `traccar-web/package.json`; bumped once per commit, not per change-within-session.

- **Custom branding files** — Server title, description, primary color, and logo are runtime config (Settings → Server attributes), substituted into `index.html` by the Java `OverrideTextFilter`. Not a code customization per se — but the defaults matter for fresh installs.

- **Report renamed from "Trips" to "Sweeps" ("Balayage" in French)** — Done via locale overrides only (`reportTrips` key in `en.json` and `fr.json`); the underlying key name and API value `trips` are unchanged.

- **New users default to the Sweeps report only** — New users default to `visibleReports='trips'` (Sweeps only; previously `trips,chart,replay`). Set in both `traccar-web/src/settings/UserPage.jsx` (admin-creates-user) and `traccar-web/src/login/RegisterPage.jsx` (self-registration); the two must stay in sync.

- **Reports sidebar auto-hides for single-report users** — When at most one report type is active (`visibleReports.length <= 1`), the reports left drawer is hidden entirely and replaced by a floating circular back button overlaid on the top-left of the content (returns to the main map), reclaiming the vertical space a one-item nav would waste. `traccar-web/src/common/components/PageLayout.jsx` (gated to `/reports*` paths). The shared `visibleReports` parsing lives in the new `traccar-web/src/common/util/useVisibleReports.js` hook, also consumed by `ReportsMenu.jsx`.

- **Bottom-nav report button labeled “Sweeps”** — The bottom navigation uses the `reportTrips` label (“Sweeps” / “Balayage”) for the reports button instead of `reportTitle` (“Reports”). `traccar-web/src/common/components/BottomMenu.jsx`.

- **Translation helper extended** — `useTranslation` in `traccar-web/src/common/components/LocalizationProvider.jsx` supports `{placeholder}` interpolation and falls back to English when a key is missing from the active locale, so custom keys can be added to `en.json` only and degrade gracefully everywhere else.

- **URL aliases** — `/view/<slug>` short URLs (e.g. `/view/sunshinecoast`) redirect via nginx to token-link trip shares. Code-side counterpart: `navigateFallbackDenylist` regexes in `traccar-web/vite.config.js` so the service worker doesn't intercept those paths.

## In the trips report

Main file: `traccar-web/src/reports/TripReportPage.jsx`.

- **Selecting multiple trips at once + performance optimization** — Per-row checkboxes for multi-trip selection. Performance: parallel batched fetch (`BATCH_SIZE = 16`) instead of upstream's sequential one-at-a-time; routes cached by `deviceId+startTime+endTime` key.

- **Seeing multiple trips at once on the map** — All selected trips rendered simultaneously via the `MapMultiRoutePath` component (`traccar-web/src/map/MapMultiRoutePath.js`), which uses a single MapLibre source + layer for the whole `FeatureCollection` (cheap regardless of trip count).

- **Statistics display with units localization** — Stats row above the table showing total distance, total duration, and average speed for the selected trips, using `formatDistance` / `formatNumericHours` / `formatSpeed`.

- **Device auto-select** — On page load, if no `deviceId` or `groupId` is in the URL, every device the user has access to is selected and written into the URL. Counters the fact that Traccar v6.12's "all devices when none selected" release note refers to the dropdown placeholder UI only, not to server-side trip-query behavior — without this, clicking Show with an empty selection returns zero trips on most installations.

- **Time period auto-select** — On page load, if the URL contains a known period token (`today`, `yesterday`, `thisWeek`, etc.) the from/to are computed automatically; otherwise the default range is 30 days.

- **Data auto-show** — On first render, if the URL already has a `deviceId` or `groupId` (e.g. arrived via token-link / `/view/` redirect), the report auto-runs without the user clicking Show.

- **Route line coloring** — Single color (not upstream's per-segment speed coloring). Light mode uses the theme primary color; dark mode overrides to `#ec407a` magenta to avoid blending with map features (water/highways/parks). Implemented in `traccar-web/src/map/MapRoutePath.js` via an optional `color` prop.

- **No start/stop endpoint markers** — Upstream's flag icons at the start and end of each trip are removed.

- **Pinned column set** — Fixed visible columns: `startTime`, `endTime`, `distance`, `averageSpeed`. The Columns selector dropdown was removed so users can't drift away from this set.

- **No Groups dropdown** — `disableGroups` prop on `ReportFilter` hides the Groups selector. (`ReportFilter` also gained `wideDevices` and `showOnNewLine` props that are not currently wired up.)

- **Empty-state message when a search returns zero rows** — Renders "No sweeps between {from} and {to}. Try a different date range." (localized via `reportNoSweepsInRange` key in `en.json` + `fr.json`) only after a search has actually completed — never on first paint.

## Minor tooling

Not user-facing, but worth knowing about:

- `compileTestJava.options.encoding = "UTF-8"` in the parent `build.gradle` (fixes Cyrillic-char encoding error in `WialonProtocolDecoderTest`).
- `.claude/` in the parent `.gitignore`.
