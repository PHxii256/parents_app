import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/students/cubit/students_cubit.dart';
import 'package:parent_app/features/students/cubit/students_state.dart';
import 'package:parent_app/features/students/presentation/components/location_tile.dart';
import 'package:parent_app/features/students/presentation/components/student_page_search.dart';
import 'package:parent_app/features/students/presentation/components/track_segment.dart';
import 'package:parent_app/features/students/presentation/components/student_page_tile.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  late final StudentsCubit _studentsCubit;
  String _searchQuery = '';
  bool _filterBoardedBus = false;
  bool _filterDroppedOff = false;
  final Map<String, bool> _boardedByStudentId = {};
  final Map<String, bool> _droppedOffByStudentId = {};

  int get _activeFilterCount {
    var count = 0;
    if (_filterBoardedBus) count++;
    if (_filterDroppedOff) count++;
    return count;
  }

  Future<void> _openGoogleMaps(String link) async {
    final uri = Uri.tryParse(link);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

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

  void _showFilterSheet(AppLocalizations? localizations) {
    bool tempBoarded = _filterBoardedBus;
    bool tempDropped = _filterDroppedOff;

    showModalBottomSheet<void>(
      barrierColor: Colors.black38,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      context: context,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      localizations?.studentsFilterTitle ?? 'Filter Students',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: tempBoarded,
                      title: Text(
                        localizations?.studentBoardedBusLabel ?? 'Boarded Bus',
                      ),
                      onChanged: (value) {
                        setSheetState(() {
                          tempBoarded = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                      value: tempDropped,
                      title: Text(
                        localizations?.studentDroppedOffLabel ?? 'Dropped off',
                      ),
                      onChanged: (value) {
                        setSheetState(() {
                          tempDropped = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _filterBoardedBus = false;
                              _filterDroppedOff = false;
                            });
                            Navigator.of(sheetContext).pop();
                          },
                          child: Text(
                            localizations?.studentsFilterClear ?? 'Clear',
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              _filterBoardedBus = tempBoarded;
                              _filterDroppedOff = tempDropped;
                            });
                            Navigator.of(sheetContext).pop();
                          },
                          child: Text(
                            localizations?.commonConfirm ?? 'Confirm',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return BlocProvider.value(
      value: _studentsCubit,
      child: BlocBuilder<StudentsCubit, StudentsState>(
        builder: (context, state) {
          final routeItems = state.students;
          final trimmedQuery = _searchQuery.trim().toLowerCase();
          final hasActiveFilters = _activeFilterCount > 0 || trimmedQuery.isNotEmpty;
          final filteredItems = routeItems.where((item) {
            if (item.isSchool) {
              return trimmedQuery.isEmpty &&
                  !_filterBoardedBus &&
                  !_filterDroppedOff;
            }
            final matchesSearch =
                trimmedQuery.isEmpty ||
                item.name.toLowerCase().contains(trimmedQuery);
            if (!matchesSearch) return false;

            final boarded = _boardedByStudentId[item.id] ?? false;
            final dropped = _droppedOffByStudentId[item.id] ?? false;
            if (_filterBoardedBus && !boarded) return false;
            if (_filterDroppedOff && !dropped) return false;
            return true;
          }).toList();
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
                    localizations?.students ?? 'Students',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  actions: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: () => _showFilterSheet(localizations),
                          icon: const Icon(Icons.filter_list),
                        ),
                        if (_activeFilterCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$_activeFilterCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                StudentPageSearch(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                if (state.loading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (filteredItems.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        hasActiveFilters
                            ? (localizations?.noStudentsMatchingFilters ??
                                  'No students matching selected filters.')
                            : (localizations?.noStudentsAssignedYet ?? 'No students assigned yet.'),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 22.0),
                      child: ListView.builder(
                        primary: false,
                        padding: EdgeInsets.zero,
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          final isLast = index == filteredItems.length - 1;
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
                                  onLocationTap: () =>
                                      _openGoogleMaps(item.gMapsUrl),
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
                              StudentPageTile(
                                student: student,
                                onLocationTap: () =>
                                    _openGoogleMaps(student.gMapsLink),
                                boardedBus:
                                    _boardedByStudentId[item.id] ?? false,
                                droppedOff:
                                    _droppedOffByStudentId[item.id] ?? false,
                                onBoardedChanged: (value) {
                                  setState(() {
                                    _boardedByStudentId[item.id] = value;
                                    if (!value) {
                                      _droppedOffByStudentId[item.id] = false;
                                    }
                                  });
                                },
                                onDroppedOffChanged: (value) {
                                  setState(() {
                                    _droppedOffByStudentId[item.id] = value;
                                  });
                                },
                              ),
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
