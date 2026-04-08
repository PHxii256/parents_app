import 'package:flutter/material.dart';
import 'package:parent_app/features/absence/data/student_data.dart';
import 'package:parent_app/features/home/presentation/components/staff/staff_quick_actions.dart';
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

  double _measureStudentInfoHeight(BuildContext context, StudentData student, double maxWidth) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final nameStyle = defaultStyle.merge(
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, height: 0.95),
    );
    final addressStyle = defaultStyle.merge(const TextStyle(fontSize: 15));
    const horizontalUsedByIconAndGap = 60.0; // 48 icon + 12 gap
    final contentWidth = (maxWidth - horizontalUsedByIconAndGap).clamp(0.0, double.infinity);

    final namePainter = TextPainter(
      text: TextSpan(text: student.name, style: nameStyle),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: contentWidth);

    final addressPainter = TextPainter(
      text: TextSpan(text: student.address, style: addressStyle),
      maxLines: 2,
      ellipsis: '...',
      textDirection: Directionality.of(context),
    )..layout(maxWidth: contentWidth);

    const contentVerticalPadding = 12.0; // 6 top + 6 bottom
    const contentSpacing = 4.0;
    const measurementSafetyBuffer = 6.0;
    final contentHeight =
        namePainter.height +
        contentSpacing +
        addressPainter.height +
        contentVerticalPadding +
        measurementSafetyBuffer;

    return contentHeight < 56 ? 56 : contentHeight;
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
        LayoutBuilder(
          builder: (context, constraints) {
            final infoHeight = StudentData.mockStudentData
                .map((student) => _measureStudentInfoHeight(context, student, constraints.maxWidth))
                .reduce((a, b) => a > b ? a : b);
            const statusSpacing = 6.0;
            const statusHeight = 28.0;
            final totalHeight = infoHeight + statusSpacing + statusHeight;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              height: totalHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: StudentData.mockStudentData.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) => Column(
                  children: [
                    StudentInfoTile(studentData: StudentData.mockStudentData[index]),
                    const SizedBox(height: 6),
                    const StudentStatus(),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        StaffQuickActions(onDone: goNext(maxIndex)),
      ],
    );
  }
}
