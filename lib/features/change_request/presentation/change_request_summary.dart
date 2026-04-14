import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:parent_app/features/change_request/data/services/change_request_store.dart';
import 'package:parent_app/features/change_request/presentation/change_request_confirmed_page.dart';
import 'package:parent_app/features/change_request/presentation/models/change_request_payload.dart';
import 'package:parent_app/features/locations/presentation/components/saved_location_tile.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class ChangeRequestSummaryPage extends StatelessWidget {
  final ChangeRequestPayload payload;

  const ChangeRequestSummaryPage({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final selectedDateText = DateFormat('EEEE, d MMMM', locale).format(payload.selectedDate);

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
              localizations.changePickupDropoff,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            Text(
              localizations.requestSummaryFor,
              style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 22),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: payload.isPickupSelected ? AppColors.highlight : Colors.transparent,
                        borderRadius: isRtl
                            ? const BorderRadius.only(
                                topRight: Radius.circular(32),
                                bottomRight: Radius.circular(32),
                              )
                            : const BorderRadius.only(
                                topLeft: Radius.circular(32),
                                bottomLeft: Radius.circular(32),
                              ),
                      ),
                      child: Center(child: Text(localizations.pickupLabel)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: payload.isDropoffSelected ? AppColors.highlight : Colors.transparent,
                        borderRadius: isRtl
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(32),
                                bottomLeft: Radius.circular(32),
                              )
                            : const BorderRadius.only(
                                topRight: Radius.circular(32),
                                bottomRight: Radius.circular(32),
                              ),
                      ),
                      child: Center(child: Text(localizations.dropoffLabel)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              '${localizations.absenceDateTitle}: $selectedDateText',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.pickupLabel,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SavedLocationTile(location: payload.pickupLocation),
            const SizedBox(height: 14),
            Text(
              localizations.dropoffLabel,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SavedLocationTile(location: payload.dropoffLocation),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.cta),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  localizations.returnAndEdit,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.cta),
                onPressed: () {
                  ChangeRequestStore.instance.setActiveRequest(payload);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => ChangeRequestConfirmedPage(payload: payload)),
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
