import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:parent_app/features/absence/data/student_data.dart';
import 'package:parent_app/features/students/data/models/route_student_item.dart';
import 'package:parent_app/features/students/data/repositories/students_repository.dart';
import 'package:parent_app/features/home/presentation/components/staff/staff_quick_actions.dart';
import 'package:parent_app/features/home/presentation/components/staff/student_info_tile.dart';
import 'package:parent_app/features/home/presentation/components/staff/student_progress.dart';
import 'package:parent_app/features/home/presentation/components/staff/student_status.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class StudentViewer extends StatefulWidget {
  final ValueChanged<LatLng> onLocateStudent;
  final bool isDriver;

  const StudentViewer({
    super.key,
    required this.onLocateStudent,
    this.isDriver = false,
  });

  @override
  State<StudentViewer> createState() => _StudentViewerState();
}

class _StudentViewerState extends State<StudentViewer> {
  final PageController _pageController = PageController();
  final StudentsRepository _studentsRepository = StudentsRepository();
  int _currentIndex = 0;
  List<RouteStudentItem> _items = const [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final data = await _studentsRepository.fetchRouteStudents(direction: 'am');
    if (!mounted) return;
    setState(() {
      _items = data;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateToIndex(int index) {
    if (!_pageController.hasClients) {
      return;
    }

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final localizations = AppLocalizations.of(context)!;
    final maxIndex = _items.length - 1;
    int _getCurrentIndex(int i) {
      return min(i - 1, maxIndex - 2);
    }

    VoidCallback? goNext(int maxIndex) {
      if (_currentIndex < maxIndex) {
        return () {
          final nextIndex = _currentIndex + 1;
          setState(() => _currentIndex = nextIndex);
          _animateToIndex(nextIndex);
        };
      }
      return null;
    }

    VoidCallback? goBack() {
      if (_currentIndex > 0) {
        return () {
          final previousIndex = _currentIndex - 1;
          setState(() => _currentIndex = previousIndex);
          _animateToIndex(previousIndex);
        };
      }
      return null;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudentProgress(
          currentIndex: _getCurrentIndex(_currentIndex),
          totalStudents: _items.length - 2,
          onPrevious: goBack(),
          onNext: goNext(maxIndex),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 112,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _items.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final item = _items[index];
              if (item.isSchool) {
                final isCampusSchool = index == 0;
                final schoolPlaceLabel =
                    isCampusSchool ? localizations.schoolCampusLabel : localizations.schoolStopLabel;
                return Column(
                  children: [
                    StudentInfoTile(
                      iconOverride: Icons.school,
                      studentData: StudentData(
                        id: -1,
                        name: item.name,
                        grade: '',
                        pinCodes: const [],
                        address: schoolPlaceLabel,
                        gMapsLink: item.gMapsUrl,
                        coords: const [],
                      ),
                    ),
                    const SizedBox(height: 6),
                    StudentStatus(statusOverride: schoolPlaceLabel),
                  ],
                );
              }
              final student = item.studentData;
              if (student == null) return const SizedBox.shrink();
              return Column(
                children: [
                  StudentInfoTile(studentData: student),
                  const SizedBox(height: 6),
                  StudentStatus(studentId: item.id),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        StaffQuickActions(
          currentStudent: _items[_currentIndex].studentData,
          onLocateStudent: widget.onLocateStudent,
          isDriver: widget.isDriver,
        ),
      ],
    );
  }
}
