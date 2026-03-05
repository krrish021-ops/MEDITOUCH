/// In-memory repository for daily check-ins.
library;
import '../models/models.dart';

class CheckInRepository {
  final List<DailyCheckIn> _checkIns = [];

  List<DailyCheckIn> getAll() => List.unmodifiable(_checkIns);

  /// Get today's check-in, if any.
  DailyCheckIn? getToday() {
    final now = DateTime.now();
    try {
      return _checkIns.firstWhere(
        (c) =>
            c.date.year == now.year &&
            c.date.month == now.month &&
            c.date.day == now.day,
      );
    } catch (_) {
      return null;
    }
  }

  /// Save or update today's mood.
  void saveMood(int mood, {String? note}) {
    final today = getToday();
    if (today != null) {
      today.mood = mood;
      today.note = note;
    } else {
      _checkIns.add(DailyCheckIn(date: DateTime.now(), mood: mood, note: note));
    }
  }
}
