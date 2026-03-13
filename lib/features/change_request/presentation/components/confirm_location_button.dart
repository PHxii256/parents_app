import 'package:flutter/material.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class ConfirmLocationButton extends StatefulWidget {
  const ConfirmLocationButton({super.key});
  @override
  State<ConfirmLocationButton> createState() => _ConfirmLocationButtonState();
}

class _ConfirmLocationButtonState extends State<ConfirmLocationButton> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _locationAdressLineController = TextEditingController();

  @override
  void dispose() {
    _locationNameController.dispose();
    _locationAdressLineController.dispose();
    super.dispose();
  }

  void submitLocation(BuildContext c) {
    // to:do call a method on a bloc to save it to the backend
    Navigator.of(c).pop();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isValid = _formKey.currentState?.validate() ?? false;
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
                    onPressed: isValid ? () => submitLocation : null,
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
                          controller: _locationAdressLineController,
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
            );
          },
          child: Text(
            localizations.confirmLocationButton,
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
