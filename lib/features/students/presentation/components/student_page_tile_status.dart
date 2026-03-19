import 'package:flutter/material.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class StudentPageTileStatus extends StatefulWidget {
  const StudentPageTileStatus({super.key});

  @override
  State<StudentPageTileStatus> createState() => _StudentPageTileStatusState();
}

class _StudentPageTileStatusState extends State<StudentPageTileStatus> {
  bool busBoarded = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 6,
      children: [
        IconBox(icon: Icons.info_outline, height: 62, iconSize: 24, width: 48),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                spacing: 6,
                children: [
                  Text("Status:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text("(Coming Today)", style: TextStyle(fontSize: 14)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    spacing: 4,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Boarded Bus:",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        busBoarded ? "Yes" : "No",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                    child: Switch(
                      padding: EdgeInsets.all(0),
                      value: busBoarded,
                      onChanged: (current) {
                        setState(() {
                          busBoarded = current;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
