import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/home/cubit/trip_cubit.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class TripStatus extends StatelessWidget {
  const TripStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<TripCubit, TripState>(
      builder: (context, state) {
        final isActive = state is ActiveTripState;
        final isInactive = state is InactiveTripState;

        return Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.tripStatusTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
                InkWell(
                  // for testing
                  onTap: () {
                    context.read<TripCubit>().cycleState();
                  },
                  child: Row(
                    spacing: 8,
                    children: [
                      DecoratedBox(
                        decoration: isActive
                            ? BoxDecoration(
                                color: const Color.fromARGB(255, 22, 218, 29),
                                shape: BoxShape.circle,
                              )
                            : BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                        child: SizedBox(width: 14, height: 14),
                      ),
                      Text(
                        isActive
                            ? localizations.onTheWay
                            : isInactive
                            ? localizations.noTripCurrently
                            : localizations.youAreOffline,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: isActive ? const Color.fromARGB(255, 22, 218, 29) : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
