// Data models for the Smart Health Reminder app.

import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Represents a user profile with personal and health information.
class UserProfile {
  final String id;
  String name;
  int? age;
  String? gender;
  String? phone;
  String? email;
  String? bloodGroup;
  String? emergencyContactName;
  String? emergencyContactPhone;
  List<String> healthConditions; // e.g. ["Diabetes", "Hypertension"]
  List<String> allergies; // e.g. ["Penicillin", "Peanuts"]
  double? height; // in cm
  double? weight; // in kg
  bool onboardingComplete;

  UserProfile({
    String? id,
    required this.name,
    this.age,
    this.gender,
    this.phone,
    this.email,
    this.bloodGroup,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.healthConditions = const [],
    this.allergies = const [],
    this.height,
    this.weight,
    this.onboardingComplete = false,
  }) : id = id ?? _uuid.v4();

  UserProfile copyWith({
    String? name,
    int? age,
    String? gender,
    String? phone,
    String? email,
    String? bloodGroup,
    String? emergencyContactName,
    String? emergencyContactPhone,
    List<String>? healthConditions,
    List<String>? allergies,
    double? height,
    double? weight,
    bool? onboardingComplete,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      healthConditions: healthConditions ?? this.healthConditions,
      allergies: allergies ?? this.allergies,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  /// BMI calculation
  double? get bmi {
    if (height != null && weight != null && height! > 0) {
      final h = height! / 100;
      return weight! / (h * h);
    }
    return null;
  }

  String get bmiCategory {
    final b = bmi;
    if (b == null) return 'N/A';
    if (b < 18.5) return 'Underweight';
    if (b < 25) return 'Normal';
    if (b < 30) return 'Overweight';
    return 'Obese';
  }
}

/// Represents a medicine with dosage, schedule, and reminder settings.
class Medicine {
  final String id;
  String name;
  String dosage;
  String form;
  List<String> reminderTimes;
  String frequency;
  bool withFood;
  String? notes;
  bool isCompleted;
  bool isReminderOn;
  List<String> takenTimes;

  Medicine({
    String? id,
    required this.name,
    required this.dosage,
    this.form = 'Tablet',
    this.reminderTimes = const [],
    this.frequency = 'Once a day',
    this.withFood = false,
    this.notes,
    this.isCompleted = false,
    this.isReminderOn = true,
    this.takenTimes = const [],
  }) : id = id ?? _uuid.v4();

  Medicine copyWith({
    String? name,
    String? dosage,
    String? form,
    List<String>? reminderTimes,
    String? frequency,
    bool? withFood,
    String? notes,
    bool? isCompleted,
    bool? isReminderOn,
    List<String>? takenTimes,
  }) {
    return Medicine(
      id: id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      form: form ?? this.form,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      frequency: frequency ?? this.frequency,
      withFood: withFood ?? this.withFood,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      isReminderOn: isReminderOn ?? this.isReminderOn,
      takenTimes: takenTimes ?? this.takenTimes,
    );
  }

  int get takenCount => takenTimes.length;
  int get totalDoses => reminderTimes.length;
}

/// Represents a medical appointment.
class Appointment {
  final String id;
  String doctorName;
  String specialty;
  DateTime dateTime;
  String location;
  String status;
  String? notes;

  Appointment({
    String? id,
    required this.doctorName,
    required this.specialty,
    required this.dateTime,
    required this.location,
    this.status = 'CONFIRMED',
    this.notes,
  }) : id = id ?? _uuid.v4();

  Appointment copyWith({
    String? doctorName,
    String? specialty,
    DateTime? dateTime,
    String? location,
    String? status,
    String? notes,
  }) {
    return Appointment(
      id: id,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  bool get isUpcoming => dateTime.isAfter(DateTime.now());
  bool get isPast => !isUpcoming;
}

/// Represents a daily mood check-in.
class DailyCheckIn {
  final String id;
  final DateTime date;
  int mood;
  String? note;

  DailyCheckIn({String? id, required this.date, required this.mood, this.note})
    : id = id ?? _uuid.v4();
}

/// Tracks water intake for the day.
class WaterIntake {
  final DateTime date;
  int glassCount;
  int goal;

  WaterIntake({required this.date, this.glassCount = 0, this.goal = 8});

  double get percentage => (glassCount / goal).clamp(0.0, 1.0);
}

/// Tracks a health vital recording.
class VitalRecord {
  final String id;
  final String type; // bp, heartRate, weight, bloodSugar
  final double value;
  final double? value2; // for BP: diastolic
  final DateTime recordedAt;
  final String? unit;

  VitalRecord({
    String? id,
    required this.type,
    required this.value,
    this.value2,
    required this.recordedAt,
    this.unit,
  }) : id = id ?? _uuid.v4();
}

/// A health tip shown on the home screen.
class HealthTip {
  final String title;
  final String body;
  final String icon; // emoji

  const HealthTip({
    required this.title,
    required this.body,
    required this.icon,
  });
}

/// Predefined list of common health conditions.
const kCommonConditions = [
  'Diabetes Type 1',
  'Diabetes Type 2',
  'Hypertension',
  'Asthma',
  'Heart Disease',
  'Arthritis',
  'Thyroid Disorder',
  'High Cholesterol',
  'COPD',
  'Kidney Disease',
  'Liver Disease',
  'Anemia',
  'Depression',
  'Anxiety',
  'Epilepsy',
  'Migraine',
  'Cancer',
  'HIV/AIDS',
  'Tuberculosis',
  'Allergic Rhinitis',
];

/// Predefined common allergies.
const kCommonAllergies = [
  'Penicillin',
  'Aspirin',
  'Ibuprofen',
  'Sulfa Drugs',
  'Peanuts',
  'Tree Nuts',
  'Shellfish',
  'Eggs',
  'Milk',
  'Latex',
  'Bee Stings',
  'Dust Mites',
  'Pollen',
  'Mold',
  'Pet Dander',
];

/// Blood group options.
const kBloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

/// Daily health tips rotation.
const kHealthTips = [
  HealthTip(
    title: 'Stay Hydrated',
    body:
        'Drink at least 8 glasses of water daily to keep your body functioning optimally.',
    icon: '💧',
  ),
  HealthTip(
    title: 'Move Your Body',
    body:
        '30 minutes of moderate exercise daily reduces risk of chronic disease by 50%.',
    icon: '🏃',
  ),
  HealthTip(
    title: 'Sleep Well',
    body: 'Aim for 7-9 hours of quality sleep each night for optimal recovery.',
    icon: '😴',
  ),
  HealthTip(
    title: 'Eat Colorfully',
    body:
        'Include fruits and vegetables of different colors for a wider range of nutrients.',
    icon: '🥗',
  ),
  HealthTip(
    title: 'Manage Stress',
    body: 'Practice deep breathing or meditation for 10 minutes daily.',
    icon: '🧘',
  ),
  HealthTip(
    title: 'Take Medicines on Time',
    body:
        'Consistent timing improves medication effectiveness and reduces side effects.',
    icon: '💊',
  ),
  HealthTip(
    title: 'Regular Check-ups',
    body:
        'Annual health screenings catch problems early when they are most treatable.',
    icon: '🏥',
  ),
];
