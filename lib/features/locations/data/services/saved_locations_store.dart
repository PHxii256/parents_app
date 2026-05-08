import 'package:flutter/material.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/features/guardian/data/guardian_repository.dart';
import 'package:parent_app/features/locations/data/models/saved_location.dart';

class SavedLocationsStore {
  SavedLocationsStore._();

  static final SavedLocationsStore instance = SavedLocationsStore._();

  final ValueNotifier<List<SavedLocation>> addedLocations = ValueNotifier<List<SavedLocation>>([]);

  SavedLocation addLocation({
    required String name,
    String? addressLine,
    required double latitude,
    required double longitude,
  }) {
    final newLocation = SavedLocation(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      addressLine: (addressLine ?? '').trim(),
      isPrimary: false,
      latitude: latitude,
      longitude: longitude,
    );

    addedLocations.value = [...addedLocations.value, newLocation];
    return newLocation;
  }

  /// Loads saved locations from the API into this store (same as opening the Locations tab).
  Future<void> syncGuardianLocationsFromServer({GuardianRepository? repository}) async {
    if (!ApiConfig.useRealApi) return;
    final repo = repository ?? GuardianRepository();
    final serverLocations = await repo.getLocations();
    mergeServerLocations(serverLocations);
  }

  void mergeServerLocations(List<SavedLocation> serverLocations) {
    final existingIds = addedLocations.value.map((location) => location.id).toSet();
    final merged = [...addedLocations.value];
    for (final location in serverLocations) {
      if (!existingIds.contains(location.id)) {
        merged.add(location);
      }
    }
    addedLocations.value = merged;
  }

  SavedLocation? removeLocationById(String id) {
    final current = [...addedLocations.value];
    final index = current.indexWhere((location) => location.id == id);
    if (index < 0) return null;
    final removed = current.removeAt(index);
    addedLocations.value = current;
    return removed;
  }

  void insertLocationAt({required int index, required SavedLocation location}) {
    final current = [...addedLocations.value];
    final insertIndex = index.clamp(0, current.length);
    current.insert(insertIndex, location);
    addedLocations.value = current;
  }
}
