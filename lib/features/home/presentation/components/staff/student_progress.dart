import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_panel.dart';
import 'package:parent_app/features/home/presentation/components/staff/attendance_status_circle.dart';

class StudentProgress extends StatelessWidget {
  const StudentProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Students", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
            SizedBox(
              height: 28,
              child: Row(
                spacing: 8,
                children: [
                  CircularActionButton(icon: Icons.navigate_before, onTap: () {}),
                  Text("1/26"),
                  CircularActionButton(icon: Icons.navigate_next, onTap: () {}),
                  AttendanceStatusCircle(),
                  //AttendanceStatusCircle(color: Colors.red, icon: Icons.close),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
