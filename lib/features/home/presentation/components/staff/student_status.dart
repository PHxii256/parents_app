import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/features/students/cubit/students_cubit.dart';
import 'package:parent_app/features/students/cubit/students_state.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class StudentStatus extends StatelessWidget {
  final String? studentId;
  final String? statusOverride;
  const StudentStatus({super.key, this.studentId, this.statusOverride});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final canEdit = studentId != null && statusOverride == null;

    return BlocBuilder<StudentsCubit, StudentsState>(
      builder: (context, state) {
        final status = statusOverride ?? state.statuses[studentId] ?? localizations.comingToday;

        return SizedBox(
          height: 28,
          child: Row(
            spacing: 6,
            children: [
              IconBox(icon: Icons.info_outline, height: 40, width: 48),
              Text(
                '${localizations.status}:',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Expanded(child: Text('($status)', style: const TextStyle(fontSize: 14))),
              if (canEdit)
                InkWell(
                  onTap: () => context.read<StudentsCubit>().markBoarded(studentId!),
                  child: const Icon(Icons.login, size: 16),
                ),
              if (canEdit)
                InkWell(
                  onTap: () => context.read<StudentsCubit>().markDroppedOff(studentId!),
                  child: const Icon(Icons.logout, size: 16),
                ),
            ],
          ),
        );
      },
    );
  }
}
