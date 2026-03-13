import 'package:flutter/material.dart';
import 'package:parent_app/features/change_request/presentation/add_location_page.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class ChangeRequestPage extends StatefulWidget {
  const ChangeRequestPage({super.key});

  @override
  State<ChangeRequestPage> createState() => _ChangeRequestPage();
}

class _ChangeRequestPage extends State<ChangeRequestPage> {
  // Pickup / Dropoff selection
  bool isPickup = true;
  // Saved addresses selection
  String selectedAddress = 'Home';
  // Date selection
  String selectedDateOption = 'Tomorrow';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
              localizations.changePickupDropoffFor,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            Text(
              localizations.changeRequestDateSubtitle,
              style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 22),
            ),
            const SizedBox(height: 18),
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
                      onTap: () => setState(() => isPickup = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isPickup ? AppColors.highlight : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(32),
                            bottomLeft: Radius.circular(32),
                          ),
                        ),
                        child: Center(child: Text(localizations.pickupLabel)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isPickup = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !isPickup ? AppColors.highlight : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                        ),
                        child: Center(child: Text(localizations.dropoffLabel)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Saved Addresses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.savedAddressesTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => AddLocationPage()));
                  },
                  child: Text(localizations.addNewAddress, style: TextStyle(color: AppColors.cta)),
                ),
              ],
            ),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text(localizations.homeAddressName),
                  subtitle: Text(localizations.homeAddressDesc),
                  trailing: selectedAddress == 'Home' ? const Icon(Icons.check) : null,
                  onTap: () => setState(() => selectedAddress = 'Home'),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text(localizations.grandmasHouseName),
                  subtitle: Text(localizations.grandmasHouseAddress),
                  trailing: selectedAddress == "Grandma's House" ? const Icon(Icons.check) : null,
                  onTap: () => setState(() => selectedAddress = "Grandma's House"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Date options
            RadioGroup<String>(
              groupValue: selectedDateOption,
              onChanged: (value) => setState(() => selectedDateOption = value!),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Text(localizations.todayMonday),
                    value: 'Today',
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  RadioListTile<String>(
                    title: Text(localizations.tomorrow),
                    value: 'Tomorrow',
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  RadioListTile<String>(
                    title: Text(localizations.specificDate),
                    value: 'Specific date',
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  RadioListTile<String>(
                    title: Text(localizations.duration),
                    value: 'Duration',
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.cta),
                onPressed: () {},
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
