import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/auth/cubit/auth_context_extensions.dart';
import 'package:parent_app/features/home/cubit/trip_cubit.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/presentation/components/staff/communication_bar.dart';
import 'package:parent_app/features/home/presentation/components/staff/staff_quick_actions.dart';
import 'package:parent_app/features/home/presentation/components/staff/student_info_tile.dart';
import 'package:parent_app/features/home/presentation/components/staff/student_progress.dart';
import 'package:parent_app/features/home/presentation/components/staff/student_status.dart';
import 'package:parent_app/features/home/presentation/map_view.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class StaffHomeBody extends StatelessWidget {
  const StaffHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.authRole;
    Center(child: Text('Bus staff home ($role)'));
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => TripCubit(),
      child: Builder(
        builder: (context) {
          const double activeTripPanelHeight = 74;
          const double activeTripPanelBottomPadding = 6;
          final bool hasActiveTrip = context.watch<TripCubit>().state is ActiveTripState;
          final double currentTripHeight = hasActiveTrip
              ? activeTripPanelHeight + activeTripPanelBottomPadding
              : 0;

          return Stack(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.amber),
                child: SizedBox(
                  height: 488 - currentTripHeight,
                  width: double.infinity,
                  child: MapView(),
                ),
              ),
              Column(
                children: [
                  Expanded(child: Container()),
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
                  DecoratedBox(
                    decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(22, 8, 22, 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StudentProgress(),
                          SizedBox(height: 12),
                          StudentInfoTile(
                            name: "Ahmed Mohsen",
                            address: localizations.homeAddressDesc,
                            grade: "Grade 6",
                            pinCodes: ["12345", "67890"],
                          ),
                          SizedBox(height: 4),
                          StudentStatus(),
                          SizedBox(height: 8),
                          CommunicationBar(),
                          SizedBox(height: 12),
                          StaffQuickActions(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
