import 'package:flutter/material.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class ConfirmLocationButton extends StatefulWidget {
  const ConfirmLocationButton({super.key});
  @override
  State<ConfirmLocationButton> createState() => _ConfirmLocationButtonState();
}

class _ConfirmLocationButtonState extends State<ConfirmLocationButton> {
  final TextEditingController _locationNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 28),
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Text(
                    'Enter a Name For This Location',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                content: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _locationNameController,
                    decoration: InputDecoration(
                      hintText: "eg. Grandma's Home",
                      suffixIcon: IconButton.filled(
                        onPressed: () {
                          debugPrint("New Location: ${_locationNameController.text}");
                          Navigator.of(c).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                        ),
                        icon: Icon(Icons.check, color: AppColors.brownBg.withAlpha(180)),
                      ),
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
                ),
              ),
            );
          },
          child: const Text(
            'Confirm Location',
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
