// Riverpod providers for all repositories and state.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/medicines_repository.dart';
import '../repositories/appointments_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/checkin_repository.dart';

import '../services/notification_service.dart';

// --- Repositories (singletons) ---
final medicinesRepoProvider = Provider<MedicinesRepository>(
  (ref) => MedicinesRepository(),
);
final appointmentsRepoProvider = Provider<AppointmentsRepository>(
  (ref) => AppointmentsRepository(),
);
final profileRepoProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(),
);
final checkInRepoProvider = Provider<CheckInRepository>(
  (ref) => CheckInRepository(),
);

// --- Medicines ---
class MedicinesNotifier extends StateNotifier<List<Medicine>> {
  final MedicinesRepository _repo;
  final Ref _ref;
  final NotificationService _notificationService = NotificationService();

  MedicinesNotifier(this._repo, this._ref) : super(_repo.getAll());

  String get _userName {
    return _ref.read(profileProvider).name;
  }

  void refresh() => state = _repo.getAll();

  void add(Medicine m) {
    _repo.add(m);
    _scheduleNotifications(m);
    refresh();
  }

  void update(Medicine m) {
    _repo.update(m);
    _notificationService.cancelMedicineNotifications(m).then((_) {
      _scheduleNotifications(m);
    });
    refresh();
  }

  void delete(String id) {
    final medicine = _repo.getById(id);
    if (medicine != null) {
      _notificationService.cancelMedicineNotifications(medicine);
    }
    _repo.delete(id);
    refresh();
  }

  void _scheduleNotifications(Medicine m) {
    if (!m.isReminderOn) return;
    for (String timeString in m.reminderTimes) {
      _notificationService.scheduleMedicineNotification(
        medicine: m,
        userName: _userName,
        timeString: timeString,
      );
    }
  }

  void markTimeTaken(String id, String time) {
    _repo.markTimeTaken(id, time);
    refresh();
  }

  void markAllTaken(String id) {
    _repo.markAllTaken(id);
    refresh();
  }

  /// Adherence streak: consecutive days with all meds taken (simplified).
  int get adherenceStreak {
    // For now, return count of fully-completed meds as a proxy streak
    return state.where((m) => m.isCompleted).length;
  }
}

final medicinesProvider =
    StateNotifierProvider<MedicinesNotifier, List<Medicine>>((ref) {
      return MedicinesNotifier(ref.read(medicinesRepoProvider), ref);
    });

// --- Appointments ---
class AppointmentsNotifier extends StateNotifier<List<Appointment>> {
  final AppointmentsRepository _repo;
  AppointmentsNotifier(this._repo) : super(_repo.getAll());

  void refresh() => state = _repo.getAll();
  void add(Appointment a) {
    _repo.add(a);
    refresh();
  }

  void update(Appointment a) {
    _repo.update(a);
    refresh();
  }

  void delete(String id) {
    _repo.delete(id);
    refresh();
  }

  List<Appointment> get upcoming => _repo.getUpcoming();
  List<Appointment> get past => _repo.getPast();
  Appointment? get nextUpcoming => _repo.getNextUpcoming();
}

final appointmentsProvider =
    StateNotifierProvider<AppointmentsNotifier, List<Appointment>>((ref) {
      return AppointmentsNotifier(ref.read(appointmentsRepoProvider));
    });

// --- Profile ---
class ProfileNotifier extends StateNotifier<UserProfile> {
  final ProfileRepository _repo;
  ProfileNotifier(this._repo) : super(_repo.get());

  void updateProfile(UserProfile p) {
    _repo.update(p);
    state = _repo.get();
  }

  bool get isOnboardingComplete => _repo.isOnboardingComplete;
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((
  ref,
) {
  return ProfileNotifier(ref.read(profileRepoProvider));
});

// --- Check-in ---
class CheckInNotifier extends StateNotifier<DailyCheckIn?> {
  final CheckInRepository _repo;
  CheckInNotifier(this._repo) : super(_repo.getToday());

  void saveMood(int mood, {String? note}) {
    _repo.saveMood(mood, note: note);
    state = _repo.getToday();
  }
}

final checkInProvider = StateNotifierProvider<CheckInNotifier, DailyCheckIn?>((
  ref,
) {
  return CheckInNotifier(ref.read(checkInRepoProvider));
});

// --- Water Intake ---
class WaterIntakeNotifier extends StateNotifier<WaterIntake> {
  WaterIntakeNotifier()
    : super(WaterIntake(date: DateTime.now(), glassCount: 0, goal: 8));

  void addGlass() {
    if (state.glassCount < state.goal) {
      state = WaterIntake(
        date: state.date,
        glassCount: state.glassCount + 1,
        goal: state.goal,
      );
    }
  }

  void removeGlass() {
    if (state.glassCount > 0) {
      state = WaterIntake(
        date: state.date,
        glassCount: state.glassCount - 1,
        goal: state.goal,
      );
    }
  }

  void setGoal(int goal) {
    state = WaterIntake(
      date: state.date,
      glassCount: state.glassCount,
      goal: goal,
    );
  }
}

final waterIntakeProvider =
    StateNotifierProvider<WaterIntakeNotifier, WaterIntake>((ref) {
      return WaterIntakeNotifier();
    });

// --- Vitals ---
class VitalsNotifier extends StateNotifier<List<VitalRecord>> {
  VitalsNotifier()
    : super([
        // Sample data
        VitalRecord(
          type: 'heartRate',
          value: 72,
          recordedAt: DateTime.now().subtract(const Duration(hours: 2)),
          unit: 'bpm',
        ),
        VitalRecord(
          type: 'bp',
          value: 120,
          value2: 80,
          recordedAt: DateTime.now().subtract(const Duration(hours: 3)),
          unit: 'mmHg',
        ),
        VitalRecord(
          type: 'bloodSugar',
          value: 95,
          recordedAt: DateTime.now().subtract(const Duration(hours: 5)),
          unit: 'mg/dL',
        ),
      ]);

  void add(VitalRecord r) {
    state = [...state, r];
  }

  List<VitalRecord> getByType(String type) =>
      state.where((r) => r.type == type).toList()
        ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

  VitalRecord? latestOfType(String type) {
    final list = getByType(type);
    return list.isEmpty ? null : list.first;
  }
}

final vitalsProvider = StateNotifierProvider<VitalsNotifier, List<VitalRecord>>(
  (ref) {
    return VitalsNotifier();
  },
);

/// Current bottom nav tab index.
final currentTabProvider = StateProvider<int>((ref) => 0);
