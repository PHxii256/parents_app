import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/data/provider/trip_data_provider.dart';
import 'package:parent_app/features/home/data/staff_data.dart';

class TripRepository {
  final TripDataProvider tripData = TripDataProvider();

  Future<TripState> fetchTripState() async {
    final response = await tripData.getCurrentTrip();
    final data = response.data;

    if (data is! Map<String, dynamic>) {
      return InactiveTripState();
    }

    final status = (data['status'] as String?)?.toLowerCase();
    if (status == 'offline') {
      return OfflineTripState();
    }
    if (status == 'inactive') {
      return InactiveTripState();
    }

    if (status == 'active') {
      final eta = (data['eta'] as num?)?.toInt() ?? 0;

      final plate = data['licensePlate'] as Map<String, dynamic>?;
      final assistant = data['assistantInfo'] as Map<String, dynamic>?;
      final driver = data['driverInfo'] as Map<String, dynamic>?;

      return ActiveTripState(
        eta: eta,
        licensePlateLetters: (plate?['letters'] as String?) ?? '',
        licensePlateNumbers: (plate?['numbers'] as String?) ?? '',
        assistantInfo: StaffData(
          name: (assistant?['name'] as String?) ?? '',
          phoneNum: (assistant?['phoneNum'] as String?) ?? '',
          whatsappLink: assistant?['whatsappLink'] as String?,
        ),
        driverInfo: StaffData(
          name: (driver?['name'] as String?) ?? '',
          phoneNum: (driver?['phoneNum'] as String?) ?? '',
          whatsappLink: driver?['whatsappLink'] as String?,
        ),
      );
    }

    return InactiveTripState();
  }
}
