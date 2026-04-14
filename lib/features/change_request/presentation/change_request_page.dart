import 'package:flutter/material.dart';
import 'package:parent_app/features/change_request/data/services/change_request_store.dart';
import 'package:parent_app/features/change_request/presentation/change_request_confirmed_page.dart';
import 'package:parent_app/features/change_request/presentation/add_location_page.dart';
import 'package:parent_app/features/change_request/presentation/change_request_summary.dart';
import 'package:parent_app/features/change_request/presentation/components/date_radio_group.dart';
import 'package:parent_app/features/change_request/presentation/models/change_request_payload.dart';
import 'package:parent_app/features/locations/data/models/saved_location.dart';
import 'package:parent_app/features/locations/data/services/saved_locations_store.dart';
import 'package:parent_app/features/locations/presentation/components/saved_location_tile.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class ChangeRequestPage extends StatefulWidget {
  const ChangeRequestPage({super.key});

  @override
  State<ChangeRequestPage> createState() => _ChangeRequestPage();
}

class _ChangeRequestPage extends State<ChangeRequestPage> {
  // Pickup / Dropoff selection (at least one must remain selected)
  bool isPickupSelected = true;
  bool isDropoffSelected = false;
  DateTime? dateTime;

  // Saved addresses selection
  String selectedAddress = 'grandma';

  void _togglePickup() {
    final willUnselectPickup = isPickupSelected;
    final wouldLeaveNoneSelected = willUnselectPickup && !isDropoffSelected;
    if (wouldLeaveNoneSelected) return;
    setState(() => isPickupSelected = !isPickupSelected);
  }

  void _toggleDropoff() {
    final willUnselectDropoff = isDropoffSelected;
    final wouldLeaveNoneSelected = willUnselectDropoff && !isPickupSelected;
    if (wouldLeaveNoneSelected) return;
    setState(() => isDropoffSelected = !isDropoffSelected);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final activeRequest = ChangeRequestStore.instance.activeRequest.value;
    if (activeRequest != null) {
      return ChangeRequestConfirmedPage(
        payload: activeRequest,
        onUndo: () => setState(() => ChangeRequestStore.instance.clear()),
      );
    }

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final primaryLocation = SavedLocation(
      id: 'home',
      name: localizations.homeAddressName,
      addressLine: localizations.homeAddressDesc,
      isPrimary: true,
    );
    final nonPrimaryDefaultLocations = <SavedLocation>[
      SavedLocation(
        id: 'grandma',
        name: localizations.grandmasHouseName,
        addressLine: localizations.grandmasHouseAddress,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.requestTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              localizations.changePickupDropoff,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            Text(
              localizations.changeRequestDateSubtitle,
              style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 22),
            ),
            const SizedBox(height: 12),
            // Pickup / Dropoff toggle
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _togglePickup,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isPickupSelected ? AppColors.highlight : Colors.transparent,
                          borderRadius: isRtl
                              ? BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  bottomRight: Radius.circular(32),
                                )
                              : BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  bottomLeft: Radius.circular(32),
                                ),
                        ),
                        child: Center(
                          child: Text(
                            localizations.pickupLabel,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _toggleDropoff,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isDropoffSelected ? AppColors.highlight : Colors.transparent,
                          borderRadius: isRtl
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  bottomLeft: Radius.circular(32),
                                )
                              : BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  bottomRight: Radius.circular(32),
                                ),
                        ),
                        child: Center(
                          child: Text(
                            localizations.dropoffLabel,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Saved Addresses header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.savedAddressesTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => const AddLocationPage()));
                  },
                  child: Text(localizations.addNewAddress, style: TextStyle(color: AppColors.cta)),
                ),
              ],
            ),
            ValueListenableBuilder<List<SavedLocation>>(
              valueListenable: SavedLocationsStore.instance.addedLocations,
              builder: (context, addedLocations, _) {
                final allLocations = [
                  ...nonPrimaryDefaultLocations,
                  ...addedLocations.where((location) => !location.isPrimary),
                ];
                return Column(
                  children: allLocations
                      .map(
                        (location) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SavedLocationTile(
                            location: location,
                            selected: selectedAddress == location.id,
                            onTap: () => setState(() => selectedAddress = location.id),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),

            const SizedBox(height: 12),

            // Date options
            DateRadioGroup(
              onDateSelected: (DateTime selectedDate) {
                setState(() => dateTime = selectedDate);
              },
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.cta),
                onPressed: dateTime == null
                    ? null
                    : () {
                        final nonPrimaryLocations = [
                          ...nonPrimaryDefaultLocations,
                          ...SavedLocationsStore.instance.addedLocations.value.where(
                            (location) => !location.isPrimary,
                          ),
                        ];

                        final requestedLocation = nonPrimaryLocations.firstWhere(
                          (location) => location.id == selectedAddress,
                          orElse: () => nonPrimaryLocations.first,
                        );

                        final payload = ChangeRequestPayload(
                          isPickupSelected: isPickupSelected,
                          isDropoffSelected: isDropoffSelected,
                          primaryLocation: primaryLocation,
                          requestedLocation: requestedLocation,
                          selectedDate: dateTime!,
                        );

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChangeRequestSummaryPage(payload: payload),
                          ),
                        );
                      },
                child: Text(
                  localizations.nextButton,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
