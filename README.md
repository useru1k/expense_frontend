# Lumen Finance — Flutter client

The Flutter client currently runs on mock data while the backend contract is being validated. The FastAPI backend now lives in the sibling `C:\Yuvan\expense_backend` project and provides transaction, budget, and monthly summary endpoints backed by local SQLite.

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

The app includes a dark/light theme toggle, a five-destination bottom navigation bar, an interactive add-transaction form, transaction search and filters, calculated dashboard totals, category breakdowns, weekly spending bars, budget progress states, and a local currency picker for popular currencies including USD, INR, EUR, GBP, JPY, AUD, CAD, SGD, AED, and CHF. API integration is the next client step; the backend keeps a repository boundary so local SQLite can later move to PostgreSQL/RDS.
