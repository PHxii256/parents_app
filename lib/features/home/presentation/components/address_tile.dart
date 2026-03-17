import 'package:flutter/material.dart';
import 'package:parent_app/core/utils/truncate_text.dart';
import 'package:parent_app/features/change_request/presentation/change_request_page.dart';
import 'package:parent_app/shared/theme/app_colors.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class AddressTile extends StatelessWidget {
  final String addressName;
  final String addressDesc;
  final String? trailing;
  const AddressTile({
    super.key,
    required this.addressName,
    required this.addressDesc,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 12,
      contentPadding: EdgeInsets.all(0),
      leading: IconBox(icon: Icons.home, width: 48, height: 48),
      trailing: InkWell(
        child: Icon(Icons.edit, size: 22),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangeRequestPage()));
        },
      ),
      title: SizedBox(
        child: Column(
          spacing: 2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 6,
              children: [
                Text(
                  addressName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, height: 0.95),
                ),
                trailing != null
                    ? Text(
                        trailing!,
                        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15, height: 0.95),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            Text(
              truncateText(addressDesc),
              style: TextStyle(color: AppColors.highlightText, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
