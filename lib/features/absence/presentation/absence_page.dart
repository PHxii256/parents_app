import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';
import '../../change_request/presentation/components/date_radio_group.dart';
import '../data/api_service.dart';
import '../data/student_data.dart';
import '../domain/absence_cubit.dart';
import '../domain/absence_repo.dart';
import '../domain/absence_state.dart';

enum AbsenceDateOption { today, tomorrow, specific }

class AbsencePage extends StatefulWidget {
  const AbsencePage({super.key});

  @override
  State<AbsencePage> createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  AbsenceDateOption selectedOption = AbsenceDateOption.today;
  DateTime? specificDate;

  @override
  Widget build(BuildContext context) {
    final students = StudentData.mockStudentData;

    DateTime? dateToUse;

    return BlocProvider(
      create: (_) => sl<AbsenceCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: const Text(
            "Mark Absence",
            style: TextStyle(fontWeight: FontWeight.bold),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Absence successfully marked")),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<AbsenceCubit>();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Select Students",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),

                // Students list
                Column(
                  children: students.map((student) {
                    final isSelected = state.selectedChildrenIds.contains(
                      student.id,
                    );
                    final isAbsent = state.absentChildrenIds.contains(
                      student.id,
                    );

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: isAbsent
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                      title: Text(
                        student.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(student.grade),
                      trailing: isAbsent
                          ? IconButton(
                              icon: const Icon(Icons.undo, color: Colors.red),
                              onPressed: state.isLoading || dateToUse == null
                                  ? null
                                  : () => cubit.undoAbsence(
                                      student.id,
                                      dateToUse!,
                                    ),
                            )
                          : isSelected
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: isAbsent
                          ? null
                          : () => cubit.toggleSelectChild(student.id),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),
                const Text(
                  "Absence Date",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                DateRadioGroup(
                  onDateSelected: (DateTime selectedDate) {
                    dateToUse=selectedDate;
                    print("dddddd$dateToUse");
                  },
                ),

                // Column(
                //   children: [
                //     GestureDetector(
                //       onTap: () => setState(() {
                //         selectedOption = AbsenceDateOption.tomorrow;
                //         specificDate = null;
                //       }),
                //       child: Container(
                //         padding: const EdgeInsets.symmetric(
                //           horizontal: 16,
                //           vertical: 8,
                //         ),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           border: Border.all(color: Colors.grey.shade200),
                //
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //         child: Row(
                //           children: [
                //             Expanded(
                //               child: RichText(
                //                 text: TextSpan(
                //                   style: const TextStyle(
                //                     fontFamily: 'Lexend',
                //                     fontSize: 16,
                //                     color: Colors.black,
                //                   ),
                //                   children: [
                //                     const TextSpan(
                //                       text: "Tomorrow ",
                //                       style: TextStyle(
                //                         fontWeight: FontWeight.w700,
                //                       ),
                //                     ),
                //                     TextSpan(
                //                       text: "($tomorrowDayName)",
                //
                //                       style: TextStyle(
                //                         color: Colors.grey.shade500,
                //                         fontWeight: FontWeight.w400,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ),
                //             Radio<AbsenceDateOption>(
                //               value: AbsenceDateOption.tomorrow,
                //               groupValue: selectedOption,
                //               activeColor: Colors.black,
                //
                //               onChanged: (value) => setState(() {
                //                 selectedOption = value!;
                //                 specificDate = null;
                //               }),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //     const SizedBox(height: 12),
                //
                //     GestureDetector(
                //       onTap: () async {
                //         final picked = await showDatePicker(
                //           context: context,
                //           initialDate: specificDate ?? DateTime.now(),
                //           firstDate: DateTime.now(),
                //           lastDate: DateTime.now().add(
                //             const Duration(days: 365),
                //           ),
                //         );
                //         if (picked != null) {
                //           setState(() {
                //             specificDate = picked;
                //             selectedOption = AbsenceDateOption.specific;
                //           });
                //         }
                //       },
                //       child: Container(
                //         padding: const EdgeInsets.symmetric(
                //           horizontal: 16,
                //           vertical: 8,
                //         ),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           border: Border.all(color: Colors.grey.shade200),
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //         child: Row(
                //           children: [
                //             Expanded(
                //               child: Text(
                //                 specificDate != null
                //                     ? DateFormat(
                //                         'EEEE, d MMMM,ar',
                //                       ).format(specificDate!)
                //                     : "Specific date",
                //                 style: const TextStyle(
                //                   fontFamily: 'Lexend',
                //                   fontWeight: FontWeight.w700,
                //                   fontSize: 16,
                //                   color: Colors.black,
                //                 ),
                //               ),
                //             ),
                //             Radio<AbsenceDateOption>(
                //               value: AbsenceDateOption.specific,
                //               groupValue: selectedOption,
                //               activeColor: Colors.black,
                //               onChanged: (value) =>
                //                   setState(() => selectedOption = value!),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // )
                const SizedBox(height: 100),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        state.selectedChildrenIds.isEmpty ||
                            state.isLoading ||
                            dateToUse == null
                        ? null
                        : () => cubit.markAbsent(dateToUse!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // optional rounded corners
                      ),
                    ),
                    child: state.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Mark as Absent",
                            style: TextStyle(fontSize: 18),
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
