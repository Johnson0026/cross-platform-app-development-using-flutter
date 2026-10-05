# MindLog 🧠 — Daily Mood & Journal Tracker

> A cross-platform, privacy-focused daily mood and journal tracking application built with Flutter 3.x and Material 3.

**Author**: Johnson Pillai  
**Roll No**: 150096724110  
**Course**: B.Tech Computer Science & Engineering (AI)  
**Subject**: Cross Platform App Development (Major Project)  

---

## 📌 Problem Statement

In today's fast-paced digital environment, maintaining mental wellbeing requires regular self-reflection. **MindLog** addresses this need by providing a simple, serene, and private environment where users can:
1. Quick-select their daily mood emoji.
2. Write a short daily journal reflection.
3. Review past entries organized chronologically.

**Privacy Guarantee**: All user data is stored **100% locally on-device** using `shared_preferences` serialized as structured JSON. No user data ever leaves the device.

---

## ✨ Key Features

- **Smooth 3-Step Guided Workflow**:
  - **Step 1 of 3 (Mood Selection)**: Interactive mood picker featuring 5 distinct emotional categories (😄 Great, 🙂 Good, 😐 Okay, 😔 Low, 😢 Awful). Tapping a mood plays a custom `AnimationController` scale + fade sequence before proceeding.
  - **Step 2 of 3 (Journal Entry)**: Form with `GlobalKey<FormState>`, multiline `TextFormField`, input validation (non-empty, max 500 chars), live character counter, and **one-entry-per-day** intelligent auto-fill for updates.
  - **Step 3 of 3 (Entry History)**: Grouped `ListView.builder` by date, note preview with ellipsis truncation, swipe-to-delete with `AlertDialog` confirmation, and empty state screen.
- **Full Entry Details View**: Read full reflections, edit existing entries, or delete logs with double confirmation.
- **Instant Light/Dark Theme Switching**: Material 3 theme engine with soft teal and lavender seed colors. Theme toggles dynamically in the AppBar across all screens with smooth `AnimatedTheme` transitions.
- **Adaptive & Responsive Layout**: Built with `LayoutBuilder` and `MediaQuery`. Operates smoothly on mobile phones, tablets, desktop, and web, featuring a side-by-side split view on wide screens.
- **100% On-Device Persistence**: Data persists through app restarts using `shared_preferences`.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: Flutter 3.13+ (Dart 3.0+)
- **Design System**: Material Design 3 (`useMaterial3: true`)
- **State Management**: Provider pattern (`ChangeNotifier`, `MultiProvider`)
- **Local Persistence**: `shared_preferences` (JSON serialization)
- **Date Formatting**: `intl` package
- **Architecture**: Clean Architecture-Lite (Separation of Models, Services, Providers, Screens, and Widgets)

---

## 📁 Directory Structure

```text
cross platform app development/
├── assets/
│   └── icon/
│       └── app_icon.png           # Master 512x512 PNG Launcher Icon
├── docs/
│   ├── FIGMA_DESIGN_SPEC.md       # 5-Frame Figma UX/UI & Prototype Spec
│   └── VIVA_GUIDE.md              # Viva Guide, Concepts, 30 Q&As & Presentation Script
├── lib/
│   ├── main.dart                  # Application entry point & MultiProvider setup
│   ├── models/
│   │   ├── entry.dart             # Entry model class with JSON serialization & copyWith
│   │   └── mood_type.dart         # MoodType enum with emojis, labels, scores & colors
│   ├── providers/
│   │   ├── entries_provider.dart  # ChangeNotifier for entry CRUD & date grouping
│   │   └── theme_provider.dart    # ChangeNotifier for dynamic Light/Dark mode state
│   ├── screens/
│   │   ├── entry_detail_screen.dart # Step detail screen with Edit & Delete options
│   │   ├── history_screen.dart      # Step 3: Grouped history list & swipe-to-delete
│   │   ├── journal_entry_screen.dart# Step 2: Form validation & note input
│   │   └── mood_picker_screen.dart # Step 1: Animated mood picker screen
│   ├── services/
│   │   └── storage_service.dart   # SharedPreferences load/save repository service
│   ├── theme/
│   │   └── app_theme.dart         # Material 3 light & dark calming color themes
│   └── widgets/
│       ├── entry_tile.dart        # Custom list tile for history entry preview
│       └── mood_chip.dart         # Animated scale+fade mood selection card
├── test/
│   ├── entry_test.dart            # Unit tests for JSON round-trip & MoodType
│   └── widget_test.dart           # Widget tests for MoodPickerScreen navigation
├── BUILD.md                       # Comprehensive Build & Store Deployment commands
├── pubspec.yaml                   # Package manifest & launcher icons configuration
└── README.md                      # Project documentation (this file)
```

---

## 🚀 How to Run the App

1. **Clone or navigate to the repository directory**:
   ```bash
   cd "cross platform app development"
   ```

2. **Fetch dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify static code quality**:
   ```bash
   flutter analyze
   flutter test
   ```

4. **Launch the app**:
   ```bash
   # Run on Google Chrome Web Browser
   flutter run -d chrome

   # Run on Android Device / Emulator
   flutter run -d android
   ```

---

## 📷 App UI Screenshots (Visual Design Overview)

```text
+-----------------------------------+   +-----------------------------------+
|  MindLog               ☀️  📜     |   |  MindLog Note                  🌙 |
+-----------------------------------+   +-----------------------------------+
|    STEP 1 OF 3 • MOOD SELECTION   |   |    STEP 2 OF 3 • JOURNAL NOTE     |
|                                   |   |                                   |
|   How are you feeling today?      |   |   +---------------------------+   |
|   Select an emoji below:          |   |   | 😄 Feeling Great          |   |
|                                   |   |   | Sunday, Oct 4, 2026       |   |
|   +-----------+   +-----------+   |   |   +---------------------------+   |
|   |   😄      |   |   🙂      |   |   |                                   |
|   |  Great    |   |   Good    |   |   |  What's on your mind today?       |
|   +-----------+   +-----------+   |   |  +-----------------------------+  |
|   +-----------+   +-----------+   |   |  | Had a wonderful time building|  |
|   |   😐      |   |   😔      |   |   |  | Flutter app! (42/500)       |  |
|   |   Okay    |   |   Low     |   |   |  +-----------------------------+  |
|   +-----------+   +-----------+   |   |                                   |
|           +-----------+           |   |   [  Save Journal Entry  ]        |
|           |   😢      |           |   +-----------------------------------+
|           |   Awful   |           |
|           +-----------+           |   +-----------------------------------+
+-----------------------------------+   |  Journal History               ☀️  |
                                        +-----------------------------------+
                                        |    STEP 3 OF 3 • JOURNAL HISTORY  |
                                        |                                   |
                                        |  TODAY                            |
                                        |  +-----------------------------+  |
                                        |  | 😄 Great            2:30 PM |  |
                                        |  | Had a wonderful time...     |  |
                                        |  +-----------------------------+  |
                                        +-----------------------------------+
```

---

## 📜 License & Credits

Developed by **Johnson Pillai** (Roll No: 150096724110) for the **B.Tech CSE & AI** Cross Platform App Development coursework. Built with Flutter 3.x.
