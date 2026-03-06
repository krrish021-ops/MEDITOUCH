# 💊 MEDITOUCH — Smart Health Reminder

A premium, glassmorphic Flutter health-tech application for managing medicines, appointments, daily wellness check-ins, symptom analysis, and personal health profiles — all wrapped in a stunning futuristic dark UI with animated backgrounds and glowing accent colors.

> 📖 **For a detailed breakdown of every file and folder, see [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)**

---

## � About MEDITOUCH

**MEDITOUCH** is your all-in-one digital health companion designed to simplify everyday health management. Whether you're managing chronic medications, tracking doctor visits, or just trying to build healthier daily habits — MEDITOUCH puts everything you need in one beautiful, intuitive app.

### 🎯 What It Does

MEDITOUCH helps users take control of their health by combining **medicine management**, **appointment tracking**, **symptom analysis**, **daily wellness monitoring**, and **personal health profiles** into a single unified experience. It replaces the need for multiple health apps by offering:

- **Never miss a dose** — Set up medicines with custom schedules and get timely push notifications before every dose.
- **Stay on top of appointments** — Schedule doctor visits, get reminders 30 minutes before each appointment, and keep a full history of past visits.
- **Quick symptom guidance** — Feeling unwell? Select your symptoms and instantly see common OTC medicine suggestions to discuss with your doctor.
- **Track daily wellness** — Log your mood, track water intake, and monitor health vitals like heart rate, blood pressure, and blood sugar — all from one dashboard.
- **Know your body** — BMI auto-calculated from your profile, with health conditions and allergies stored for quick reference.
- **Emergency-ready** — Emergency contact info is always one tap away.

### ✅ Advantages

| Advantage | Why It Matters |
|---|---|
| **All-in-One Health Hub** | No need to juggle 5 different apps — medicines, appointments, vitals, mood, and water tracking all in one place |
| **Smart Notifications** | Automatic reminders for both medicine doses and upcoming appointments so you never forget |
| **Works Offline** | All data is stored locally on-device — no internet required for daily use |
| **Privacy First** | Your health data stays on your phone, not on any cloud server |
| **Beautiful & Intuitive UI** | Glassmorphic dark theme with animated backgrounds makes health management feel premium, not boring |
| **Quick Onboarding** | 4-step setup captures your complete health profile in under 2 minutes |
| **Symptom Intelligence** | Built-in symptom-to-medicine mapping gives instant guidance when you're feeling unwell |
| **Cross-Platform** | Built with Flutter — runs on Android, iOS, Web, and Windows from a single codebase |
| **Lightweight** | Fast startup, smooth animations, minimal battery drain |
| **Open & Extensible** | Clean architecture (Riverpod + Repository pattern) makes it easy to extend with new features or a backend |

### 👥 Who Is It For?

- **Patients on daily medication** — Especially those managing multiple prescriptions with different schedules
- **Elderly users & caregivers** — Simple, clear interface with large touch targets and glowing visual cues
- **Health-conscious individuals** — Anyone who wants to track water intake, mood, and vitals daily
- **People with chronic conditions** — Store health conditions, allergies, and emergency contacts in one place
- **Students & professionals** — Quick symptom checker for minor ailments before visiting a doctor
- **Anyone who forgets appointments** — Get notified 30 minutes before every doctor visit

---

## 📑 Table of Contents

