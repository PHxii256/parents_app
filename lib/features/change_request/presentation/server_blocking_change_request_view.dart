import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parent_app/features/change_request/data/change_request_repository.dart';
import 'package:parent_app/features/locations/data/models/saved_location.dart';
import 'package:parent_app/features/locations/data/services/saved_locations_store.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

/// Same chrome as [ChangeRequestConfirmedPage]: card + undo-style button (calls cancel on server).
/// Never shows raw location ids; resolves names/addresses from [SavedLocationsStore] when possible.
class ServerBlockingChangeRequestView extends StatelessWidget {
  const ServerBlockingChangeRequestView({
    super.key,
    required this.active,
    required this.cancelling,
    required this.onCancel,
  });

  final LocationChangeRequestData active;
  final bool cancelling;
  final VoidCallback onCancel;

  static SavedLocation? _findLocation(List<SavedLocation> locations, String? id) {
    if (id == null || id.isEmpty) return null;
    for (final l in locations) {
      if (l.id == id) return l;
    }
    return null;
  }

  static String _formattedTargetDate(BuildContext context, String? targetDate) {
    if (targetDate == null || targetDate.isEmpty) return '';
    final parsed = DateTime.tryParse(targetDate);
    if (parsed == null) return targetDate;
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('EEEE, d MMMM', locale).format(parsed);
  }

  List<Widget> _stopBlocks(AppLocalizations l10n, String? changeType, SavedLocation? loc) {
    final ct = changeType?.trim().toLowerCase() ?? '';
    final name = (loc?.name ?? '').trim();
    final addr = (loc?.addressLine ?? '').trim();
    final title = name.isNotEmpty ? name : '—';

    List<Widget> block(String label) => [
      Text('$label: $title'),
      if (addr.isNotEmpty) Text(addr),
      const SizedBox(height: 10),
    ];

    if (ct == 'pickup') return block(l10n.pickupLabel);
    if (ct == 'dropoff') return block(l10n.dropoffLabel);
    if (ct == 'both') return [...block(l10n.pickupLabel), ...block(l10n.dropoffLabel)];
    if (changeType != null && changeType.trim().isNotEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(changeType.trim()),
        ),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateText = _formattedTargetDate(context, active.targetDate);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Text(
            l10n.requestConfirmedTitle,
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
              child: ValueListenableBuilder<List<SavedLocation>>(
                valueListenable: SavedLocationsStore.instance.addedLocations,
                builder: (context, locations, _) {
                  final loc = _findLocation(locations, active.newLocationId);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.lastRequestTitle,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      ..._stopBlocks(l10n, active.changeType, loc),
                      if (dateText.isNotEmpty)
                        Text('${l10n.busStopChangeDateTitle}: $dateText'),
                    ],
                  );
                },
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.cta),
              onPressed: cancelling || active.id.isEmpty ? null : onCancel,
              child: cancelling
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      l10n.undoLastRequest,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
