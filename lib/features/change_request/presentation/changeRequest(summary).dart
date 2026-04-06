import 'package:flutter/material.dart';
import 'package:parent_app/features/change_request/presentation/add_location_page.dart';
import 'package:parent_app/features/change_request/presentation/change_request_page.dart';
import 'package:parent_app/features/change_request/presentation/components/date_radio_group.dart';
import 'package:parent_app/features/home/presentation/components/home_body.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

import '../../absence/presentation/absence_page.dart';

class ChangeRequestSummaryPage extends StatefulWidget {
  const ChangeRequestSummaryPage({super.key});

  @override
  State<ChangeRequestSummaryPage> createState() => _ChangeRequestPage();
}

class _ChangeRequestPage extends State<ChangeRequestSummaryPage> {
  // Pickup / Dropoff selection
  bool isPickup = true;

  // Saved addresses selection
  String selectedAddress = 'Home';


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

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
              localizations.requestSummaryFor,
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
                          color: isPickup
                              ? AppColors.highlight
                              : Colors.transparent,
                          borderRadius: isRtl
                              ? BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  bottomRight: Radius.circular(32),
                                )
                              : BorderRadius.only(
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
                          color: !isPickup
                              ? AppColors.highlight
                              : Colors.transparent,
                          borderRadius: isRtl
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  bottomLeft: Radius.circular(32),
                                )
                              : BorderRadius.only(
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

         //   const SizedBox(height: 20),

            // Saved Addresses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.savedAddressesTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

              ],
            ),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text(localizations.homeAddressName),
                  subtitle: Text(localizations.homeAddressDesc),
                  trailing: selectedAddress == 'Home'
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () => setState(() => selectedAddress = 'Home'),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text(localizations.grandmasHouseName),
                  subtitle: Text(localizations.grandmasHouseAddress),
                  trailing: selectedAddress == "Grandma's House"
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () =>
                      setState(() => selectedAddress = "Grandma's House"),
                ),
              ],
            ),


            const SizedBox(height: 250),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.cta),
                onPressed: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(MaterialPageRoute(builder: (_) => ChangeRequestPage()));
                },
                child: Text(
                  localizations.returnAndEdit,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.cta),
                onPressed: () {
                  //send a request to backend and show snack bar that request is accepted or not
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => const HomeBody()),
                    ModalRoute.withName('/'),
                  );
                },
                child: Text(
                  localizations.doneButton,
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
