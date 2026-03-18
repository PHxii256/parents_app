import 'package:flutter/material.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class StudentStatus extends StatelessWidget {
  const StudentStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: Row(
        spacing: 6,
        children: [
          IconBox(icon: Icons.info_outline, height: 42, width: 48),
          Text("Status:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text("(Coming Today)", style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
