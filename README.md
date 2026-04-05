# Broom

A minimalist iOS app for decluttering your possessions. Inventory your items with photos, organize them into categories, and compare them in a Tinder-style rating flow using an ELO ranking system to figure out what you truly value.

## Features

- **Inventory** - Add items with photos, names, descriptions, and categories. Search, filter, and sort your collection.
- **ELO Rating** - Swipe between pairs of items to rank them. The ELO algorithm surfaces what matters most to you.
- **Bulk Add** - Rapid-fire photo capture to add many items quickly. Claude API integration auto-detects item names.
- **Categories** - Organize items with emoji-labeled categories. Filter inventory and ratings by category.
- **Background Removal** - Automatic subject segmentation removes photo backgrounds for a clean look.
- **Export/Import** - Back up and restore your data as a ZIP archive.

## Architecture

```
lib/
  models/          Data classes (Item, Category)
  services/        Infrastructure layer (database, photo storage, API clients)
  blocs/           Business logic (BLoC pattern with flutter_bloc)
  screens/         Full-page tab views
  modals/          Bottom sheet dialogs
  widgets/         Reusable UI components
  theme.dart       Design system (colors, spacing, typography)
  service_locator.dart   Dependency injection (GetIt)
  main.dart        App entry point
```

Data flows through layers: **UI** dispatches events to **BLoCs**, which call **Services** and emit new state. Models are immutable data classes shared across all layers.

## Getting Started

### Prerequisites

- Flutter SDK (3.9.0+)
- Xcode (for iOS builds)
- CocoaPods

### Run

```bash
cd app
flutter pub get
cd ios && pod install && cd ..
flutter run
```

### Claude API Key (optional)

To enable automatic item name detection from photos, add a Claude API key in Settings. This is optional - the app works fully without it.