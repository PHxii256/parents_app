import 'package:flutter/material.dart';
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
          // ✅ Add to cubit so ChangeRequestPage list updates
          context.read<ChangeLocationCubit>().addAddress(locationName, addressLine);

          // Close dialog
          Navigator.of(c).pop();
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
              fontSize: 18,
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
  final TextEditingController _locationAddressLineController = TextEditingController();

  @override
  void dispose() {
    _locationNameController.dispose();
    _locationAddressLineController.dispose();
    super.dispose();
  }

  void submitLocation(BuildContext dialogContext) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    SavedLocationsStore.instance.addLocation(
      name: _locationNameController.text,
      addressLine: _locationAddressLineController.text,
    );

    Navigator.of(dialogContext).pop();
    if (mounted) {
      Navigator.of(context).pop();
    }
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
          onPressed: () {
            showDialog(
              context: context,
              builder: (c) => AlertDialog(
                titlePadding: EdgeInsets.fromLTRB(16, 28, 16, 0),
                contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                actionsPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),

                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    localizations.addLocationDetailsTitle,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => submitLocation(c),
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
                              borderSide: BorderSide(width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
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
                              borderSide: BorderSide(width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
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