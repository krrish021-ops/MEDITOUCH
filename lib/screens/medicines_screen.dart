/// Medicines list screen matching design screenshot 2.
/// Shows search, filter chips, medicine cards with dose times, and FAB to add.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import 'add_medicine_screen.dart';

class MedicinesScreen extends ConsumerStatefulWidget {
  const MedicinesScreen({super.key});

  @override
  ConsumerState<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends ConsumerState<MedicinesScreen> {
  String _searchQuery = '';
  String _activeFilter = 'All';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Medicine> _filteredMedicines(List<Medicine> all) {
    var list =
        all.where((m) {
          if (_searchQuery.isNotEmpty) {
            return m.name.toLowerCase().contains(_searchQuery.toLowerCase());
          }
          return true;
        }).toList();

    switch (_activeFilter) {
      case 'Active':
        list = list.where((m) => !m.isCompleted).toList();
        break;
      case 'Completed':
        list = list.where((m) => m.isCompleted).toList();
        break;
      case 'Today':
        list = list.where((m) => m.reminderTimes.isNotEmpty).toList();
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final medicines = ref.watch(medicinesProvider);
    final filtered = _filteredMedicines(medicines);

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed:
              () => _showDummyDialog(
                context,
                'Menu',
                'Navigation menu coming soon!',
              ),
        ),
        title: const Text('Regimen Flow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() => _searchQuery = _searchQuery.isEmpty ? ' ' : '');
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search your guards...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.grey),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.close, color: AppTheme.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                        : null,
              ),
            ),
          ),

          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children:
                  ['All', 'Active', 'Completed', 'Today'].map((label) {
                    final isActive = _activeFilter == label;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: isActive,
                        onSelected:
                            (_) => setState(() => _activeFilter = label),
                        selectedColor: AppTheme.teal,
                        backgroundColor: AppTheme.chipBg,
                        labelStyle: TextStyle(
                          color: isActive ? Colors.white : AppTheme.teal,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color:
                                isActive
                                    ? AppTheme.teal
                                    : AppTheme.teal.withValues(alpha: 0.4),
                          ),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'ACTIVE GUARDS',
                  style: TextStyle(
                    color: AppTheme.teal,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  '${filtered.length} Total',
                  style: const TextStyle(color: AppTheme.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Medicine cards list
          Expanded(
            child:
                filtered.isEmpty
                    ? const Center(
                      child: Text(
                        'No guards found in your regimen.',
                        style: TextStyle(color: AppTheme.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filtered.length,
                      itemBuilder:
                          (ctx, i) =>
                              _buildMedicineCard(context, ref, filtered[i]),
                    ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: AppTheme.fabGlow,
        ),
        child: FloatingActionButton(
          tooltip: 'Prescribe Guard',
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
            );
          },
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  Widget _buildMedicineCard(BuildContext context, WidgetRef ref, Medicine med) {
    // Determine next untaken time
    String? nextTime;
    for (final t in med.reminderTimes) {
      if (!med.takenTimes.contains(t)) {
        nextTime = t;
        break;
      }
    }

    // Choose icon for medicine form
    IconData formIcon;
    switch (med.form.toLowerCase()) {
      case 'capsule':
        formIcon = Icons.medication;
        break;
      case 'syrup':
        formIcon = Icons.local_drink;
        break;
      case 'injection':
        formIcon = Icons.vaccines;
        break;
      default:
        formIcon = Icons.medication_liquid;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.teal.withValues(alpha: 0.15)),
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
                child: Icon(formIcon, color: AppTheme.teal, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      med.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${med.dosage}, ${med.form.isNotEmpty ? med.form.substring(0, 1).toLowerCase() + med.form.substring(1) : ''}',
                      style: const TextStyle(
                        color: AppTheme.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (med.isCompleted)
                const Icon(Icons.check_circle, color: AppTheme.teal, size: 24)
              else
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppTheme.grey),
                  color: AppTheme.bgCardLight,
                  onSelected: (val) {
                    if (val == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddMedicineScreen(editMedicine: med),
                        ),
                      );
                    } else if (val == 'markAll') {
                      ref.read(medicinesProvider.notifier).markAllTaken(med.id);
                    } else if (val == 'delete') {
                      ref.read(medicinesProvider.notifier).delete(med.id);
                    }
                  },
                  itemBuilder:
                      (_) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Modify Directive'),
                        ),
                        const PopupMenuItem(
                          value: 'markAll',
                          child: Text('Secure all'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                ),
            ],
          ),

          // Time chips
          if (med.reminderTimes.length > 1) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children:
                  med.reminderTimes.map((t) {
                    final isTaken = med.takenTimes.contains(t);
                    final isNext = t == nextTime;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isNext
                                ? AppTheme.teal
                                : isTaken
                                ? AppTheme.teal.withValues(alpha: 0.2)
                                : AppTheme.chipBg,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            isNext
                                ? null
                                : Border.all(
                                  color: AppTheme.teal.withValues(alpha: 0.3),
                                ),
                      ),
                      child: Text(
                        t,
                        style: TextStyle(
                          color: isNext ? Colors.white : AppTheme.greyLight,
                          fontSize: 12,
                          fontWeight:
                              isNext ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],

          // Next time or frequency
          const SizedBox(height: 10),
          if (nextTime != null && !med.isCompleted)
            Row(
              children: [
                const Icon(Icons.access_time, color: AppTheme.teal, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Next guard at $nextTime',
                  style: const TextStyle(color: AppTheme.teal, fontSize: 13),
                ),
              ],
            )
          else if (med.reminderTimes.length == 1)
            Text(
              '${med.frequency} at ${med.reminderTimes.first}',
              style: const TextStyle(color: AppTheme.grey, fontSize: 13),
            ),

          // Status chip
          const SizedBox(height: 8),
          if (med.isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.teal.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.teal.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'Secured',
                style: TextStyle(
                  color: AppTheme.teal,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else if (med.isReminderOn)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.teal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.teal.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.notifications_active,
                        color: AppTheme.teal,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Reminders ON',
                        style: TextStyle(
                          color: AppTheme.teal,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.sort, color: AppTheme.teal),
                title: const Text('Sort by Name'),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: const Icon(Icons.access_time, color: AppTheme.teal),
                title: const Text('Sort by Time'),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: const Icon(Icons.category, color: AppTheme.teal),
                title: const Text('Filter by Form'),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDummyDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
