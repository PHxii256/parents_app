import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/guardian/data/guardian_repository.dart';
import 'package:parent_app/features/locations/data/models/saved_location.dart';
import 'package:parent_app/features/locations/data/services/saved_locations_store.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';
import '../../cubit/change_location_cubit.dart';

class ConfirmLocationButton extends StatelessWidget {
  const ConfirmLocationButton({super.key});

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) => _LocationDialog(
        onSubmit: (String locationName, String addressLine) {
          final location = SavedLocationsStore.instance.addLocation(
            name: locationName,
            addressLine: addressLine,
          );
          GuardianRepository().createLocation(
            SavedLocation(
              id: location.id,
              name: location.name,
              addressLine: location.addressLine,
            ),
          );

          // Add to cubit for existing listeners
          context.read<ChangeLocationCubit>().addAddress(
            locationName,
            addressLine,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Positioned(
      left: 80,
      right: 80,
      bottom: 12,
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.cta),
          onPressed: () => _showLocationDialog(context),
          child: Text(
            localizations.confirmLocationButton,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Dialog Widget
// ─────────────────────────────────────────────────────────────

class _LocationDialog extends StatefulWidget {
  final void Function(String locationName, String addressLine) onSubmit;

  const _LocationDialog({required this.onSubmit});

  @override
  State<_LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<_LocationDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _locationAddressLineController =
      TextEditingController();

  @override
  void dispose() {
    _locationNameController.dispose();
    _locationAddressLineController.dispose();
    super.dispose();
  }

  void submitLocation() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    widget.onSubmit(
      _locationNameController.text.trim(),
      _locationAddressLineController.text.trim(),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          localizations.addLocationDetailsTitle,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      actions: [
        TextButton(
          onPressed: submitLocation,
          child: Text(localizations.doneButton),
        ),
      ],
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _locationNameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return localizations.locationNameRequired;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: localizations.locationNameLabel,
                  hintText: localizations.locationNameHint,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: AppColors.brownBg),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationAddressLineController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: localizations.addressOptionalLabel,
                  hintText: localizations.addressOptionalHint,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: AppColors.brownBg),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
