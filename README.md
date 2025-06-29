
# 🛒 Grocery Expiry Reminder App

A simple Flutter application to help users track grocery items and get reminded before they expire. This app stores items locally, shows how many days are left until expiry, and sends daily reminders using local notifications. It also supports light/dark themes with a toggle.

---

## 🚀 Features

- ✅ Add grocery items with expiry dates
- ✅ List all added items with:
  - Days left until expiry
  - Color indicators: 🟢 Safe, 🟠 Near Expiry, 🔴 Expiring Soon
- ✅ Delete items from the list
- ✅ Save data locally using Hive (offline support)
- ✅ Daily local notifications (1 day before expiry)
- ✅ Light/Dark mode toggle (with theme persistence)

---

## 📱 Screenshots

| Add Item | Item List with Indicator | Dark Mode |
|----------|--------------------------|-----------|
| *(Add your screenshots here)* | *(Add your screenshots here)* | *(Add your screenshots here)* |

---

## 🏗 Folder Structure

```
lib/
│
├── main.dart                         # Entry point, app init
├── models/
│   └── grocery_item.dart             # Hive model class
│   └── grocery_item.g.dart           # Hive generated adapter
│
├── screens/
│   └── home_screen.dart              # UI for adding, listing items
│
├── services/
│   └── notification_service.dart     # Local notification setup
│
├── widgets/                          # Optional reusable components
│   └── item_tile.dart                # (Optional) List tile widget
│
└── utils/                            # (Optional) Helper files, themes
    └── themes.dart
```

---

## 🔧 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-username/grocery_expiry_reminder.git
cd grocery_expiry_reminder
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Generate Hive TypeAdapter

```bash
flutter pub run build_runner build
```

### 4. Run the app

```bash
flutter run
```

---

## 📦 Dependencies

| Package                  | Usage                            |
|--------------------------|----------------------------------|
| `hive`, `hive_flutter`   | Local data storage               |
| `flutter_local_notifications` | Local notification alerts     |
| `intl`                   | Date formatting                  |
| `shared_preferences`     | Theme mode persistence           |
| `build_runner`, `hive_generator` | Code generation for Hive     |

---

## 🔔 Notification Behavior

- Users will get a **reminder 1 day before** an item's expiry date.
- Notifications are scheduled at the time of item addition.

---

## 📄 License

This project is licensed under the MIT License.

---

## ✨ Author

Developed by **Shubham Lohar**
