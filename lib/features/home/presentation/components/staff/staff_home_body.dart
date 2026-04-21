import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:parent_app/features/auth/cubit/auth_context_extensions.dart';
import 'package:parent_app/features/home/cubit/driver_trip_session_cubit.dart';
import 'package:parent_app/features/home/cubit/trip_cubit.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/presentation/components/staff/student_viewer.dart';
import 'package:parent_app/features/home/presentation/map_view.dart';
import 'package:parent_app/features/students/cubit/students_cubit.dart';

class StaffHomeBody extends StatefulWidget {
  const StaffHomeBody({super.key});

  @override
  State<StaffHomeBody> createState() => _StaffHomeBodyState();
}

class _StaffHomeBodyState extends State<StaffHomeBody> {
  late final TripCubit _tripCubit;
  late final DriverTripSessionCubit _driverTripSessionCubit;
  late final StudentsCubit _studentsCubit;
  LatLng? _focusedStudentLocation;
  int _focusRequestKey = 0;

  @override
  void initState() {
    super.initState();
    _tripCubit = TripCubit();
    _driverTripSessionCubit = DriverTripSessionCubit();
    _studentsCubit = StudentsCubit()..loadStudents();
  }

  @override
  void dispose() {
    _tripCubit.close();
    _driverTripSessionCubit.close();
    _studentsCubit.close();
    super.dispose();
  }

  void _onLocateStudent(LatLng coords) {
    setState(() {
      _focusedStudentLocation = coords;
      _focusRequestKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.authRole;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _tripCubit),
        BlocProvider.value(value: _driverTripSessionCubit),
        BlocProvider.value(value: _studentsCubit),
      ],
      child: BlocBuilder<TripCubit, TripState>(
        builder: (context, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.amber),
                  child: MapView(
                    focusTarget: _focusedStudentLocation,
                    focusRequestKey: _focusRequestKey,
                    controlsBottomOffset: 36,
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 8,
                            spreadRadius: 3,
                          ),
                        ],
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(16),
                          topEnd: Radius.circular(16),
                        ),
                      ),
                      child: SizedBox(height: 20, width: double.infinity),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(22, 8, 22, 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StudentViewer(
                              onLocateStudent: _onLocateStudent,
                              isDriver:
                                  context.authRoleOr('assistant') == 'driver',
                            ),
                            SizedBox(height: 42),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
