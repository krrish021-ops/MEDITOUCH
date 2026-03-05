// Home dashboard screen with greeting, progress, next dose, water tracker,
// vitals summary, appointment preview, health tips, and mood check-in.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../theme/app_theme.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../services/notification_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Request permissions after widget is bound
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService().requestPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final medicines = ref.watch(medicinesProvider);
    final appointmentsNotifier = ref.read(appointmentsProvider.notifier);
    final checkIn = ref.watch(checkInProvider);
    final water = ref.watch(waterIntakeProvider);
    final vitals = ref.watch(vitalsProvider);
    final streak = ref.read(medicinesProvider.notifier).adherenceStreak;

    // Calculate progress
    final totalDoses = medicines.fold<int>(0, (s, m) => s + m.totalDoses);
    final takenDoses = medicines.fold<int>(0, (s, m) => s + m.takenCount);
    final progress = totalDoses > 0 ? takenDoses / totalDoses : 0.0;

    // Next upcoming medicine
    Medicine? nextMed;
    String? nextTime;
    for (final med in medicines) {
      for (final t in med.reminderTimes) {
        if (!med.takenTimes.contains(t)) {
          nextMed = med;
          nextTime = t;
          break;
        }
      }
      if (nextMed != null) break;
    }

    final nextAppt = appointmentsNotifier.nextUpcoming;

    // Health tip of the day (rotate by day of year)
    final tipIndex =
        DateTime.now().difference(DateTime(DateTime.now().year)).inDays %
        kHealthTips.length;
    final tip = kHealthTips[tipIndex];

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(context, profile),
              const SizedBox(height: 20),

              // Adherence streak badge
              if (streak > 0) ...[
                _buildStreakBadge(streak),
                const SizedBox(height: 16),
              ],

              _buildProgressCard(takenDoses, totalDoses, progress),
              const SizedBox(height: 20),

              // Water Intake
              _buildSectionTitle('HYDRATION'),
              const SizedBox(height: 10),
              _buildWaterCard(context, ref, water),
              const SizedBox(height: 20),

              // Health Tip
              _buildSectionTitle('HEALTH TIP'),
              const SizedBox(height: 10),
              _buildTipCard(tip),
              const SizedBox(height: 20),

              // Vitals summary
              _buildSectionTitle('VITALS SNAPSHOT'),
              const SizedBox(height: 10),
              _buildVitalsRow(context, ref, vitals),
              const SizedBox(height: 20),

              _buildSectionTitle('NEXT UP'),
              const SizedBox(height: 10),
              nextMed != null && nextTime != null
                  ? _buildNextUpCard(context, ref, nextMed, nextTime)
                  : _buildEmptyCard('All doses taken for today! 🎉'),
              const SizedBox(height: 20),

              _buildSectionTitle('APPOINTMENTS'),
              const SizedBox(height: 10),
              nextAppt != null
                  ? _buildAppointmentCard(context, ref, nextAppt)
                  : _buildEmptyCard('No upcoming appointments'),
              const SizedBox(height: 20),

              _buildSectionTitle(
                'DAILY CHECK-IN',
                trailing: _logMoodBtn(context, ref),
              ),
              const SizedBox(height: 10),
              _buildMoodRow(context, ref, checkIn),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, UserProfile profile) {
    final dateStr = DateFormat('EEEE, MMM d').format(DateTime.now());
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: AppTheme.teal.withValues(alpha: 0.3),
          child: Text(
            profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.teal,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${profile.name}!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateStr,
                style: const TextStyle(color: AppTheme.teal, fontSize: 14),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppTheme.teal,
            size: 28,
          ),
          onPressed: () async {
            await NotificationService().requestPermissions();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Requested notification permissions.'),
                  backgroundColor: AppTheme.teal,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildStreakBadge(int streak) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.teal.withValues(alpha: 0.2),
            AppTheme.tealDark.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.teal.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Text(
            '$streak medicine${streak > 1 ? 's' : ''} completed today!',
            style: const TextStyle(
              color: AppTheme.teal,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          const Text(
            'Keep it up! 💪',
            style: TextStyle(color: AppTheme.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int taken, int total, double progress) {
    final pct = (progress * 100).toInt();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.teal.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Progress",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$taken of $total medicines taken',
                  style: const TextStyle(color: AppTheme.grey, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.teal,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '$pct% Complete',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CircularPercentIndicator(
            radius: 42,
            lineWidth: 6,
            percent: progress.clamp(0.0, 1.0),
            center: Text(
              '$taken/$total',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            progressColor: AppTheme.teal,
            backgroundColor: AppTheme.chipBg,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }

  Widget _buildWaterCard(
    BuildContext context,
    WidgetRef ref,
    WaterIntake water,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('💧', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Water Intake',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${water.glassCount} of ${water.goal} glasses',
                      style: const TextStyle(
                        color: AppTheme.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(water.percentage * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: water.percentage,
              minHeight: 8,
              backgroundColor: AppTheme.chipBg,
              color: Colors.blue.shade400,
            ),
          ),
          const SizedBox(height: 12),
          // Glass buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed:
                    () => ref.read(waterIntakeProvider.notifier).removeGlass(),
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.blue,
                ),
              ),
              ...List.generate(
                water.goal,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    i < water.glassCount
                        ? Icons.local_drink
                        : Icons.local_drink_outlined,
                    color:
                        i < water.glassCount
                            ? Colors.blue.shade400
                            : AppTheme.chipBg,
                    size: 22,
                  ),
                ),
              ),
              IconButton(
                onPressed:
                    () => ref.read(waterIntakeProvider.notifier).addGlass(),
                icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(HealthTip tip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.bgCard, AppTheme.tealDark.withValues(alpha: 0.15)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.teal.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Text(tip.icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip.body,
                  style: const TextStyle(color: AppTheme.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsRow(
    BuildContext context,
    WidgetRef ref,
    List<VitalRecord> vitals,
  ) {
    final notifier = ref.read(vitalsProvider.notifier);
    final hr = notifier.latestOfType('heartRate');
    final bp = notifier.latestOfType('bp');
    final bs = notifier.latestOfType('bloodSugar');

    return Row(
      children: [
        _vitalMini(
          '❤️',
          'Heart Rate',
          hr != null ? '${hr.value.toInt()} bpm' : '--',
          Colors.redAccent,
          () => _showAddVital(context, ref, 'heartRate'),
        ),
        const SizedBox(width: 8),
        _vitalMini(
          '🩸',
          'Blood P.',
          bp != null
              ? '${bp.value.toInt()}/${bp.value2?.toInt() ?? 0}'
              : '--/--',
          Colors.orangeAccent,
          () => _showAddVital(context, ref, 'bp'),
        ),
        const SizedBox(width: 8),
        _vitalMini(
          '🍬',
          'Sugar',
          bs != null ? '${bs.value.toInt()} mg/dL' : '--',
          Colors.purpleAccent,
          () => _showAddVital(context, ref, 'bloodSugar'),
        ),
      ],
    );
  }

  Widget _vitalMini(
    String emoji,
    String label,
    String value,
    Color accent,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accent.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(color: AppTheme.grey, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to log',
                style: TextStyle(
                  color: accent.withValues(alpha: 0.6),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddVital(BuildContext context, WidgetRef ref, String type) {
    final v1Ctrl = TextEditingController();
    final v2Ctrl = TextEditingController();
    final labels = {
      'heartRate': ('Heart Rate', 'bpm', false),
      'bp': ('Blood Pressure', 'mmHg', true),
      'bloodSugar': ('Blood Sugar', 'mg/dL', false),
    };
    final (title, unit, hasDual) = labels[type]!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Log $title',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (hasDual)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: v1Ctrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Systolic',
                          suffixText: unit,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: v2Ctrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Diastolic',
                        ),
                      ),
                    ),
                  ],
                )
              else
                TextField(
                  controller: v1Ctrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Value',
                    suffixText: unit,
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final v = double.tryParse(v1Ctrl.text);
                    if (v == null) return;
                    ref
                        .read(vitalsProvider.notifier)
                        .add(
                          VitalRecord(
                            type: type,
                            value: v,
                            value2: double.tryParse(v2Ctrl.text),
                            recordedAt: DateTime.now(),
                            unit: unit,
                          ),
                        );
                    Navigator.pop(ctx);
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNextUpCard(
    BuildContext context,
    WidgetRef ref,
    Medicine med,
    String time,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.bgCardLight,
            AppTheme.tealDark.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'DUE AT $time',
                style: const TextStyle(
                  color: AppTheme.teal,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            med.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${med.dosage} • ${med.notes ?? med.form}',
            style: const TextStyle(color: AppTheme.greyLight, fontSize: 14),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(medicinesProvider.notifier)
                    .markTimeTaken(med.id, time);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${med.name} marked as taken!'),
                    backgroundColor: AppTheme.teal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.check_circle, size: 20),
              label: const Text('Mark as Taken'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    WidgetRef ref,
    Appointment appt,
  ) {
    return InkWell(
      onTap: () => ref.read(currentTabProvider.notifier).state = 2,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.teal.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.teal.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: AppTheme.teal,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appt.doctorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${appt.specialty} • ${DateFormat('EEEE').format(appt.dateTime)} at ${DateFormat('h:mm a').format(appt.dateTime)}',
                    style: const TextStyle(color: AppTheme.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {Widget? trailing}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.grey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const Spacer(),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _logMoodBtn(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showMoodSheet(context, ref),
      child: const Text(
        'Log Mood',
        style: TextStyle(
          color: AppTheme.teal,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showMoodSheet(BuildContext context, WidgetRef ref) {
    int sel = 3;
    final noteCtrl = TextEditingController();
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'How are you feeling today?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(5, (i) {
                      final moods = ['😫', '😟', '😐', '🙂', '🤩'];
                      final isSel = sel == i + 1;
                      return GestureDetector(
                        onTap: () => setBS(() => sel = i + 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSel ? AppTheme.teal : AppTheme.chipBg,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            moods[i],
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: noteCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Add a note (optional)...',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(checkInProvider.notifier)
                            .saveMood(
                              sel,
                              note:
                                  noteCtrl.text.isNotEmpty
                                      ? noteCtrl.text
                                      : null,
                            );
                        Navigator.pop(context);
                      },
                      child: const Text('Save Mood'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMoodRow(
    BuildContext context,
    WidgetRef ref,
    DailyCheckIn? checkIn,
  ) {
    final moods = ['😫', '😟', '😐', '🙂', '🤩'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(5, (i) {
        final isSel = checkIn?.mood == i + 1;
        return GestureDetector(
          onTap: () => ref.read(checkInProvider.notifier).saveMood(i + 1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSel ? AppTheme.teal : AppTheme.chipBg,
              shape: BoxShape.circle,
              boxShadow:
                  isSel
                      ? [
                        BoxShadow(
                          color: AppTheme.teal.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                      : null,
            ),
            child: Text(moods[i], style: const TextStyle(fontSize: 28)),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyCard(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppTheme.grey, fontSize: 14),
      ),
    );
  }
}
