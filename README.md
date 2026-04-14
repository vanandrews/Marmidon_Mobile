# Marmidon Mobile

A Flutter-based mobile invoicing and sales management application for field sales representatives and business agents. Marmidon Mobile connects to the Marmidon Business Software backend to enable real-time invoice creation, receipt printing, and transaction management — all from a mobile device.

---

## Features

### Sales & Invoicing
- Create invoices with multiple line items, quantities, and unit prices
- Select agents and products from searchable dropdowns
- Auto-calculate totals with tax (18% VAT)
- Real-time inventory balance validation per product
- Generate invoice numbers and manage client references

### Receipt Printing
- Bluetooth thermal printer (58mm) support
- Formatted ESC/POS receipts with company header, itemised lines, tax breakdown, QR code, and barcode
- Scan, pair, and manage Bluetooth printers in-app

### Reports
- Search invoices by number, date range, and status
- View and print historical invoices
- Manage and submit pending invoices to the backend server

### Authentication
- Login with phone number, passcode, and device serial number
- "Remember Me" with secure local credential storage
- Internet connectivity validation before login

### Multi-Location Support
- Dynamically connects to region-specific backend servers (Wakiso, Fort Portal, Mityana, Jinja, Mbale, and more across Uganda)

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart SDK ^3.10.0) |
| State Management | `setState` / global variables |
| HTTP Client | `http` |
| Local Storage | `shared_preferences` |
| Bluetooth Printing | `print_bluetooth_thermal` + `esc_pos_utils_plus` |
| Permissions | `permission_handler ^11.0.0` |
| Connectivity | `connectivity_plus ^6.0.0` |
| Date Picker | `datetime_picker_formfield` |
| UI Components | `custom_searchable_dropdown`, `flutter_awesome_buttons`, `flutter_staggered_grid_view` |

---

## Project Structure

```
lib/
├── main.dart                           # App entry point & theme
├── Screens/
│   ├── login.dart                      # Authentication screen
│   ├── dashboard.dart                  # Bottom-nav shell (Home / Reports / Profile)
│   ├── Home/
│   │   ├── sales_page.dart             # Sales management landing
│   │   ├── inventory_page.dart         # Inventory overview
│   │   ├── finance_page.dart           # Finance / general ledger
│   │   └── Sales Management/
│   │       └── invoincing.dart         # Core invoicing screen + receipt generator
│   ├── Reports/
│   │   ├── reports.dart                # Reports dashboard
│   │   ├── search_invoice.dart         # Invoice search & reprint
│   │   ├── submit_pending_invoice.dart # Pending invoice submission
│   │   └── printing.dart              # Bluetooth printer management
│   └── Profile/
│       └── page_profile.dart           # User profile & logout
└── Services/
    ├── api_services.dart               # All backend API calls
    ├── model_service.dart              # Data parsing utilities
    └── my_globals.dart                 # Global app state
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.10.0)
- Android Studio or VS Code with Flutter extension
- Android device or emulator (API 21+)
- A paired Bluetooth thermal printer (58mm) for receipt printing

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd marmidon_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build (Release)

```bash
flutter build apk --release
```

> **Note:** Add your own signing config in `android/app/build.gradle.kts` before releasing to the Play Store.

---

## Android Permissions

| Permission | Purpose |
|---|---|
| `INTERNET` | API communication with backend servers |
| `ACCESS_NETWORK_STATE` | Connectivity check before network operations |
| `BLUETOOTH` / `BLUETOOTH_ADMIN` | Bluetooth printing on Android < 12 |
| `BLUETOOTH_SCAN` / `BLUETOOTH_CONNECT` / `BLUETOOTH_ADVERTISE` | Bluetooth printing on Android 12+ |
| `READ_EXTERNAL_STORAGE` / `WRITE_EXTERNAL_STORAGE` | File operations on Android < 13 |

---

## Configuration

The backend server is resolved dynamically at login based on the user's registered location. No manual configuration is required. To point to a specific server, update `globals.ipToUse` in [lib/Services/my_globals.dart](lib/Services/my_globals.dart).

---

## App Icon

Place icon assets in the `Images/` directory and regenerate launcher icons:

```bash
dart run flutter_launcher_icons
```

Configuration is defined under `flutter_icons:` in `pubspec.yaml`.

---

## Supported Android Versions

| API Level | Android Version | Supported |
|---|---|---|
| 21 – 29 | Android 5.0 – 9 | ✓ |
| 30 – 32 | Android 11 – 12L | ✓ |
| 33 – 35 | Android 13 – 14 | ✓ |
| 36 | Android 15 | ✓ |

---

## License

Proprietary — © Marmidon Business Software. All rights reserved.
