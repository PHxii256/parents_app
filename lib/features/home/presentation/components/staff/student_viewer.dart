import 'package:flutter/material.dart';
import 'package:parent_app/features/absence/data/student_data.dart';
import 'package:parent_app/features/home/presentation/components/staff/communication_bar.dart';
import 'package:parent_app/features/home/presentation/components/staff/student_info_tile.dart';
import 'package:parent_app/features/home/presentation/components/staff/student_progress.dart';
import 'package:parent_app/features/home/presentation/components/staff/student_status.dart';

class StudentViewer extends StatefulWidget {
  const StudentViewer({super.key});

  @override
  State<StudentViewer> createState() => _StudentViewerState();
}

class _StudentViewerState extends State<StudentViewer> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

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
    final maxIndex = StudentData.mockStudentData.length - 1;

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
        LayoutBuilder(
          builder: (context, constraints) {
            return StudentProgress(
              currentIndex: _currentIndex,
              totalStudents: StudentData.mockStudentData.length,
              onPrevious: goBack(),
              onNext: goNext(maxIndex),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 102,
          child: PageView.builder(
            controller: _pageController,
            itemCount: StudentData.mockStudentData.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) => Column(
              children: [
                SizedBox(
                  height: 72,
                  child: StudentInfoTile(studentData: StudentData.mockStudentData[index]),
                ),
                const SizedBox(height: 4),
                const StudentStatus(),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),
        const CommunicationBar(),
      ],
    );
  }
}
