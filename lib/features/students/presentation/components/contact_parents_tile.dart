import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_panel.dart';
import 'package:parent_app/features/home/presentation/components/staff/latest_message_viewer.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class ContactParentsTile extends StatelessWidget {
  const ContactParentsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 6,
      children: [
        IconBox(icon: Icons.group, height: 42, iconSize: 24, width: 48),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: SizedBox(
              height: 48,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 6,
                  children: [
                    Expanded(child: LatestMessageViewer()),
                    CircularActionButton(icon: Icons.location_pin, size: 16, onTap: () => {}),
                    CircularActionButton(icon: Icons.call, size: 16, onTap: () => {}),
                    //RoundedCtaButton(text: "", icon: Icons.call, height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
