import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_colors.dart';
import '../data/parent_data.dart';
import '../data/api_service.dart';
import '../domain/absence_cubit.dart';
import '../domain/absence_repo.dart';
import '../domain/absence_state.dart';
import '../domain/request_state.dart';

class AbsencePage extends StatefulWidget {
  const AbsencePage({super.key});

  @override
  State<AbsencePage> createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsencePage> {
  List<int> selectedChildrenIds = [];
  String selectedDateOption = 'Tomorrow';

  @override
  Widget build(BuildContext context) {
    final repository = AbsenceRepository(FakeApiService());
    final localizations = AppLocalizations.of(context)!;

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
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              localizations.selectChildrenTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Column(
              children: currentParent.students.map((student) {
                final isSelected = selectedChildrenIds.contains(student.id);
                print("fffffff$selectedChildrenIds");

                return ListTile(
                  leading: CircleAvatar(backgroundColor: AppColors.mutedBgDark, radius: 20),
                  title: Text(student.name),
                  subtitle: Text(student.grade),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedChildrenIds.remove(student.id);
                      } else {
                        selectedChildrenIds.add(student.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),


            const SizedBox(height: 20),
            Text(
              "Select Absence Date",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            RadioListTile<String>(
              title: const Text("Tomorrow"),
              value: 'Tomorrow',
              groupValue: selectedDateOption,
              onChanged: (value) => setState(() => selectedDateOption = value!),
            ),
            const SizedBox(height: 40),
            BlocConsumer<AbsenceCubit, AbsenceState>(
              listener: (context, state) {
                if (state.status == RequestStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.isAbsent ? "Absence request sent" : "Absence removed"),
                    ),
                  );
                }
                if (state.status == RequestStatus.error) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message ?? "Something went wrong")));
                }
              },
              builder: (context, state) {
                final cubit = context.read<AbsenceCubit>();
                final buttonDisabled =
                    selectedChildrenIds.isEmpty || state.status == RequestStatus.loading;

                if (state.isAbsent) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: buttonDisabled
                          ? null
                          : () => cubit.toggleAbsence(selectedChildrenIds),
                      child: state.status == RequestStatus.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Undo Absence",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                }
                print("fffffff$selectedChildrenIds");
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cta,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: buttonDisabled
                        ? null
                        : () => cubit.toggleAbsence(selectedChildrenIds),
                    child: state.status == RequestStatus.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Mark as Absent",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
