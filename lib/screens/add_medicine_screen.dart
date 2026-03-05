/// Add / Edit Medicine screen matching design screenshot 4.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  final Medicine? editMedicine;
  const AddMedicineScreen({super.key, this.editMedicine});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _dosageCtrl;
  late final TextEditingController _notesCtrl;
  String _form = 'Tablet';
  String _freq = 'Once a day';
  bool _withFood = true;
  List<String> _times = ['08:00 AM', '08:00 PM'];

  static const _forms = ['Tablet', 'Capsule', 'Syrup', 'Injection', 'Other'];
  static const _freqs = [
    'Once a day',
    'Twice a day',
    'Three times a day',
    'Every 6 hours',
    'Custom',
  ];

  @override
  void initState() {
    super.initState();
    final m = widget.editMedicine;
    _nameCtrl = TextEditingController(text: m?.name ?? '');
    _dosageCtrl = TextEditingController(text: m?.dosage ?? '');
    _notesCtrl = TextEditingController(text: m?.notes ?? '');
    if (m != null) {
      _form = m.form;
      _freq = m.frequency;
      _withFood = m.withFood;
      _times = List.from(m.reminderTimes);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) {
      final p = t.period == DayPeriod.am ? 'AM' : 'PM';
      final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
      final formatted =
          '${h.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} $p';
      if (!_times.contains(formatted)) setState(() => _times.add(formatted));
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final med = Medicine(
      id: widget.editMedicine?.id,
      name: _nameCtrl.text.trim(),
      dosage: _dosageCtrl.text.trim(),
      form: _form,
      reminderTimes: _times,
      frequency: _freq,
      withFood: _withFood,
      notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
      isReminderOn: true,
      takenTimes: widget.editMedicine?.takenTimes ?? [],
      isCompleted: widget.editMedicine?.isCompleted ?? false,
    );
    if (widget.editMedicine != null) {
      ref.read(medicinesProvider.notifier).update(med);
    } else {
      ref.read(medicinesProvider.notifier).add(med);
    }
    Navigator.pop(context);
  }

  Widget _label(String t) => Text(
    t,
    style: const TextStyle(
      color: AppTheme.teal,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.editMedicine != null
              ? 'Modify Guard Directive'
              : 'Prescribe Guard',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppTheme.grey),
            onPressed:
                () => showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text('Help'),
                        content: const Text(
                          'Fill in name and dosage (required). Choose form, frequency, set reminder times. Toggle food preference and add notes.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Got it'),
                          ),
                        ],
                      ),
                ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Guard Name'), const SizedBox(height: 6),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  hintText: 'e.g. Paracetamol',
                  suffixIcon: Icon(
                    Icons.medication,
                    color: AppTheme.grey.withValues(alpha: 0.5),
                  ),
                ),
                validator:
                    (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 18),
              _label('Dosage'), const SizedBox(height: 6),
              TextFormField(
                controller: _dosageCtrl,
                decoration: InputDecoration(
                  hintText: 'e.g. 500 mg',
                  suffixIcon: Icon(
                    Icons.straighten,
                    color: AppTheme.grey.withValues(alpha: 0.5),
                  ),
                ),
                validator:
                    (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 18),
              // Form & Frequency
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Form'),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.bgCardLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _form,
                              isExpanded: true,
                              dropdownColor: AppTheme.bgCardLight,
                              items:
                                  _forms
                                      .map(
                                        (f) => DropdownMenuItem(
                                          value: f,
                                          child: Text(f),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) => setState(() => _form = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Frequency'),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.bgCardLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _freq,
                              isExpanded: true,
                              dropdownColor: AppTheme.bgCardLight,
                              items:
                                  _freqs
                                      .map(
                                        (f) => DropdownMenuItem(
                                          value: f,
                                          child: Text(f),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) => setState(() => _freq = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Reminder Times
              Row(
                children: [
                  _label('Reminder Times'),
                  const Spacer(),
                  GestureDetector(
                    onTap: _pickTime,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: AppTheme.teal,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Add Time',
                          style: TextStyle(
                            color: AppTheme.teal,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  ..._times.map(
                    (t) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.teal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            t,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => setState(() => _times.remove(t)),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickTime,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.teal.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                        color: AppTheme.chipBg,
                      ),
                      child: const Icon(
                        Icons.access_time,
                        color: AppTheme.teal,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Take with food
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.restaurant, color: AppTheme.teal),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Take with food?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Better absorption with meals',
                            style: TextStyle(
                              color: AppTheme.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _withFood,
                      onChanged: (v) => setState(() => _withFood = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _label('Additional Notes'), const SizedBox(height: 6),
              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'e.g. Do not take with caffeine...',
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save, size: 20),
                  label: Text(
                    widget.editMedicine != null
                        ? 'Update Directive'
                        : 'Secure Protocol',
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
