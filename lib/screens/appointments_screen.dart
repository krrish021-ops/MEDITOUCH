/// Appointments screen matching design screenshot 3.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});
  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen> {
  bool _showUpcoming = true;
  String _search = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(appointmentsProvider.notifier);
    ref.watch(appointmentsProvider); // rebuild on changes
    final upcoming =
        notifier.upcoming
            .where(
              (a) =>
                  _search.isEmpty ||
                  a.doctorName.toLowerCase().contains(_search.toLowerCase()),
            )
            .toList();
    final past =
        notifier.past
            .where(
              (a) =>
                  _search.isEmpty ||
                  a.doctorName.toLowerCase().contains(_search.toLowerCase()),
            )
            .toList();

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        title: const Text(
          'Care Points',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Search Care Points'),
                      content: TextField(
                        controller: _searchCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Doctor name...',
                        ),
                        onChanged: (v) => setState(() => _search = v),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _search = '');
                            Navigator.pop(context);
                          },
                          child: const Text('Clear'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Options'),
                      content: const Text('More options coming soon!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Segmented control
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _showUpcoming = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              _showUpcoming
                                  ? AppTheme.teal
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Upcoming',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _showUpcoming ? Colors.white : AppTheme.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _showUpcoming = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              !_showUpcoming
                                  ? AppTheme.teal
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Past',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                !_showUpcoming ? Colors.white : AppTheme.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  _showUpcoming ? 'UPCOMING CARE POINTS' : 'PAST HISTORY',
                  style: const TextStyle(
                    color: AppTheme.teal,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_showUpcoming ? upcoming.length : past.length} Total',
                  style: const TextStyle(color: AppTheme.teal, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // List
          Expanded(
            child:
                _showUpcoming
                    ? (upcoming.isEmpty
                        ? const Center(
                          child: Text(
                            'No care points scheduled. Breathe easy.',
                            style: TextStyle(color: AppTheme.grey),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: upcoming.length,
                          itemBuilder: (_, i) => _buildCard(upcoming[i], false),
                        ))
                    : (past.isEmpty
                        ? const Center(
                          child: Text(
                            'No past care points',
                            style: TextStyle(color: AppTheme.grey),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: past.length,
                          itemBuilder: (_, i) => _buildCard(past[i], true),
                        )),
          ),
          // Schedule appointment button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showAddForm(context),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Log Care Point'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Appointment appt, bool isPast) {
    final dateStr = DateFormat('MMM d, yyyy').format(appt.dateTime);
    final timeStr = DateFormat('h:mm a').format(appt.dateTime);
    // Specialty icon
    IconData icon = Icons.medical_services;
    if (appt.specialty.toLowerCase().contains('dent')) {
      icon = Icons.health_and_safety;
    }
    if (appt.specialty.toLowerCase().contains('cardio')) icon = Icons.favorite;
    if (appt.specialty.toLowerCase().contains('eye') ||
        appt.specialty.toLowerCase().contains('opto')) {
      icon = Icons.visibility;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.teal.withValues(alpha: isPast ? 0.08 : 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.teal.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.teal, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appt.doctorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: isPast ? AppTheme.grey : Colors.white,
                      ),
                    ),
                    Text(
                      appt.specialty,
                      style: const TextStyle(
                        color: AppTheme.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      isPast
                          ? AppTheme.grey.withValues(alpha: 0.15)
                          : AppTheme.teal.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        isPast
                            ? AppTheme.grey.withValues(alpha: 0.3)
                            : AppTheme.teal.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  appt.status,
                  style: TextStyle(
                    color: isPast ? AppTheme.grey : AppTheme.teal,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: AppTheme.grey, size: 16),
              const SizedBox(width: 6),
              Text(
                '$dateStr at $timeStr',
                style: const TextStyle(color: AppTheme.greyLight, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, color: AppTheme.grey, size: 16),
              const SizedBox(width: 6),
              Text(
                appt.location,
                style: const TextStyle(color: AppTheme.greyLight, fontSize: 14),
              ),
            ],
          ),
          if (!isPast) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _reschedule(appt),
                    icon: const Icon(Icons.calendar_month, size: 18),
                    label: const Text('Reschedule'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.chipBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: AppTheme.teal),
                    onPressed: () => _showDetails(appt),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _reschedule(Appointment appt) async {
    final date = await showDatePicker(
      context: context,
      initialDate: appt.dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(appt.dateTime),
    );
    if (time == null || !mounted) return;
    final newDt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    ref
        .read(appointmentsProvider.notifier)
        .update(appt.copyWith(dateTime: newDt));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Care point rescheduled.'),
          backgroundColor: AppTheme.teal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showDetails(Appointment appt) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(appt.doctorName),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Specialty: ${appt.specialty}'),
                Text(
                  'Date: ${DateFormat('MMM d, yyyy h:mm a').format(appt.dateTime)}',
                ),
                Text('Location: ${appt.location}'),
                Text('Status: ${appt.status}'),
                if (appt.notes != null) Text('Notes: ${appt.notes}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showAddForm(BuildContext context) {
    final docCtrl = TextEditingController();
    final specCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setBS) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Log Care Point',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: docCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Doctor Name',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: specCtrl,
                      decoration: const InputDecoration(hintText: 'Specialty'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final d = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (d != null) setBS(() => selectedDate = d);
                            },
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: Text(
                              DateFormat('MMM d, yyyy').format(selectedDate),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.teal,
                              side: const BorderSide(color: AppTheme.teal),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final t = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );
                              if (t != null) setBS(() => selectedTime = t);
                            },
                            icon: const Icon(Icons.access_time, size: 16),
                            label: Text(selectedTime.format(context)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.teal,
                              side: const BorderSide(color: AppTheme.teal),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: locCtrl,
                      decoration: const InputDecoration(hintText: 'Location'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: notesCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Notes (optional)',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (docCtrl.text.trim().isEmpty ||
                              specCtrl.text.trim().isEmpty) {
                            return;
                          }
                          ref
                              .read(appointmentsProvider.notifier)
                              .add(
                                Appointment(
                                  doctorName: docCtrl.text.trim(),
                                  specialty: specCtrl.text.trim(),
                                  dateTime: DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedTime.hour,
                                    selectedTime.minute,
                                  ),
                                  location:
                                      locCtrl.text.trim().isNotEmpty
                                          ? locCtrl.text.trim()
                                          : 'TBD',
                                  notes:
                                      notesCtrl.text.trim().isNotEmpty
                                          ? notesCtrl.text.trim()
                                          : null,
                                ),
                              );
                          Navigator.pop(context);
                        },
                        child: const Text('Secure Protocol'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
