import 'package:flutter/material.dart';
import 'package:parent_app/features/change_request/presentation/add_location_page.dart';
import 'package:parent_app/features/locations/data/models/saved_location.dart';
import 'package:parent_app/features/locations/data/services/saved_locations_store.dart';
import 'package:parent_app/features/locations/presentation/components/saved_location_tile.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  bool _isEditMode = false;
  final Set<String> _removedDefaultLocationIds = <String>{};

  void _showUndoSnackbar({
    required String message,
    required VoidCallback onUndo,
    required AppLocalizations localizations,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(message),
        action: SnackBarAction(label: localizations.undoAction, onPressed: onUndo),
      ),
    );
  }

  void _deleteLocation({
    required SavedLocation location,
    required List<SavedLocation> defaultLocations,
    required List<SavedLocation> addedLocations,
    required AppLocalizations localizations,
  }) {
    if (location.isPrimary) return;

    final isDefaultLocation = defaultLocations.any((l) => l.id == location.id);
    if (isDefaultLocation) {
      setState(() => _removedDefaultLocationIds.add(location.id));
      _showUndoSnackbar(
        message: localizations.locationDeletedMessage(location.name),
        localizations: localizations,
        onUndo: () {
          setState(() => _removedDefaultLocationIds.remove(location.id));
        },
      );
      return;
    }

    final removedIndex = addedLocations.indexWhere((l) => l.id == location.id);
    final removed = SavedLocationsStore.instance.removeLocationById(location.id);
    if (removed == null) return;

    _showUndoSnackbar(
      message: localizations.locationDeletedMessage(location.name),
      localizations: localizations,
      onUndo: () {
        SavedLocationsStore.instance.insertLocationAt(index: removedIndex, location: removed);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final defaultLocations = <SavedLocation>[
      SavedLocation(
        id: 'home',
        name: localizations.homeAddressName,
        addressLine: localizations.homeAddressDesc,
        isPrimary: true,
      ),
      SavedLocation(
        id: 'grandma',
        name: localizations.grandmasHouseName,
        addressLine: localizations.grandmasHouseAddress,
      ),
    ].where((location) => !_removedDefaultLocationIds.contains(location.id)).toList();

    return SafeArea(
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            title: Text(
              localizations.locationsTab,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                tooltip: localizations.editLocations,
                icon: Icon(_isEditMode ? Icons.close : Icons.edit_outlined),
                onPressed: () {
                  setState(() => _isEditMode = !_isEditMode);
                },
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: ValueListenableBuilder<List<SavedLocation>>(
                valueListenable: SavedLocationsStore.instance.addedLocations,
                builder: (context, addedLocations, _) {
                  final allLocations = [...defaultLocations, ...addedLocations];
                  return ListView.separated(
                    itemCount: allLocations.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final location = allLocations[index];
                      final showDelete = _isEditMode && !location.isPrimary;
                      return SavedLocationTile(
                        location: location,
                        trailing: showDelete
                            ? IconButton(
                                tooltip: localizations.deleteLocation,
                                icon: Icon(Icons.delete_outline, color: AppColors.brownBg),
                                onPressed: () {
                                  _deleteLocation(
                                    location: location,
                                    defaultLocations: defaultLocations,
                                    addedLocations: addedLocations,
                                    localizations: localizations,
                                  );
                                },
                              )
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.cta),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const AddLocationPage()));
                },
                child: Text(
                  localizations.addNewAddress,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
