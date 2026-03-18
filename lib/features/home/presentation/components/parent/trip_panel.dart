import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/home/data/staff_data.dart';
import 'package:parent_app/features/home/cubit/trip_cubit.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class TripPanel extends StatefulWidget {
  final double height;
  const TripPanel({super.key, required this.height});

  @override
  State<TripPanel> createState() => _TripPanelState();
}

class _TripPanelState extends State<TripPanel> {
  bool _showDriverInfo = false;

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final normalizedPhone = phoneNumber.trim();
    if (normalizedPhone.isEmpty) {
      return;
    }

    await launchUrl(Uri(scheme: 'tel', path: normalizedPhone));
  }

  Future<void> _launchWhatsApp(StaffData staff) async {
    final rawLink = staff.whatsappLink?.trim();
    final whatsappUri = rawLink != null && rawLink.isNotEmpty
        ? Uri.parse(rawLink)
        : Uri.parse('https://wa.me/${staff.phoneNum.replaceAll(RegExp(r'[^0-9+]'), '')}');

    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final activeTrip = context.select<TripCubit, ActiveTripState?>(
      (cubit) => cubit.state is ActiveTripState ? cubit.state as ActiveTripState : null,
    );

    if (activeTrip == null) {
      return const SizedBox.shrink();
    }

    final selectedStaff = _showDriverInfo ? activeTrip.driverInfo : activeTrip.assistantInfo;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        height: widget.height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarBubbles(
              displayedName: _showDriverInfo
                  ? activeTrip.driverInfo.name
                  : activeTrip.assistantInfo.name,
              showDriverInfo: _showDriverInfo,
              onTap: () {
                setState(() {
                  _showDriverInfo = !_showDriverInfo;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 28, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  LicensePlate(
                    licensePlateLetters: activeTrip.licensePlateLetters,
                    licensePlateNumbers: activeTrip.licensePlateNumbers,
                  ),
                  CircularActionButton(
                    icon: Icons.message,
                    onTap: () => _launchWhatsApp(selectedStaff),
                  ),
                  CircularActionButton(
                    icon: Icons.call,
                    onTap: () => _launchPhoneCall(selectedStaff.phoneNum),
                  ),
                  Eta(eta: activeTrip.eta),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Eta extends StatelessWidget {
  final int eta;

  const Eta({super.key, required this.eta});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return DecoratedBox(
      decoration: BoxDecoration(color: AppColors.mutedBgDark),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Positioned(
              top: 6,
              child: Text("$eta", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Positioned(bottom: 2, child: Text(localizations.tripEtaUnitMin)),
          ],
        ),
      ),
    );
  }
}

class CircularActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const CircularActionButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: AppColors.mutedBgDark,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Icon(icon, color: AppColors.brownBg),
        ),
      ),
    );
  }
}

class LicensePlate extends StatelessWidget {
  final String licensePlateLetters;
  final String licensePlateNumbers;

  const LicensePlate({
    super.key,
    required this.licensePlateLetters,
    required this.licensePlateNumbers,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.mutedBgDark,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(licensePlateLetters, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.mutedBgDark.withAlpha(160),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(licensePlateNumbers, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AvatarBubbles extends StatelessWidget {
  final String displayedName;
  final bool showDriverInfo;
  final VoidCallback onTap;

  const AvatarBubbles({
    super.key,
    required this.displayedName,
    required this.showDriverInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final IconData primaryIcon = showDriverInfo ? Icons.directions_bus_rounded : Icons.person;
    final IconData secondaryIcon = showDriverInfo ? Icons.person : Icons.directions_bus_rounded;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 22,
            top: 22,
            child: CircleAvatar(
              radius: 27,
              backgroundColor: AppColors.highlightText.withAlpha(60),
              child: CircleAvatar(
                radius: 21,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: Icon(secondaryIcon, color: AppColors.highlightText.withAlpha(90)),
              ),
            ),
          ),
          CircleAvatar(
            radius: 27,
            backgroundColor: AppColors.mutedBgDark,
            child: CircleAvatar(
              radius: 21,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Stack(
                clipBehavior: Clip.none,
                children: [Icon(primaryIcon, color: AppColors.highlightText.withAlpha(60))],
              ),
            ),
          ),
          Positioned(
            left: isRtl ? null : 58,
            right: isRtl ? 58 : null,
            top: 2,
            child: Row(
              spacing: 4,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayedName, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  showDriverInfo ? localizations.driverRoleLabel : localizations.assistantRoleLabel,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -16,
            left: 4,
            child: Icon(
              Icons.swap_horiz_sharp,
              size: 48,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          Positioned(
            bottom: -8,
            left: 13,
            child: Icon(Icons.swap_horiz_sharp, size: 30, color: AppColors.onSurfaceDark),
          ),
        ],
      ),
    );
  }
}
