/// Firestore-backed repository for appointments.
library;

import '../models/models.dart';
import '../services/firestore_service.dart';

class AppointmentsRepository {
  final FirestoreService _firestore = FirestoreService();

  List<Appointment> _appointments = [];

  /// Load all appointments from Firestore into memory.
  Future<void> loadAll() async {
    final snapshot = await _firestore.appointmentsCollection.get();
    _appointments =
        snapshot.docs.map((doc) => Appointment.fromMap(doc.data())).toList();
  }

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

  Future<void> add(Appointment appointment) async {
    await _firestore.appointmentsCollection
        .doc(appointment.id)
        .set(appointment.toMap());
    _appointments.add(appointment);
  }

  Future<void> update(Appointment appointment) async {
    await _firestore.appointmentsCollection
        .doc(appointment.id)
        .update(appointment.toMap());
    final index = _appointments.indexWhere((a) => a.id == appointment.id);
    if (index != -1) _appointments[index] = appointment;
  }

  Future<void> delete(String id) async {
    await _firestore.appointmentsCollection.doc(id).delete();
    _appointments.removeWhere((a) => a.id == id);
  }
}
