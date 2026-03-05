// Smart Health Reminder app entry point.
// Splash → Onboarding (if first time) → Main app with bottom navigation.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'providers/providers.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/medicines_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/profile_screen.dart';

import 'screens/symptom_checker_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const ProviderScope(child: SmartHealthApp()));
}

class SmartHealthApp extends StatelessWidget {
  const SmartHealthApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEDITOUCH',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppEntry(),
    );
  }
}

/// Controls the app flow: splash → onboarding → main.
class AppEntry extends ConsumerStatefulWidget {
  const AppEntry({super.key});
  @override
  ConsumerState<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends ConsumerState<AppEntry> {
  // 0 = splash, 1 = onboarding, 2 = main
  int _stage = 0;

  void _onSplashDone() {
    final profile = ref.read(profileProvider);
    setState(() {
      _stage = profile.onboardingComplete ? 2 : 1;
    });
  }

  void _onOnboardingDone() {
    setState(() => _stage = 2);
  }

  @override
  Widget build(BuildContext context) {
    switch (_stage) {
      case 0:
        return SplashScreen(onFinished: _onSplashDone);
      case 1:
        return OnboardingScreen(onComplete: _onOnboardingDone);
      default:
        return const AppShell();
    }
  }
}

/// Main navigation shell with BottomNavigationBar and 4 tabs.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  static const _screens = [
    HomeScreen(),
    MedicinesScreen(),
    SymptomCheckerScreen(),
    AppointmentsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);
    return Scaffold(
      body: IndexedStack(index: currentTab, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (i) => ref.read(currentTabProvider.notifier).state = i,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Command'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Regimen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            label: 'Diagnose',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Care Points',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Identity'),
        ],
      ),
    );
  }
}

