import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:parent_app/features/locations/service/gmap_url_util.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';

class GmapsSearch extends StatefulWidget {
  final void Function(LatLng coords) cb;
  const GmapsSearch({super.key, required this.cb});

  @override
  State<GmapsSearch> createState() => _GmapsSearchState();
}

class _GmapsSearchState extends State<GmapsSearch> {
  final TextEditingController controller = TextEditingController();
  bool hasText = false;

  Future<void> _pasteText() async {
    final localizations = AppLocalizations.of(context)!;
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null) {
      // Use the pasted text, for example, set it to a TextEditingController or a Text widget
      setState(() {
        controller.text = clipboardData.text!;
        hasText = controller.text.isNotEmpty;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizations.clipboardEmptyPasteLink)));
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: SearchBar(
                    trailing: [InkWell(onTap: _pasteText, child: Icon(Icons.paste))],
                    hintText: localizations.pasteGoogleMapsLinkHint,
                    controller: controller,
                    onChanged: (value) {
                      setState(() {
                        hasText = value.isNotEmpty;
                      });
                    },
                    backgroundColor: WidgetStatePropertyAll(Theme.of(context).canvasColor),
                    elevation: WidgetStatePropertyAll(0),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                        side: BorderSide(
                          color: hasText ? AppColors.ctaDark : AppColors.mutedBgDark,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 6),
              InkWell(
                onTap: () async {
                  final coords = await parseGmapsUrl(controller.text);
                  if (coords != null) {
                    widget.cb(coords);
                    return;
                  }
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(localizations.invalidGoogleMapsLink)),
                  );
                },
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: hasText ? AppColors.cta : Colors.transparent,
                    border: Border.all(
                      width: 4,
                      color: hasText ? AppColors.ctaDark : AppColors.mutedBgDark,
                    ),
                    borderRadius: BorderRadiusGeometry.circular(8),
                  ),
                  child: Icon(
                    Icons.search,
                    color: hasText ? Colors.white : AppColors.highlightText,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 6, 0, 0),
            child: Text(
              localizations.gmapsExampleHint,
              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }
}
