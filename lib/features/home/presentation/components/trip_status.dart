import 'package:flutter/material.dart';
import 'address_tile.dart';

class TripStatus extends StatelessWidget {
  const TripStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Trip Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
            Row(
              spacing: 8,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                  child: SizedBox(width: 14, height: 14),
                ),
                Text(
                  "No trip currently",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
        AddressTile(
          addressName: "Home",
          addressDesc: "123 Maple Street",
          trailing: "(next pickup)",
        ),
      ],
    );
  }
}
