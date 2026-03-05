# 💊 MEDITOUCH — Smart Health Reminder

A premium, glassmorphic Flutter health-tech application for managing medicines, appointments, daily wellness check-ins, symptom analysis, and personal health profiles — all wrapped in a stunning futuristic dark UI with animated backgrounds and glowing accent colors.

---

## 📑 Table of Contents

- [Features](#-features)
- [Screenshots Concept](#-screenshots-concept)
- [Tech Stack](#-tech-stack)
- [Project Architecture](#-project-architecture)
- [Directory Structure](#-directory-structure)
- [Design System](#-design-system)
- [Screen Breakdown](#-screen-breakdown)
- [Data Models](#-data-models)
- [State Management](#-state-management)
- [Repositories](#-repositories)
- [Services](#-services)
- [Custom Widgets](#-custom-widgets)
- [Getting Started](#-getting-started)
- [Dependencies](#-dependencies)

---

## ✨ Features

| Feature | Description |
|---|---|
| **Medicine Management** | Add, edit, delete medicines with dosage, form, frequency, reminder times, and food preference |
| **Dose Tracking** | Track taken/untaken doses per medicine with visual progress |
| **Appointment Scheduling** | Add upcoming appointments, reschedule, view past history |
| **Symptom Checker** | Select symptoms and get OTC medicine suggestions from a built-in knowledge map |
| **Daily Check-In** | Log daily mood with 5 emoji levels |
| **Water Intake Tracker** | Track glasses of water consumed vs daily goal |
| **Health Vitals** | Display heart rate, blood pressure, blood sugar at a glance |
| **BMI Calculator** | Auto-calculated from height/weight in profile |
| **Health Profile** | Store personal info, blood group, health conditions, allergies, emergency contact |
| **Onboarding Flow** | 4-step onboarding to collect user data on first launch |
| **Local Notifications** | Medicine reminders via `flutter_local_notifications` + timezone scheduling |
| **Glassmorphic UI** | Full `BackdropFilter`-based glassmorphism across every screen |
| **Animated Backgrounds** | Floating gradient orbs (nebula effect) using `AnimationController` + trigonometry |

---

## 🎨 Screenshots Concept

The app follows a **Vivid Dark Health-Tech** aesthetic:

- **Deep space backgrounds** with animated floating gradient orbs
- **Glassmorphic cards** with blurred translucent surfaces and glowing borders
- **4 accent colors** used throughout: Electric Blue, Neon Green, Vivid Orange, Radiant Pink
- **Gradient buttons** with tap-glow effects
- **Micro-interactions** like pulsing glow on splash, animated nav icons, gradient progress bars

---

## 🛠 Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter** (Dart SDK ^3.7.0) | Cross-platform UI framework |
| **Riverpod** (`flutter_riverpod`) | State management with `StateNotifier` + `Provider` |
| **Google Fonts** | Poppins (headings) + Inter (body) typography |
| **flutter_local_notifications** | Scheduled medicine reminders |
| **timezone** | Timezone-aware notification scheduling |
| **shared_preferences** | Persistent local storage (profile/settings) |
| **intl** | Date/time formatting |
| **uuid** | Unique ID generation for models |
| **percent_indicator** | Circular/linear progress indicators |
| **lottie** | Animation support |
| **animations** | Material motion transitions |

---

## 🏗 Project Architecture

The app follows a **layered architecture** with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│                 UI Layer                │
│    Screens  ←→  Custom Widgets          │
├─────────────────────────────────────────┤
│            State Management             │
│   Riverpod StateNotifiers + Providers   │
├─────────────────────────────────────────┤
│             Data Layer                  │
│  In-Memory Repositories (with samples)  │
├─────────────────────────────────────────┤
│              Services                   │
│     NotificationService (singleton)     │
└─────────────────────────────────────────┘
```

**Data flow:** `Screen` reads/watches a `Provider` → `Provider` wraps a `StateNotifier` → `StateNotifier` calls `Repository` methods → state updates trigger UI rebuild.

---

## 📁 Directory Structure

```
lib/
├── main.dart                          # App entry, navigation flow, bottom nav shell
├── models/
│   └── models.dart                    # All data classes: UserProfile, Medicine, Appointment, etc.
├── providers/
│   └── providers.dart                 # Riverpod providers & StateNotifiers for all domains
├── repositories/
│   ├── medicines_repository.dart      # In-memory medicine CRUD + sample data
│   ├── appointments_repository.dart   # In-memory appointment CRUD + sample data
│   ├── profile_repository.dart        # User profile storage
│   └── checkin_repository.dart        # Daily mood check-in storage
├── services/
│   └── notification_service.dart      # Local notification scheduling (singleton)
├── screens/
│   ├── splash_screen.dart             # Animated gradient splash with pulsing logo
│   ├── onboarding_screen.dart         # 4-step user info collection
│   ├── home_screen.dart               # Main dashboard: progress, water, vitals, mood, tips
│   ├── medicines_screen.dart          # Medicine list with search, filters, accent cards
│   ├── add_medicine_screen.dart       # Add/edit medicine form
│   ├── appointments_screen.dart       # Upcoming/past appointment management
│   ├── symptom_checker_screen.dart    # Symptom → medicine suggestion checker
│   └── profile_screen.dart            # User profile with BMI, conditions, emergency info
├── theme/
│   └── app_theme.dart                 # Complete design system: colors, gradients, typography, helpers
└── widgets/
    ├── glass_card.dart                # Reusable glassmorphic card (BackdropFilter)
    ├── nebula_background.dart         # Animated floating orb background
    ├── gradient_button.dart           # Gradient CTA button with glow
    └── accent_bar.dart                # Vertical colored accent bar for list items
```

---

## 🎨 Design System

Defined in `lib/theme/app_theme.dart`:

### Color Palette

| Token | Hex | Usage |
|---|---|---|
| `bgPrimary` | `#181A20` | Main scaffold background (Charcoal Black) |
| `bgSecondary` | `#23243A` | Card backgrounds, dropdown menus (Deep Slate) |
| `electricBlue` | `#00B4FF` | Primary accent — nav highlights, links, default accent |
| `neonGreen` | `#00FFB0` | Success states, health conditions, streaks |
| `vividOrange` | `#FF8C42` | Warnings, allergies, blood pressure vital |
| `radiantPink` | `#FF4F8B` | Heart rate, blood group, emergency, CTA gradient end |
| `textPrimary` | `#FFFFFF` | Headings and emphasis |
| `textSecondary` | `#B0B3C6` | Body text, hints, secondary info |
| `glassWhite` | `0x14FFFFFF` | Glassmorphic card fill (8% white) |
| `glassBorder` | `0x30FFFFFF` | Glassmorphic card border (19% white) |

### Gradients

| Gradient | Colors | Usage |
|---|---|---|
| `accentGradient` | Blue → Pink | Primary CTA buttons, nav highlights, FABs |
| `greenBlueGradient` | Green → Blue | Streak badges, tip icons |
| `orangePinkGradient` | Orange → Pink | Time badges, secondary CTAs |
| `scaffoldGradient` | bgPrimary → bgSecondary | Base background gradient |

### Glassmorphism Recipe

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(18),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
    child: Container(
      decoration: BoxDecoration(
        color: AppTheme.glassWhite,       // 8% white
        border: Border.all(color: AppTheme.glassBorder),  // 19% white
        borderRadius: BorderRadius.circular(18),
      ),
      child: /* content */,
    ),
  ),
)
```

### Typography

- **Headings**: Poppins (bold, white) via `GoogleFonts.poppinsTextTheme`
- **Body**: Inter (regular, light gray) via `GoogleFonts.inter`

### Helper Methods

| Method | Returns |
|---|---|
| `AppTheme.glassCard()` | `BoxDecoration` for glass containers |
| `AppTheme.glow(color, blur, spread)` | `List<BoxShadow>` for neon glow effects |
| `AppTheme.fabGlow` | Pre-built FAB shadow list |

---

## 📱 Screen Breakdown

### 1. Splash Screen (`splash_screen.dart`)
- 3 `AnimationController`s: rotating gradient (4s loop), pulsing glow ring (1.2s reverse), fade-in text (800ms delayed)
- Auto-navigates to onboarding or home after 3 seconds
- Health shield icon with gradient background + glowing `BoxShadow`

### 2. Onboarding Screen (`onboarding_screen.dart`)
- **4 steps**: Personal Info → Body & Emergency → Health Conditions → Allergies
- Per-step accent colors: `[electricBlue, neonGreen, vividOrange, radiantPink]`
- Neon progress bar with gradient segments and glow shadows
- `GlassCard` step headers with gradient icon containers
- Animated progress controller for smooth bar transitions
- Chips for health conditions and allergies with accent borders
- Saves `UserProfile` to repository on completion

### 3. Home Screen (`home_screen.dart`)
The main dashboard with multiple glassmorphic sections:

| Section | Details |
|---|---|
| **Greeting** | Gradient avatar with glow, time-based greeting, notification button |
| **Streak Badge** | `greenBlueGradient` fire icon showing adherence streak days |
| **Progress Card** | Overall medicine completion with `accentGradient` badge |
| **Water Tracker** | Glass progress bar with +/- buttons, gradient water icon |
| **Health Tip** | Random rotating tip from built-in tip list |
| **Vitals Cards** | 3 `BackdropFilter` glass cards for Heart Rate, Blood Pressure, Blood Sugar |
| **Next Dose** | `orangePinkGradient` time badge, medicine name, gradient action button |
| **Next Appointment** | Upcoming appointment preview with accent icon |
| **Mood Check-In** | 5 emoji buttons with per-mood accent colors + glow on selection |

### 4. Medicines Screen (`medicines_screen.dart`)
- Search bar with clear button
- 4 filter chips: All / Active / Completed / Today — each with rotating accent color
- Medicine cards: `BackdropFilter` glass with vertical accent bar gradient on left edge
- Per-card: form icon, name, dosage, popup menu (Edit/Mark All/Delete)
- Time chips: next untaken time gets gradient + glow, taken times get muted accent
- Status indicators: "Completed" green chip or "Reminders ON" accent chip
- Gradient FAB to add new medicine

### 5. Add Medicine Screen (`add_medicine_screen.dart`)
- `NebulaBackground` wrapper
- Section labels with colored accent bars (Name=blue, Dosage=green, Form=orange, Frequency=pink)
- Glass `BackdropFilter` dropdown containers for Form and Frequency
- Gradient "Add" button for reminder times
- Time chips with rotating accent colors and glow
- `GlassCard` toggle for "Take with food?" with neon green switch
- Gradient save button with glow

### 6. Appointments Screen (`appointments_screen.dart`)
- Glass `BackdropFilter` segmented control (Upcoming/Past) with gradient active state
- Specialty-aware accent colors: Cardio=pink, Dental=green, Eye/Opto=orange, Default=blue
- Appointment cards: glass with accent bar, specialty icon, status chip, date/location
- Reschedule button with accent gradients, detail view dialog
- Gradient "Add Appointment" button at bottom
- Bottom sheet form for adding new appointments with date/time pickers

### 7. Symptom Checker Screen (`symptom_checker_screen.dart`)
- `NebulaBackground` wrapper with `GlassCard` disclaimer banner
- 8 symptom categories: Fever, Headache, Cough, Sore Throat, Stomach Ache, Nausea, Allergies, Body Ache
- Symptom chips with per-symptom icons and cycling accent colors; selected chips glow
- Medicine suggestion cards: `BackdropFilter` glass with accent bars and medication icons
- Built-in `kSymptomToMedicineMap` mapping symptoms to common OTC medicines

### 8. Profile Screen (`profile_screen.dart`)
- Gradient-bordered circular avatar with electricBlue glow
- Blood group chip with radiantPink accent
- **BMI Card**: Glass `BackdropFilter` with color-coded gradient badge (blue/green/orange/pink by BMI range)
- Health condition chips (neonGreen), allergy chips (vividOrange)
- Emergency contact `GlassCard` with radiantPink accent
- Editable fields with section-colored labels: Personal Info (blue), Blood Group (pink), Body Metrics (green), Contact (orange), Emergency (pink)
- Glass dropdown for Gender selection
- Gradient save button

---

## 📦 Data Models

Defined in `lib/models/models.dart`:

### `UserProfile`
```
Fields: id, name, age, gender, phone, email, bloodGroup,
        emergencyContactName, emergencyContactPhone,
        healthConditions[], allergies[], height, weight,
        onboardingComplete
Computed: bmi (double?), bmiCategory (String)
```

### `Medicine`
```
Fields: id, name, dosage, form, reminderTimes[], frequency,
        withFood, notes, isCompleted, isReminderOn, takenTimes[]
Computed: takenCount, totalDoses
```

### `Appointment`
```
Fields: id, doctorName, specialty, dateTime, location, status, notes
Computed: isUpcoming, isPast
```

### `DailyCheckIn`
```
Fields: id, date, mood (int 1-5), note
```

### `WaterIntake`
```
Fields: date, glassCount, goal
Computed: percentage (0.0 - 1.0)
```

### `VitalRecord`
```
Fields: id, type, value, value2 (for BP diastolic), recordedAt, unit
```

### `HealthTip`
```
Fields: title, body, icon (emoji)
```

Also includes predefined lists:
- `kHealthConditions` — 16 common conditions (Diabetes, Hypertension, Asthma, etc.)
- `kAllergies` — 16 common allergies (Penicillin, Peanuts, Latex, etc.)
- `kBloodGroups` — 8 blood types (A+, A−, B+, B−, AB+, AB−, O+, O−)
- `kHealthTips` — 10 rotating health tips

---

## 🔄 State Management

**Riverpod** with `StateNotifier` pattern:

| Provider | Type | Manages |
|---|---|---|
| `medicinesProvider` | `StateNotifierProvider<MedicinesNotifier, List<Medicine>>` | All medicines, CRUD, notifications |
| `appointmentsProvider` | `StateNotifierProvider<AppointmentsNotifier, List<Appointment>>` | Appointments, upcoming/past filtering |
| `profileProvider` | `StateNotifierProvider<ProfileNotifier, UserProfile>` | User profile, onboarding state |
| `checkInProvider` | `StateNotifierProvider<CheckInNotifier, DailyCheckIn?>` | Daily mood check-in |
| `waterIntakeProvider` | `StateNotifierProvider<WaterIntakeNotifier, WaterIntake>` | Water glass tracking |

### Supporting Providers (singletons)
- `medicinesRepoProvider` — `MedicinesRepository` instance
- `appointmentsRepoProvider` — `AppointmentsRepository` instance
- `profileRepoProvider` — `ProfileRepository` instance
- `checkInRepoProvider` — `CheckInRepository` instance

---

## 🗄 Repositories

All repositories are **in-memory** with pre-loaded sample data for demonstration:

| Repository | Sample Data |
|---|---|
| `MedicinesRepository` | 5 medicines (Amoxicillin, Vitamin D3, Cough Syrup, Metformin, Insulin) |
| `AppointmentsRepository` | 5 appointments across various specialties |
| `ProfileRepository` | Default user "Krish" with conditions and allergies |
| `CheckInRepository` | Daily mood storage |

Each repository provides standard CRUD operations (`getAll`, `getById`, `add`, `update`, `delete`) plus domain-specific queries.

---

## 🔔 Services

### NotificationService (`notification_service.dart`)
- **Singleton** pattern via factory constructor
- Uses `flutter_local_notifications` + `timezone` for scheduled reminders
- Initializes with Android (`@mipmap/ic_launcher`) and iOS settings
- Methods:
  - `init()` — Initialize notification channels and timezone data
  - `requestPermissions()` — Request iOS/Android notification permissions
  - `scheduleMedicineNotification(medicine, userName, timeString)` — Schedule a daily recurring notification for a medicine dose time
  - `cancelMedicineNotifications(medicine)` — Cancel all notifications for a medicine

---

## 🧩 Custom Widgets

### `GlassCard` (`widgets/glass_card.dart`)
Reusable glassmorphic container with `BackdropFilter`:
- `sigmaX: 18, sigmaY: 18` blur
- `AppTheme.glassWhite` fill, `AppTheme.glassBorder` border
- Configurable: `child`, `margin`, `padding`, `borderRadius`, `borderColor`

### `NebulaBackground` (`widgets/nebula_background.dart`)
Animated gradient background with 3 floating orbs:
- `SingleTickerProviderStateMixin` with 12-second `AnimationController`
- Orbs drift using `math.sin/cos` trigonometric functions
- Colors: Electric Blue, Radiant Pink, Neon Green
- Base: `AppTheme.scaffoldGradient`

### `GradientButton` (`widgets/gradient_button.dart`)
Primary CTA button:
- `AppTheme.accentGradient` (blue → pink)
- Glow shadow on tap via `GestureDetector` + `AnimatedContainer`
- Configurable: `label`, `onTap`, `icon`

### `AccentBar` (`widgets/accent_bar.dart`)
Vertical colored bar for list item decoration:
- Configurable `color`, `height`, `width`
- Matching glow shadow

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.7.0
- Dart SDK ^3.7.0
- Chrome (for web), Android Studio / Xcode (for mobile)

### Installation

```bash
# Clone the repository
git clone https://github.com/krrish021-ops/MEDITOUCH.git
cd MEDITOUCH

# Install dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios

# Run analysis (should show 0 issues)
flutter analyze
```

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

## 📄 License

This project is for educational and personal use.

---

> Built with 💙 using Flutter — **MEDITOUCH: Your Digital Health Guardian**
