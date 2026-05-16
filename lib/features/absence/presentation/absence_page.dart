import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/app_localizations.dart';
import '../../../main.dart';
import '../../change_request/presentation/components/date_radio_group.dart';
import '../domain/absence_cubit.dart';
import '../domain/absence_state.dart';

enum AbsenceDateOption { today, tomorrow, specific }

class AbsencePage extends StatefulWidget {
  const AbsencePage({super.key});

  @override
  State<AbsencePage> createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  late final AbsenceCubit _absenceCubit;
  AbsenceDateOption selectedOption = AbsenceDateOption.today;
  DateTime? specificDate;
  DateTime? selectedAbsenceDate;

  @override
  void initState() {
    super.initState();
    _absenceCubit = sl<AbsenceCubit>();
  }

  @override
  void dispose() {
    _absenceCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _absenceCubit,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          elevation: 0,
          title: Text(
            localizations.absenceTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<AbsenceCubit, AbsenceState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
            if (!state.isLoading &&
                state.selectedChildrenIds.isEmpty &&
                state.absentChildrenIds.isNotEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(localizations.absenceSuccessfullyMarked)));
            }
          },
          builder: (context, state) {
            final cubit = context.read<AbsenceCubit>();

            return RefreshIndicator(
              onRefresh: cubit.loadChildren,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    localizations.selectChildrenTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),

                  if (state.children.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    ...state.children.map((child) {
                      final isSelected = state.selectedChildrenIds.contains(child.id);
                      final isAbsent = state.absentChildrenIds.contains(child.id);

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(Icons.child_care),
                        ),
                        title: Text(
                          child.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          isAbsent
                              ? localizations.absenceStudentStatusAbsent
                              : localizations.absenceStudentStatusPresent,
                        ),
                        trailing: isAbsent
                            ? TextButton(
                                onPressed: state.isLoading || selectedAbsenceDate == null
                                    ? null
                                    : () => cubit.undoAbsence(child.id, selectedAbsenceDate!),
                                child: Text(
                                  localizations.absenceUndoAction,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              )
                            : isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: isAbsent ? null : () => cubit.toggleSelectChild(child.id),
                      );
                    }),

                  const SizedBox(height: 20),
                  Text(
                    localizations.absenceDateTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  DateRadioGroup(
                    onDateSelected: (DateTime selectedDate) {
                      setState(() => selectedAbsenceDate = selectedDate);
                    },
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          state.selectedChildrenIds.isEmpty ||
                              state.isLoading ||
                              selectedAbsenceDate == null
                          ? null
                          : () => cubit.markAbsent(selectedAbsenceDate!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              localizations.markAsAbsentButton,
                              style: const TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
