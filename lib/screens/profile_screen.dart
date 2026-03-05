// Profile screen with personal info, health conditions, allergies, BMI, and emergency contact.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _nameCtrl,
      _ageCtrl,
      _phoneCtrl,
      _emailCtrl,
      _heightCtrl,
      _weightCtrl,
      _emergNameCtrl,
      _emergPhoneCtrl;
  String _gender = 'Male';
  String? _bloodGroup;
  bool _inited = false;

  @override
  void dispose() {
    if (_inited) {
      _nameCtrl.dispose();
      _ageCtrl.dispose();
      _phoneCtrl.dispose();
      _emailCtrl.dispose();
      _heightCtrl.dispose();
      _weightCtrl.dispose();
      _emergNameCtrl.dispose();
      _emergPhoneCtrl.dispose();
    }
    super.dispose();
  }

  void _init() {
    final p = ref.read(profileProvider);
    _nameCtrl = TextEditingController(text: p.name);
    _ageCtrl = TextEditingController(text: p.age?.toString() ?? '');
    _phoneCtrl = TextEditingController(text: p.phone ?? '');
    _emailCtrl = TextEditingController(text: p.email ?? '');
    _heightCtrl = TextEditingController(text: p.height?.toString() ?? '');
    _weightCtrl = TextEditingController(text: p.weight?.toString() ?? '');
    _emergNameCtrl = TextEditingController(text: p.emergencyContactName ?? '');
    _emergPhoneCtrl = TextEditingController(
      text: p.emergencyContactPhone ?? '',
    );
    _gender = p.gender ?? 'Male';
    _bloodGroup = p.bloodGroup;
    _inited = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_inited) _init();
    final profile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        title: const Text('Identity Core'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar with initial
            CircleAvatar(
              radius: 45,
              backgroundColor: AppTheme.teal.withValues(alpha: 0.2),
              child: Text(
                profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.teal,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            if (profile.bloodGroup != null)
              Chip(
                label: Text('Blood: ${profile.bloodGroup}'),
                backgroundColor: AppTheme.chipBg,
                side: BorderSide.none,
              ),
            const SizedBox(height: 8),

            // BMI Card
            if (profile.bmi != null) _buildBmiCard(profile),
            const SizedBox(height: 16),

            // Health Conditions
            if (profile.healthConditions.isNotEmpty) ...[
              _sectionTitle('🏥 Health Conditions'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children:
                    profile.healthConditions
                        .map(
                          (c) => Chip(
                            label: Text(
                              c,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: AppTheme.teal.withValues(
                              alpha: 0.15,
                            ),
                            side: BorderSide(
                              color: AppTheme.teal.withValues(alpha: 0.3),
                            ),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Allergies
            if (profile.allergies.isNotEmpty) ...[
              _sectionTitle('⚠️ Allergies'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children:
                    profile.allergies
                        .map(
                          (a) => Chip(
                            label: Text(
                              a,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: Colors.redAccent.withValues(
                              alpha: 0.15,
                            ),
                            side: BorderSide(
                              color: Colors.redAccent.withValues(alpha: 0.3),
                            ),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Emergency Contact
            if (profile.emergencyContactName != null) ...[
              _sectionTitle('🆘 Emergency Contact'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emergency,
                      color: Colors.redAccent,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.emergencyContactName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (profile.emergencyContactPhone != null)
                          Text(
                            profile.emergencyContactPhone!,
                            style: const TextStyle(
                              color: AppTheme.grey,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            const Divider(color: AppTheme.chipBg, height: 32),

            // Editable fields
            _field('Name', _nameCtrl, Icons.person, required: true),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _field(
                    'Age',
                    _ageCtrl,
                    Icons.cake,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gender',
                        style: TextStyle(
                          color: AppTheme.teal,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.bgCardLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _gender,
                            isExpanded: true,
                            dropdownColor: AppTheme.bgCardLight,
                            items:
                                ['Male', 'Female', 'Other', 'Prefer not to say']
                                    .map(
                                      (g) => DropdownMenuItem(
                                        value: g,
                                        child: Text(g),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (v) => setState(() => _gender = v!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _label('Blood Group'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  kBloodGroups.map((bg) {
                    final s = _bloodGroup == bg;
                    return ChoiceChip(
                      label: Text(bg),
                      selected: s,
                      onSelected: (_) => setState(() => _bloodGroup = bg),
                      selectedColor: AppTheme.teal,
                      backgroundColor: AppTheme.chipBg,
                      labelStyle: TextStyle(
                        color: s ? Colors.white : AppTheme.greyLight,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color:
                              s
                                  ? AppTheme.teal
                                  : AppTheme.teal.withValues(alpha: 0.3),
                        ),
                      ),
                      showCheckmark: false,
                    );
                  }).toList(),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _field(
                    'Height (cm)',
                    _heightCtrl,
                    Icons.height,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    'Weight (kg)',
                    _weightCtrl,
                    Icons.monitor_weight,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _field(
              'Phone',
              _phoneCtrl,
              Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            _field(
              'Email',
              _emailCtrl,
              Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            _field('Emergency Name', _emergNameCtrl, Icons.emergency),
            const SizedBox(height: 14),
            _field(
              'Emergency Phone',
              _emergPhoneCtrl,
              Icons.phone_callback,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save, size: 20),
                label: const Text('Save Identity'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiCard(UserProfile p) {
    final bmi = p.bmi!;
    final cat = p.bmiCategory;
    Color bmiColor;
    if (bmi < 18.5) {
      bmiColor = Colors.blue;
    } else if (bmi < 25) {
      bmiColor = AppTheme.teal;
    } else if (bmi < 30) {
      bmiColor = Colors.orange;
    } else {
      bmiColor = Colors.redAccent;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: bmiColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bmiColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                bmi.toStringAsFixed(1),
                style: TextStyle(
                  color: bmiColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'BMI',
                style: TextStyle(color: AppTheme.grey, fontSize: 12),
              ),
              Text(
                cat,
                style: TextStyle(
                  color: bmiColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${p.height?.toInt() ?? 0} cm · ${p.weight?.toInt() ?? 0} kg',
                style: const TextStyle(color: AppTheme.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      t,
      style: const TextStyle(
        color: AppTheme.grey,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _label(String t) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      t,
      style: const TextStyle(
        color: AppTheme.teal,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),
  );

  Widget _field(
    String label,
    TextEditingController ctrl,
    IconData icon, {
    bool required = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.teal,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.grey, size: 20),
            hintText: label,
          ),
        ),
      ],
    );
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name is required')));
      return;
    }
    final current = ref.read(profileProvider);
    ref
        .read(profileProvider.notifier)
        .updateProfile(
          current.copyWith(
            name: _nameCtrl.text.trim(),
            age: int.tryParse(_ageCtrl.text.trim()),
            gender: _gender,
            bloodGroup: _bloodGroup,
            phone:
                _phoneCtrl.text.trim().isNotEmpty
                    ? _phoneCtrl.text.trim()
                    : null,
            email:
                _emailCtrl.text.trim().isNotEmpty
                    ? _emailCtrl.text.trim()
                    : null,
            height: double.tryParse(_heightCtrl.text.trim()),
            weight: double.tryParse(_weightCtrl.text.trim()),
            emergencyContactName:
                _emergNameCtrl.text.trim().isNotEmpty
                    ? _emergNameCtrl.text.trim()
                    : null,
            emergencyContactPhone:
                _emergPhoneCtrl.text.trim().isNotEmpty
                    ? _emergPhoneCtrl.text.trim()
                    : null,
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Identity secured.'),
        backgroundColor: AppTheme.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
