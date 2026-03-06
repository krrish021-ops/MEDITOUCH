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
  int _stage = 0; // 0 = splash, 1 = onboarding, 2 = main

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

/// Main navigation shell with glassmorphic BottomNavigationBar.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  static const _screens = [
    HomeScreen(),
    MedicinesScreen(),
    SymptomCheckerScreen(),
    AppointmentsScreen(),
    ProfileScreen(),
  ];

  static const _navItems = [
    _NavItem(Icons.home_rounded, Icons.home_outlined, 'Home'),
    _NavItem(Icons.medication_rounded, Icons.medication_outlined, 'Medicines'),
    _NavItem(Icons.favorite_rounded, Icons.favorite_outline, 'Diagnose'),
    _NavItem(
      Icons.calendar_month_rounded,
      Icons.calendar_month_outlined,
      'Appts',
    ),
    _NavItem(Icons.person_rounded, Icons.person_outline, 'Profile'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentTab, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(
            0xE6181A20,
          ), // 90% bgPrimary — opaque enough without blur
          border: Border(
            top: BorderSide(color: AppTheme.glassBorder, width: 0.5),
          ),
        ),
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              final selected = currentTab == i;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => ref.read(currentTabProvider.notifier).state = i,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        selected
                            ? AppTheme.electricBlue.withValues(alpha: 0.15)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected ? item.activeIcon : item.icon,
                        color:
                            selected
                                ? AppTheme.electricBlue
                                : AppTheme.textSecondary,
                        size: 24,
                        shadows:
                            selected
                                ? [
                                  Shadow(
                                    color: AppTheme.electricBlue.withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius: 12,
                                  ),
                                ]
                                : null,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w400,
                          color:
                              selected
                                  ? AppTheme.electricBlue
                                  : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  const _NavItem(this.activeIcon, this.icon, this.label);
}
