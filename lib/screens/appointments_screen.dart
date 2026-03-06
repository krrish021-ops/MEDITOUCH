/// Appointments screen — glassmorphic cards, gradient segmented control,
/// accent-colored specialty icons, nebula background.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../widgets/nebula_background.dart';

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

  static const _specAccents = {
    'dent': AppTheme.neonGreen,
    'cardio': AppTheme.radiantPink,
    'heart': AppTheme.radiantPink,
    'eye': AppTheme.vividOrange,
    'opto': AppTheme.vividOrange,
  };

  Color _accentFor(String specialty) {
    final low = specialty.toLowerCase();
    for (final e in _specAccents.entries) {
      if (low.contains(e.key)) return e.value;
    }
    return AppTheme.electricBlue;
  }

  IconData _iconFor(String specialty) {
    final low = specialty.toLowerCase();
    if (low.contains('dent')) return Icons.health_and_safety_rounded;
    if (low.contains('cardio') || low.contains('heart')) {
      return Icons.favorite_rounded;
    }
    if (low.contains('eye') || low.contains('opto')) {
      return Icons.visibility_rounded;
    }
    return Icons.medical_services_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(appointmentsProvider.notifier);
    ref.watch(appointmentsProvider);
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

    return NebulaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Appointments'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text('Search Appointments'),
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
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Glassmorphic segmented control
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.glassWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.glassBorder),
                      ),
                      child: Row(
                        children: [
                          _segmentButton('Upcoming', true),
                          _segmentButton('Past', false),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Section header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppTheme.electricBlue,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: AppTheme.glow(
                          AppTheme.electricBlue,
                          blur: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _showUpcoming ? 'UPCOMING' : 'PAST HISTORY',
                      style: const TextStyle(
                        color: AppTheme.electricBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_showUpcoming ? upcoming.length : past.length} Total',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
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
                            ? _emptyState('No upcoming appointments')
                            : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                0,
                                20,
                                120,
                              ),
                              itemCount: upcoming.length,
                              itemBuilder:
                                  (_, i) => _buildCard(upcoming[i], false, i),
                            ))
                        : (past.isEmpty
                            ? _emptyState('No past appointments')
                            : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                0,
                                20,
                                120,
                              ),
                              itemCount: past.length,
                              itemBuilder:
                                  (_, i) => _buildCard(past[i], true, i),
                            )),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: AppTheme.accentGradient,
              boxShadow: AppTheme.glow(
                AppTheme.electricBlue,
                blur: 20,
                spread: 2,
              ),
            ),
            child: FloatingActionButton(
              tooltip: 'Add Appointment',
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () => _showAddForm(context),
              child: const Icon(
                Icons.add_rounded,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _segmentButton(String label, bool isUpcoming) {
    final selected = _showUpcoming == isUpcoming;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _showUpcoming = isUpcoming),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: selected ? AppTheme.accentGradient : null,
            borderRadius: BorderRadius.circular(14),
            boxShadow:
                selected
                    ? AppTheme.glow(AppTheme.electricBlue, blur: 10)
                    : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState(String msg) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 56,
            color: AppTheme.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(msg, style: const TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildCard(Appointment appt, bool isPast, int index) {
    final accent = _accentFor(appt.specialty);
    final icon = _iconFor(appt.specialty);
    final dateStr = DateFormat('MMM d, yyyy').format(appt.dateTime);
    final timeStr = DateFormat('h:mm a').format(appt.dateTime);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.glassWhite,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: accent.withValues(alpha: isPast ? 0.1 : 0.25),
              ),
            ),
            child: Row(
              children: [
                // Accent bar
                Container(
                  width: 4,
                  height: isPast ? 100 : 155,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [accent, accent.withValues(alpha: 0.3)],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                    boxShadow: AppTheme.glow(accent, blur: 8),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(icon, color: accent, size: 22),
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
                                      fontSize: 16,
                                      color:
                                          isPast
                                              ? AppTheme.textSecondary
                                              : Colors.white,
                                    ),
                                  ),
                                  Text(
                                    appt.specialty,
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Status chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: (isPast
                                        ? AppTheme.textSecondary
                                        : accent)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: (isPast
                                          ? AppTheme.textSecondary
                                          : accent)
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                appt.status,
                                style: TextStyle(
                                  color:
                                      isPast ? AppTheme.textSecondary : accent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Date & location
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              color: AppTheme.textSecondary,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$dateStr at $timeStr',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: AppTheme.textSecondary,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                appt.location,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        // Action buttons for upcoming
                        if (!isPast) ...[
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      colors: [
                                        accent,
                                        accent.withValues(alpha: 0.7),
                                      ],
                                    ),
                                    boxShadow: AppTheme.glow(accent, blur: 10),
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () => _reschedule(appt),
                                    icon: const Icon(
                                      Icons.calendar_month_rounded,
                                      size: 16,
                                    ),
                                    label: const Text('Reschedule'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.glassWhite,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppTheme.glassBorder,
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_rounded,
                                    color: accent,
                                  ),
                                  onPressed: () => _showDetails(appt),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          content: const Text('Appointment rescheduled'),
          backgroundColor: AppTheme.electricBlue,
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
                      'Add Appointment',
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
                              if (d != null) {
                                setBS(() => selectedDate = d);
                              }
                            },
                            icon: const Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                            ),
                            label: Text(
                              DateFormat('MMM d, yyyy').format(selectedDate),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.electricBlue,
                              side: const BorderSide(
                                color: AppTheme.electricBlue,
                              ),
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
                              if (t != null) {
                                setBS(() => selectedTime = t);
                              }
                            },
                            icon: const Icon(
                              Icons.access_time_rounded,
                              size: 16,
                            ),
                            label: Text(selectedTime.format(context)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.electricBlue,
                              side: const BorderSide(
                                color: AppTheme.electricBlue,
                              ),
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
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: AppTheme.accentGradient,
                        ),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Save Appointment'),
                        ),
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
