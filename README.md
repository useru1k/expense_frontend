# Lumen Finance — Flutter client

The Flutter client starts with an empty transaction list and uses the FastAPI backend in the sibling `C:\Yuvan\expense_backend` project as its source of truth. The backend provides transaction, budget, and monthly summary endpoints backed by MongoDB Atlas.

## Run locally

From this directory with Flutter installed:

```bash
flutter create .
flutter pub get
dart format .
flutter analyze
flutter test
flutter run -d chrome
```

The app includes a dark/light theme toggle, a five-destination bottom navigation bar, an interactive add-transaction form, transaction search and filters, calculated dashboard totals, category breakdowns, weekly spending bars, budget progress states, and a local currency picker for popular currencies including USD, INR, EUR, GBP, JPY, AUD, CAD, SGD, AED, and CHF.

## Run end to end

Start the FastAPI backend first from `C:\Yuvan\expense_backend`:

```powershell
python -m app
```

Then start Flutter from this project:

```powershell
flutter pub get
flutter run -d chrome
```

The app uses `http://127.0.0.1:8000` by default and sends the development user header `X-User-Id: demo-user`. Transactions can be added as either income or expense, deleted individually, or cleared all at once from the Transactions screen. To use another API host:

```powershell
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8000 --dart-define=API_USER_ID=demo-user
```

For an Android emulator, use `http://10.0.2.2:8000` as the API URL. The add-transaction form writes to the backend, and app startup loads transactions and budgets from MongoDB Atlas through FastAPI.
