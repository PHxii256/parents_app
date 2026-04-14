import 'package:parent_app/features/locations/data/models/saved_location.dart';

class ChangeRequestPayload {
  final bool isPickupSelected;
  final bool isDropoffSelected;
  final SavedLocation primaryLocation;
  final SavedLocation requestedLocation;
  final DateTime selectedDate;

  const ChangeRequestPayload({
    required this.isPickupSelected,
    required this.isDropoffSelected,
    required this.primaryLocation,
    required this.requestedLocation,
    required this.selectedDate,
  });

  SavedLocation get pickupLocation => isPickupSelected ? requestedLocation : primaryLocation;
  SavedLocation get dropoffLocation => isDropoffSelected ? requestedLocation : primaryLocation;
}
