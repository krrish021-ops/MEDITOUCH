/// In-memory repository for appointments.
library;

import '../models/models.dart';

class AppointmentsRepository {
  final List<Appointment> _appointments = [
    Appointment(
      doctorName: 'Dr. Aris',
      specialty: 'Dentist Specialist',
      dateTime: DateTime.now().add(const Duration(days: 3, hours: 5)),
      location: 'City Dental Clinic',
      status: 'CONFIRMED',
    ),
    Appointment(
      doctorName: 'Dr. Sarah',
      specialty: 'General Physician',
      dateTime: DateTime.now().add(const Duration(days: 14, hours: 2)),
      location: 'Health Center North',
      status: 'IN 2 WEEKS',
    ),
    Appointment(
      doctorName: 'Dr. Smith',
      specialty: 'Cardiologist',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
      location: 'Heart Care Hospital',
      status: 'CONFIRMED',
    ),
    Appointment(
      doctorName: 'Dr. Miller',
      specialty: 'Optometry',
      dateTime: DateTime.now().subtract(const Duration(days: 30)),
      location: 'Vision Care Center',
      status: 'COMPLETED',
    ),
  ];

  List<Appointment> getAll() => List.unmodifiable(_appointments);

  List<Appointment> getUpcoming() =>
      _appointments.where((a) => a.isUpcoming).toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  List<Appointment> getPast() =>
      _appointments.where((a) => a.isPast).toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

  Appointment? getNextUpcoming() {
    final upcoming = getUpcoming();
    return upcoming.isEmpty ? null : upcoming.first;
  }

  Appointment? getById(String id) {
    try {
      return _appointments.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  void add(Appointment appointment) => _appointments.add(appointment);

  void update(Appointment appointment) {
    final index = _appointments.indexWhere((a) => a.id == appointment.id);
    if (index != -1) _appointments[index] = appointment;
  }

  void delete(String id) => _appointments.removeWhere((a) => a.id == id);
}
