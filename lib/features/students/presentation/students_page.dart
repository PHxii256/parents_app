import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/students/cubit/students_cubit.dart';
import 'package:parent_app/features/students/cubit/students_state.dart';
import 'package:parent_app/features/students/presentation/components/location_tile.dart';
import 'package:parent_app/features/students/presentation/components/student_page_search.dart';
import 'package:parent_app/features/students/presentation/components/track_segment.dart';
import 'package:parent_app/features/students/presentation/components/student_page_tile.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  late final StudentsCubit _studentsCubit;

  @override
  void initState() {
    super.initState();
    _studentsCubit = StudentsCubit()..loadStudents();
  }

  @override
  void dispose() {
    _studentsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: _studentsCubit,
      child: BlocBuilder<StudentsCubit, StudentsState>(
        builder: (context, state) {
          final routeItems = state.students;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  centerTitle: true,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  surfaceTintColor: Colors.transparent,
                  title: Text(
                    localizations.students,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const StudentPageSearch(),
                if (state.loading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (routeItems.isEmpty)
                  const Expanded(
                    child: Center(child: Text('No students assigned yet.')),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 22.0),
                      child: ListView.builder(
                        primary: false,
                        padding: EdgeInsets.zero,
                        itemCount: routeItems.length,
                        itemBuilder: (context, index) {
                          final item = routeItems[index];
                          final isLast = index == routeItems.length - 1;
                          final isFirst = index == 0;
                          if (item.isSchool) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isLast)
                                  const TrackSegment(
                                    height: 16,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 22,
                                      vertical: 4,
                                    ),
                                  ),
                                LocationTile(
                                  name: item.name,
                                  icon: Icons.school,
                                ),
                              ],
                            );
                          }
                          final student = item.studentData;
                          if (student == null) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isFirst) const TrackSegment(),
                              StudentPageTile(student: student),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
