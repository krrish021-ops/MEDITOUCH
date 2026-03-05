import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

const Map<String, List<String>> kSymptomToMedicineMap = {
  'Fever': ['Paracetamol (e.g., Crocin, Tylenol)', 'Ibuprofen (e.g., Advil)'],
  'Headache': ['Aspirin', 'Ibuprofen', 'Paracetamol'],
  'Cough': ['Dextromethorphan (Cough Syrup)', 'Honey & Lozenges'],
  'Sore Throat': ['Lozenges (e.g., Strepsils)', 'Salt Water Gargle'],
  'Stomach Ache': ['Antacids (e.g., Digene, Tums)', 'Pepto-Bismol'],
  'Nausea': ['Ondansetron', 'Ginger supplements'],
  'Allergies': ['Cetirizine (e.g., Zyrtec)', 'Loratadine (e.g., Claritin)'],
  'Body Ache': ['Ibuprofen', 'Acetaminophen'],
};

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final Set<String> _selectedSymptoms = {};
  List<String> _suggestedMedicines = [];

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
      _updateSuggestions();
    });
  }

  void _updateSuggestions() {
    final suggestions = <String>{};
    for (final symptom in _selectedSymptoms) {
      if (kSymptomToMedicineMap.containsKey(symptom)) {
        suggestions.addAll(kSymptomToMedicineMap[symptom]!);
      }
    }
    setState(() {
      _suggestedMedicines = suggestions.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('State Diagnose'),
        backgroundColor: AppTheme.bgLight,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.primaryBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Disclaimer: These suggestions are for common over-the-counter medicines. Always consult a doctor for severe symptoms.',
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'What are you feeling today?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    kSymptomToMedicineMap.keys.map((symptom) {
                      final isSelected = _selectedSymptoms.contains(symptom);
                      return FilterChip(
                        label: Text(symptom),
                        selected: isSelected,
                        onSelected: (_) => _toggleSymptom(symptom),
                        backgroundColor: AppTheme.chipBg,
                        selectedColor: AppTheme.primaryBlue.withValues(
                          alpha: 0.2,
                        ),
                        checkmarkColor: AppTheme.primaryBlue,
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? AppTheme.primaryBlue
                                  : AppTheme.textDark,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color:
                                isSelected
                                    ? AppTheme.primaryBlue
                                    : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 32),
              if (_selectedSymptoms.isNotEmpty) ...[
                const Text(
                  'Suggested Medicines',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _suggestedMedicines.isEmpty
                    ? const Text(
                      'No specific suggestions found.',
                      style: TextStyle(color: AppTheme.textLight),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _suggestedMedicines.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: AppTheme.chipBg,
                              width: 1.5,
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.medication,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            title: Text(
                              _suggestedMedicines[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              ] else ...[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.health_and_safety,
                          size: 64,
                          color: AppTheme.chipBg,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Select your symptoms above\nto see suggested relief.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
