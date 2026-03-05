/// In-memory repository for medicines.
library;
import '../models/models.dart';

class MedicinesRepository {
  final List<Medicine> _medicines = [
    // Sample data
    Medicine(
      name: 'Amoxicillin',
      dosage: '500mg',
      form: 'Capsule',
      reminderTimes: ['8:00 AM', '2:00 PM', '8:00 PM'],
      frequency: 'Three times a day',
      withFood: true,
      isReminderOn: true,
      takenTimes: [],
    ),
    Medicine(
      name: 'Vitamin D3',
      dosage: '1000 IU',
      form: 'Tablet',
      reminderTimes: ['9:00 AM'],
      frequency: 'Once a day',
      withFood: false,
      isReminderOn: true,
      isCompleted: true,
      takenTimes: ['9:00 AM'],
    ),
    Medicine(
      name: 'Cough Syrup',
      dosage: '10ml',
      form: 'Syrup',
      reminderTimes: ['6:00 AM', '12:00 PM', '6:00 PM', '12:00 AM'],
      frequency: 'Every 6 hours',
      withFood: false,
      isReminderOn: true,
      takenTimes: [],
    ),
    Medicine(
      name: 'Metformin',
      dosage: '500mg',
      form: 'Tablet',
      reminderTimes: ['8:00 AM', '8:00 PM'],
      frequency: 'Twice a day',
      withFood: true,
      notes: 'After Breakfast',
      isReminderOn: true,
      takenTimes: [],
    ),
    Medicine(
      name: 'Lisinopril',
      dosage: '10mg',
      form: 'Tablet',
      reminderTimes: ['9:00 AM'],
      frequency: 'Once a day',
      withFood: false,
      isReminderOn: true,
      takenTimes: ['9:00 AM'],
    ),
  ];

  List<Medicine> getAll() => List.unmodifiable(_medicines);

  void add(Medicine medicine) => _medicines.add(medicine);

  void update(Medicine medicine) {
    final index = _medicines.indexWhere((m) => m.id == medicine.id);
    if (index != -1) _medicines[index] = medicine;
  }

  void delete(String id) => _medicines.removeWhere((m) => m.id == id);

  Medicine? getById(String id) {
    try {
      return _medicines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Mark a specific dose time as taken for a medicine.
  void markTimeTaken(String medicineId, String time) {
    final med = getById(medicineId);
    if (med != null && !med.takenTimes.contains(time)) {
      med.takenTimes = [...med.takenTimes, time];
      if (med.takenTimes.length >= med.reminderTimes.length) {
        med.isCompleted = true;
      }
    }
  }

  /// Mark all doses as taken.
  void markAllTaken(String medicineId) {
    final med = getById(medicineId);
    if (med != null) {
      med.takenTimes = List.from(med.reminderTimes);
      med.isCompleted = true;
    }
  }
}
