import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_colors.dart';
import '../data/parent_data.dart';
import '../data/api_service.dart';
import '../domain/absence_cubit.dart';
import '../domain/absence_repo.dart';
import '../domain/absence_state.dart';

class AbsencePage extends StatelessWidget {
  const AbsencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AbsenceRepository(FakeApiService());
    final localizations = AppLocalizations.of(context)!;

    // Tomorrow's date
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowFormatted = DateFormat('yyyy-MM-dd').format(tomorrow);
    print("Tomorrow timestamp: ${tomorrow.millisecondsSinceEpoch}");

    return BlocProvider(
      create: (_) => AbsenceCubit(repository),
      child: Scaffold(
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
        body: BlocConsumer<AbsenceCubit, AbsenceState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
            if (!state.isLoading &&
                state.selectedChildrenIds.isEmpty &&
                state.absentChildrenIds.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Absence request sent")),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<AbsenceCubit>();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  localizations.selectChildrenTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),

                // Children list
                Column(
                  children: currentParent.students.map((student) {
                    final isSelected = state.selectedChildrenIds.contains(student.id);
                    final isAbsent = state.absentChildrenIds.contains(student.id);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.mutedBgDark,
                        radius: 20,
                        child: isAbsent ? const Icon(Icons.check, color: Colors.white) : null,
                      ),
                      title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(student.grade, style: const TextStyle(color: Colors.grey)),
                      trailing: isAbsent
                          ? IconButton(
                        icon: const Icon(Icons.undo, color: Colors.red),
                        onPressed: state.isLoading ? null : () => cubit.undoAbsence(student.id),
                      )
                          : isSelected
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: isAbsent
                          ? null
                          : () {
                        cubit.toggleSelectChild(student.id);
                        print("Selected IDs: ${cubit.state.selectedChildrenIds}");
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),
                Text(
                  "Absence date",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tomorrow: $tomorrowFormatted",
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cta,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: state.selectedChildrenIds.isEmpty || state.isLoading
                        ? null
                        : () {
                      print("Marking absent for IDs: ${state.selectedChildrenIds}");
                      cubit.markAbsent();
                    },
                    child: state.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Mark as Absent",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}