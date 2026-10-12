# Lumen Finance — Flutter UI Preview

Phase 1 of the personal expense tracker is implemented as a local-only Flutter UI. It uses in-memory mock data and intentionally contains no FastAPI, authentication, database, or cloud integration.

## Run locally

From this directory with Flutter installed:

```bash
flutter create .
flutter pub get
dart format .
flutter analyze
flutter test
flutter run
```

The app includes a dark/light theme toggle, a five-destination bottom navigation bar, an interactive add-transaction form, transaction search and filters, calculated dashboard totals, category breakdowns, weekly spending bars, and budget progress states.
