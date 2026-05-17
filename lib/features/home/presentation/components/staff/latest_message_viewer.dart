import 'package:flutter/material.dart';
import 'package:parent_app/features/absence/data/student_data.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class LatestMessageViewer extends StatelessWidget {
  final StudentLatestMessage? latestMessage;

  const LatestMessageViewer({super.key, this.latestMessage});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final snippet = latestMessage;
    final style = TextStyle(color: AppColors.brownBg);

    final decoration = BoxDecoration(
      color: AppColors.mutedBg,
      borderRadius: BorderRadius.circular(22),
    );

    if (snippet == null || snippet.trimmedContent.isEmpty) {
      return DecoratedBox(
        decoration: decoration,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('${localizations.noNewMessages}.', style: style),
          ),
        ),
      );
    }

    final clock = DateTime.now();
    final body = snippet.trimmedContent;
    final suffix = snippet.formattedRelativeSuffix(clock);

    return DecoratedBox(
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  primary: false,
                  clipBehavior: Clip.hardEdge,
                  child: Text(
                    body,
                    style: style,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              if (suffix.isNotEmpty)
                Text(
                  suffix,
                  style: style,
                  maxLines: 1,
                  softWrap: false,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
