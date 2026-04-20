import 'package:flutter/material.dart';
import 'package:parent_app/features/locations/data/models/saved_location.dart';

class SavedLocationsStore {
  SavedLocationsStore._();

  static final SavedLocationsStore instance = SavedLocationsStore._();

  final ValueNotifier<List<SavedLocation>> addedLocations = ValueNotifier<List<SavedLocation>>([]);

  SavedLocation addLocation({required String name, String? addressLine}) {
    final newLocation = SavedLocation(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      addressLine: (addressLine ?? '').trim(),
      isPrimary: false,
    );

    addedLocations.value = [...addedLocations.value, newLocation];
    return newLocation;
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