- [Features](#-features)
- [About MEDITOUCH](#-about-meditouch)
- [Design Philosophy](#-design-philosophy)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Quick Start](#-quick-start)
- [App Screens](#-app-screens)
- [Design System](#-design-system)
- [Data Models](#-data-models)
- [State Management](#-state-management)
- [Dependencies](#-dependencies)
- [Build APK](#-build-apk)
- [Project Structure](#-project-structure)

---

## ✨ Features

| Feature | Description |
|---|---|
| **💊 Medicine Management** | Add, edit, delete medicines with dosage, form, frequency, reminder times, and food preference |
| **📊 Dose Tracking** | Track taken/untaken doses per medicine with visual progress and adherence streak |
| **📅 Appointment Scheduling** | Add upcoming appointments, reschedule, view past history with specialty-aware color coding |
| **🔔 Appointment Reminders** | Automatic push notification 30 minutes before every scheduled appointment |
| **🤒 Symptom Checker** | Select symptoms and get OTC medicine suggestions from a built-in knowledge map |
| **😊 Daily Check-In** | Log daily mood with 5 emoji levels and accent glow effects |
| **💧 Water Intake Tracker** | Track glasses of water consumed vs daily goal with glass progress bar |
| **💓 Health Vitals** | Display heart rate, blood pressure, blood sugar in glassmorphic cards |
| **⚖️ BMI Calculator** | Auto-calculated from height/weight with color-coded range badge |
| **👤 Health Profile** | Store personal info, blood group, health conditions, allergies, emergency contact |
| **🎯 Onboarding Flow** | 4-step glassmorphic onboarding to collect user data on first launch |
| **🔔 Local Notifications** | Medicine reminders via `flutter_local_notifications` + timezone scheduling |
| **✨ Glassmorphic UI** | Full `BackdropFilter`-based glassmorphism across every screen |
| **🌌 Animated Backgrounds** | Floating gradient orbs (nebula effect) using `AnimationController` + trigonometry |

---

## 🎨 Design Philosophy

The app follows a **Vivid Dark Health-Tech** aesthetic inspired by futuristic sci-fi interfaces:

- **Deep space backgrounds** — Animated floating gradient orbs drifting via sine/cosine trigonometric motion (12-second animation loop)
- **Glassmorphic cards** — `BackdropFilter` blur (sigma 18) with 8% white fill and 19% white borders
- **4 accent colors** — Electric Blue `#00B4FF`, Neon Green `#00FFB0`, Vivid Orange `#FF8C42`, Radiant Pink `#FF4F8B`
- **Gradient buttons** — Blue→Pink CTA buttons with tap-glow shadow effects
- **Micro-interactions** — Pulsing glow on splash, animated nav icons, gradient progress bars, color-coded vitals

---

## 🛠 Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter** (Dart SDK ^3.7.0) | Cross-platform UI framework |
| **Riverpod** (`flutter_riverpod ^2.6.1`) | Reactive state management (`StateNotifier` + `Provider`) |
| **Google Fonts** (`^6.2.1`) | Poppins (headings) + Inter (body) typography |
| **flutter_local_notifications** (`^21.0.0-dev.2`) | Scheduled medicine reminders |
| **timezone** (`^0.11.0`) | Timezone-aware notification scheduling |
| **shared_preferences** (`^2.3.4`) | Persistent local key-value storage |
| **intl** (`^0.19.0`) | Date/time formatting |
| **uuid** (`^4.5.1`) | Unique ID generation for data models |
| **percent_indicator** (`^4.2.4`) | Circular and linear progress indicators |
| **lottie** (`^3.2.1`) | Lottie animation support |
| **animations** (`^2.0.11`) | Material motion transitions |

---

## 🏗 Architecture

Layered architecture with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│              UI Layer                   │
│   8 Screens  ←→  4 Custom Widgets       │
├─────────────────────────────────────────┤
│          State Management               │
│  5 Riverpod StateNotifier Providers     │
├─────────────────────────────────────────┤
│            Data Layer                   │
│  4 In-Memory Repositories (with CRUD)   │
├─────────────────────────────────────────┤
│             Services                    │
│   NotificationService (singleton)       │
└─────────────────────────────────────────┘
```

**Data flow:** `Screen` watches a `Provider` → `Provider` wraps a `StateNotifier` → `StateNotifier` calls `Repository` methods → state change triggers UI rebuild automatically.

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK ^3.7.0 / Dart SDK ^3.7.0
- Chrome (web) / Android Studio (Android) / Xcode (iOS)

### Run the App

```bash
# Clone the repository
git clone https://github.com/krrish021-ops/MEDITOUCH.git
cd MEDITOUCH

# Install dependencies
flutter pub get

# Run on Chrome (web)
flutter run -d chrome

# Run on Android device/emulator
flutter run -d android

# Run on iOS simulator
flutter run -d ios

# Build release APK
flutter build apk

# Verify zero analysis issues
flutter analyze
```

---

## 📱 App Screens

### 1. Splash Screen
Animated gradient background (blue→pink) with rotating gradient, pulsing glow ring, and fade-in tagline text. Auto-navigates after 3 seconds.

### 2. Onboarding (4 Steps)
| Step | Accent Color | Collects |
|---|---|---|
| Personal Info | Electric Blue | Name, age, gender, phone, email, blood group |
| Body & Emergency | Neon Green | Height, weight, emergency contact |
| Health Conditions | Vivid Orange | Multi-select from 16 common conditions |
| Allergies | Radiant Pink | Multi-select from 16 common allergies |

### 3. Home Dashboard
Greeting with time-based message, medication adherence streak, overall progress card, water intake tracker, rotating health tips, 3 vitals cards (heart rate/BP/blood sugar), next dose reminder, next appointment preview, and 5-emoji mood check-in row.

### 4. Medicines
Searchable medicine list with 4 filter chips (All/Active/Completed/Today). Cards show form icon, name, dosage, time chips with gradient glow on untaken doses, and popup menu actions. Gradient FAB for adding new medicines.

### 5. Add Medicine
Form with glassmorphic dropdowns for Form (Tablet/Capsule/Syrup/Injection) and Frequency, time picker chips with rotating accent colors, food preference toggle, and gradient save button.

### 6. Appointments
Segmented control for Upcoming/Past with specialty-aware accent colors (Cardio=pink, Dental=green, Eye=orange). Cards with date/location info, reschedule button, and bottom sheet for adding new appointments.

### 7. Symptom Checker
8 interactive symptom chips with per-symptom icons. Matching OTC medicine suggestions displayed in glassmorphic result cards from built-in `kSymptomToMedicineMap`.

### 8. Profile
Gradient-bordered avatar with glow, BMI card with color-coded range, health condition chips (green), allergy chips (orange), emergency contact card (pink), and editable profile fields with section-colored labels.

---

## 🎨 Design System

### Color Palette

| Token | Hex | Usage |
|---|---|---|
| `bgPrimary` | `#181A20` | Scaffold background (Charcoal Black) |
| `bgSecondary` | `#23243A` | Card backgrounds (Deep Slate) |
| `electricBlue` | `#00B4FF` | Primary accent, nav highlights |
| `neonGreen` | `#00FFB0` | Success states, streaks, conditions |
| `vividOrange` | `#FF8C42` | Warnings, allergies, BP vitals |
| `radiantPink` | `#FF4F8B` | Heart rate, emergency, CTA gradient end |

### Glassmorphism Recipe

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(18),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
    child: Container(
      decoration: BoxDecoration(
        color: Color(0x14FFFFFF),          // 8% white fill
        border: Border.all(color: Color(0x30FFFFFF)),  // 19% white border
        borderRadius: BorderRadius.circular(18),
      ),
    ),
  ),
)
```

### Gradients

| Name | Colors | Usage |
|---|---|---|
| `accentGradient` | Blue → Pink | Primary CTAs, FABs, nav highlights |
| `greenBlueGradient` | Green → Blue | Streak badges, tip icons |
| `orangePinkGradient` | Orange → Pink | Time badges, secondary CTAs |

---

## 📦 Data Models

All defined in `lib/models/models.dart`:

| Model | Key Fields | Computed |
|---|---|---|
| `UserProfile` | name, age, gender, bloodGroup, healthConditions[], allergies[], height, weight | `bmi`, `bmiCategory` |
| `Medicine` | name, dosage, form, reminderTimes[], frequency, withFood, takenTimes[] | `takenCount`, `totalDoses` |
| `Appointment` | doctorName, specialty, dateTime, location, status | `isUpcoming`, `isPast` |
| `DailyCheckIn` | date, mood (1-5), note | — |
| `WaterIntake` | glassCount, goal | `percentage` |
| `VitalRecord` | type, value, value2, unit | — |
| `HealthTip` | title, body, icon (emoji) | — |

**Built-in constants:** `kHealthConditions` (16), `kAllergies` (16), `kBloodGroups` (8), `kHealthTips` (10)

---

## 🔄 State Management

**Riverpod** `StateNotifier` + `StateNotifierProvider` pattern:

| Provider | Manages |
|---|---|
| `medicinesProvider` | Medicine CRUD, notification scheduling, dose tracking, adherence streak |
| `appointmentsProvider` | Appointment CRUD, upcoming/past filtering |
| `profileProvider` | User profile, onboarding completion flag |
| `checkInProvider` | Daily mood check-in |
| `waterIntakeProvider` | Water glass count + daily goal |

Each backed by a singleton in-memory repository provider.

---

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  flutter_riverpod: ^2.6.1       # State management
  google_fonts: ^6.2.1           # Poppins + Inter typography
  intl: ^0.19.0                  # Date formatting
  shared_preferences: ^2.3.4     # Local persistence
  uuid: ^4.5.1                   # Unique ID generation
  percent_indicator: ^4.2.4      # Progress indicators
  flutter_local_notifications: ^21.0.0-dev.2  # Medicine reminders
  timezone: ^0.11.0              # Timezone-aware scheduling
  lottie: ^3.2.1                 # Lottie animations
  animations: ^2.0.11            # Material motion

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^5.0.0
```

---

## 📱 Build APK

```bash
flutter build apk
# Output: build/app/outputs/flutter-apk/app-release.apk (~52 MB)
```

---

## 📁 Project Structure

```
smart_health_reminder/
├── lib/                           # Main Dart application code
│   ├── main.dart                  # App entry point, navigation shell
│   ├── models/                    # Data classes (7 models + constants)
│   ├── providers/                 # Riverpod state management (5 notifiers)
│   ├── repositories/              # In-memory CRUD data stores (4 repos)
│   ├── services/                  # NotificationService singleton
│   ├── screens/                   # 8 UI screens
│   ├── theme/                     # Design system (colors, gradients, typography)
│   └── widgets/                   # 4 reusable glassmorphic widgets
├── android/                       # Android platform config
├── ios/                           # iOS platform config
├── web/                           # Web platform (PWA manifest, index.html)
├── windows/                       # Windows desktop platform config
├── test/                          # Widget tests
├── assets/                        # Static assets (noise.png)
├── pubspec.yaml                   # Project manifest & dependencies
└── PROJECT_STRUCTURE.md           # Detailed file & folder documentation
```

> 📖 **See [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for a complete breakdown of every file and folder.**

---

## 📄 License

This project is for educational and personal use.

---

> Built with 💙 using Flutter — **MEDITOUCH: Your Digital Health Guardian**
