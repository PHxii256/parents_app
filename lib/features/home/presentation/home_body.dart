import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/quick_actions.dart';
import 'package:parent_app/features/home/presentation/components/trip_status.dart';
import 'package:parent_app/features/home/presentation/map_view.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ClipRRect(
            child: Stack(
              alignment: AlignmentGeometry.bottomCenter,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.amber),
                  child: SizedBox(height: 460, width: double.infinity, child: MapView()),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 8, spreadRadius: 3)],
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(16),
                      topEnd: Radius.circular(16),
                    ),
                  ),
                  child: SizedBox(height: 20, width: double.infinity),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 18,
              children: [TripStatus(), QuickActions()],
            ),
          ),
        ],
      ),
    );
  }
}
