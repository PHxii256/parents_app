import 'package:flutter/material.dart';
import 'package:parent_app/features/students/presentation/components/cust_checkbox_group.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class StudentPageTileStatus extends StatefulWidget {
  final String studentName;

  const StudentPageTileStatus({super.key, required this.studentName});

  @override
  State<StudentPageTileStatus> createState() => _StudentPageTileStatusState();
}

class _StudentPageTileStatusState extends State<StudentPageTileStatus> {
  bool _boardedBus = false;
  bool _droppedOff = false;

  Future<bool> _confirmStatusChange({required String actionText}) async {
    final localizations = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(localizations.statusConfirmTitle),
          content: Text(
            '${localizations.statusConfirmQuestion(widget.studentName, actionText)}\n\n${localizations.statusParentNotificationNotice}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(localizations.commonCancel),
            ),

            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(localizations.commonConfirm),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _onBoardedBusChanged(bool nextValue) async {
    final localizations = AppLocalizations.of(context)!;
    final boardedBusAction = nextValue
        ? localizations.statusActionBoardedBusTrue
        : localizations.statusActionBoardedBusFalse;
    final confirmed = await _confirmStatusChange(actionText: boardedBusAction);
    if (!confirmed || !mounted) {
      return;
    }

    setState(() {
      _boardedBus = nextValue;
      if (!_boardedBus) {
        _droppedOff = false;
      }
    });
  }

  Future<void> _onDroppedOffChanged(bool nextValue) async {
    final localizations = AppLocalizations.of(context)!;
    final droppedOffAction = nextValue
        ? localizations.statusActionDroppedOffTrue
        : localizations.statusActionDroppedOffFalse;
    final confirmed = await _confirmStatusChange(actionText: droppedOffAction);
    if (!confirmed || !mounted) {
      return;
    }

    setState(() {
      _droppedOff = nextValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 6,
      children: [
        IconBox(icon: Icons.info_outline, height: 72, iconSize: 24, width: 48),
        Expanded(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustCheckboxGroup(
                title: localizations.studentBoardedBusLabel,
                value: _boardedBus,
                onChanged: _onBoardedBusChanged,
              ),
              CustCheckboxGroup(
                title: localizations.studentDroppedOffLabel,
                value: _droppedOff,
                enabled: _boardedBus,
                onChanged: _onDroppedOffChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
