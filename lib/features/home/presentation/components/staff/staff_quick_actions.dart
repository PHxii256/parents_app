import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:parent_app/features/absence/data/student_data.dart';
import 'package:parent_app/features/home/cubit/driver_trip_session_cubit.dart';
import 'package:parent_app/features/home/cubit/driver_trip_session_state.dart';
import 'package:parent_app/features/locations/service/gmap_url_util.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';
import 'package:parent_app/shared/widgets/rounded_cta_button.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffQuickActions extends StatelessWidget {
  final StudentData? currentStudent;
  final ValueChanged<LatLng> onLocateStudent;
  final bool isDriver;

  const StaffQuickActions({
    super.key,
    required this.currentStudent,
    required this.onLocateStudent,
    this.isDriver = false,
  });

  Future<bool> _confirmTripToggle(BuildContext context, {required bool tripActive}) async {
    final localizations = AppLocalizations.of(context)!;
    final actionLabel = tripActive ? localizations.staffEndTrip : localizations.staffStartTrip;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations.tripActionConfirmTitle),
        content: Text(localizations.tripActionConfirmBody(actionLabel)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(localizations.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(localizations.commonConfirm),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<Uri?> _buildGoogleMapsDirectionsUri(StudentData student) async {
    final directCoords = student.toLatLng();
    final resolvedCoords = directCoords ?? await parseGmapsUrl(student.gMapsLink);
    if (resolvedCoords == null) {
      return Uri.tryParse(student.gMapsLink);
    }

    return Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': '${resolvedCoords.latitude},${resolvedCoords.longitude}',
      'travelmode': 'driving',
      'dir_action': 'navigate',
    });
  }

  Future<void> _openInGoogleMaps(BuildContext context) async {
    if (currentStudent == null) return;
    final uri = await _buildGoogleMapsDirectionsUri(currentStudent!);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    final openMapsLabel = localizations.staffOpenInGoogleMaps;
    final startTripLabel = localizations.staffStartTrip;
    final endTripLabel = localizations.staffEndTrip;
    final locateStudentLabel = localizations.locateStudent;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                localizations.quickActionsTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
            ),

            if (isDriver)
              BlocBuilder<DriverTripSessionCubit, DriverTripSessionState>(
                builder: (context, state) {
                  final tripActive = state is DriverTripActiveState || state is DriverTripUpdatingState;
                  final buttonLabel = tripActive ? endTripLabel : startTripLabel;
                  return RoundedCtaButton(
                    text: buttonLabel,
                    onTap: () async {
                      final confirmed = await _confirmTripToggle(context, tripActive: tripActive);
                      if (!confirmed) {
                        return;
                      }

                      if (tripActive) {
                        context.read<DriverTripSessionCubit>().endSession();
                      } else {
                        context.read<DriverTripSessionCubit>().startSession();
                      }
                    },
                  );
                },
              ),
          ],
        ),

        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 8.0;
            final availableWidth = constraints.maxWidth - spacing;
            final mapsTileWidth = availableWidth * (2 / 3);
            final endTripTileWidth = availableWidth - mapsTileWidth;

            return Row(
              children: [
                SizedBox(
                  width: endTripTileWidth,
                  child: Column(
                    spacing: 6,
                    children: [
                      IconBox(
                        icon: Icons.gps_fixed,
                        height: 80,
                        iconSize: 32,
                        width: endTripTileWidth,
                        onTap: currentStudent != null
                            ? () {
                                final parsed = currentStudent!.toLatLng();
                                if (parsed != null) {
                                  onLocateStudent(parsed);
                                }
                              }
                            : null,
                      ),
                      Text(locateStudentLabel, style: labelStyle),
                    ],
                  ),
                ),
                const SizedBox(width: spacing),

                SizedBox(
                  width: mapsTileWidth,
                  child: Column(
                    spacing: 6,
                    children: [
                      IconBox(
                        icon: Icons.navigation_outlined,
                        height: 80,
                        iconSize: 32,
                        width: mapsTileWidth,
                        onTap: currentStudent != null
                            ? () => _openInGoogleMaps(context)
                            : null,
                      ),
                      Text(openMapsLabel, style: labelStyle),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
