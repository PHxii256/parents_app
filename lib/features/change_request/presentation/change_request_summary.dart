import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/features/change_request/data/change_request_repository.dart';
import 'package:parent_app/features/change_request/data/services/change_request_store.dart';
import 'package:parent_app/features/change_request/presentation/change_request_confirmed_page.dart';
import 'package:parent_app/features/change_request/presentation/models/change_request_payload.dart';
import 'package:parent_app/features/locations/presentation/components/saved_location_tile.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

/// Maps UI toggles to API `change_type` (`pickup` | `dropoff` | `both`).
String changeRequestApiChangeType(ChangeRequestPayload payload) {
  if (payload.isPickupSelected && payload.isDropoffSelected) return 'both';
  if (payload.isPickupSelected) return 'pickup';
  return 'dropoff';
}

class ChangeRequestSummaryPage extends StatefulWidget {
  final ChangeRequestPayload payload;

  const ChangeRequestSummaryPage({super.key, required this.payload});

  @override
  State<ChangeRequestSummaryPage> createState() => _ChangeRequestSummaryPageState();
}

class _ChangeRequestSummaryPageState extends State<ChangeRequestSummaryPage> {
  bool _submitting = false;

  Future<void> _onDone() async {
    if (_submitting) return;
    final payload = widget.payload;
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    if (!ApiConfig.useRealApi) {
      ChangeRequestStore.instance.setActiveRequest(payload);
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => ChangeRequestConfirmedPage(payload: payload)),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final repo = ChangeRequestRepository();
      await repo.submitRequest(
        targetDate: payload.selectedDate,
        changeType: changeRequestApiChangeType(payload),
        locationId: payload.requestedLocation.id,
      );
      if (!mounted) return;
      ChangeRequestStore.instance.setActiveRequest(payload);
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => ChangeRequestConfirmedPage(payload: payload)),
      );
    } on DioException catch (e) {
      if (!mounted) return;
      final msg = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            (msg != null && msg.isNotEmpty) ? msg : localizations.changeRequestSubmitError,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(localizations.changeRequestSubmitError)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final payload = widget.payload;
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
                onPressed: _submitting ? null : () => Navigator.of(context).pop(),
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
                onPressed: _submitting ? null : _onDone,
                child: _submitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
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
