import 'package:flutter/material.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';
import 'package:parent_app/shared/widgets/rounded_cta_button.dart';

class ContactParentsTile extends StatelessWidget {
  const ContactParentsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 6,
      children: [
        IconBox(icon: Icons.group, height: 48, iconSize: 24, width: 48),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                spacing: 6,
                children: [
                  RoundedCtaButton(text: "Call Parents", icon: Icons.call),
                  RoundedCtaButton(text: "Message", icon: Icons.message),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
