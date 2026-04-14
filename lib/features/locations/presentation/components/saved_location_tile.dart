import 'package:flutter/material.dart';
import 'package:parent_app/features/locations/data/models/saved_location.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class SavedLocationTile extends StatelessWidget {
  final SavedLocation location;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SavedLocationTile({
    super.key,
    required this.location,
    this.selected = false,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final primaryColor = AppColors.ctaDark;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.ctaDark : AppColors.mutedBgDark,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.mutedBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.home_outlined, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            location.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                          ),
                        ),
                        if (location.isPrimary) ...[
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              "(${localizations.primaryLocationLabel})",
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      location.addressLine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppColors.onSurfaceDark.withAlpha(190), fontSize: 17),
                    ),
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (selected)
                Icon(Icons.check_circle, color: AppColors.ctaDark),
            ],
          ),
        ),
      ),
    );
  }
}
