import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parent_app/features/change_request/data/services/change_request_store.dart';
import 'package:parent_app/features/change_request/presentation/models/change_request_payload.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class ChangeRequestConfirmedPage extends StatelessWidget {
  final ChangeRequestPayload payload;
  final VoidCallback? onUndo;

  const ChangeRequestConfirmedPage({super.key, required this.payload, this.onUndo});

  void _handleUndo(BuildContext context) {
    ChangeRequestStore.instance.clear();
    if (onUndo != null) {
      onUndo!();
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final dateText = DateFormat('EEEE, d MMMM', locale).format(payload.selectedDate);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          localizations.requestTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Text(
              localizations.requestConfirmedTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.mutedBgDark),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.lastRequestTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text('${localizations.pickupLabel}: ${payload.pickupLocation.name}'),
                    Text(payload.pickupLocation.addressLine),
                    const SizedBox(height: 10),
                    Text('${localizations.dropoffLabel}: ${payload.dropoffLocation.name}'),
                    Text(payload.dropoffLocation.addressLine),
                    const SizedBox(height: 10),
                    Text('${localizations.absenceDateTitle}: $dateText'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.cta),
                onPressed: () => _handleUndo(context),
                child: Text(
                  localizations.undoLastRequest,
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
