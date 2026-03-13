import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class AbsencePage extends StatefulWidget {
  const AbsencePage({super.key});

  @override
  State<AbsencePage> createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsencePage> {
  // Selected children (multiple)
  List<String> selectedChildren = [];

  // Absence date selection
  String selectedDateOption = 'Tomorrow';

  // List of children
  final List<Map<String, String>> children = [
    {'name': 'Ahmed Mohsen', 'grade': 'Grade 2'},
    {'name': 'Mohamed Salah', 'grade': 'Grade 5'},
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations.absenceTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Select children
          Text(
            localizations.selectChildrenTitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Column(
            children: children.map((child) {
              final name = child['name']!;
              final grade = child['grade']!;
              final isSelected = selectedChildren.contains(name);

              return ListTile(
                leading: CircleAvatar(backgroundColor: AppColors.mutedBgDark, radius: 20),
                title: Text(name),
                subtitle: Text(grade, style: const TextStyle(color: Colors.grey)),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedChildren.remove(name);
                    } else {
                      selectedChildren.add(name);
                    }
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Absence date
          Text(
            localizations.absenceDateTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          RadioGroup<String>(
            onChanged: (value) => setState(() => selectedDateOption = value!),
            groupValue: selectedDateOption,
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Text(localizations.todayMonday),
                  value: 'Today',
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                RadioListTile<String>(
                  title: Text(localizations.tomorrow),
                  value: 'Tomorrow',
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                RadioListTile<String>(
                  title: Text(localizations.specificDate),
                  value: 'Specific date',
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                RadioListTile<String>(
                  title: Text(localizations.duration),
                  value: 'Duration',
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Mark as absent button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.cta),
              onPressed: () {
                // Example: print selected children
                debugPrint('Selected children: $selectedChildren');
                debugPrint('Selected date option: $selectedDateOption');
              },
              child: Text(
                localizations.markAsAbsentButton,
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
