import 'package:flutter/material.dart';
import 'package:parent_app/features/students/presentation/components/cust_checkbox_group.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class StudentPageTileStatus extends StatefulWidget {
  final String studentName;
  final bool boardedBus;
  final bool droppedOff;
  final ValueChanged<bool>? onBoardedChanged;
  final ValueChanged<bool>? onDroppedOffChanged;

  const StudentPageTileStatus({
    super.key,
    required this.studentName,
    this.boardedBus = false,
    this.droppedOff = false,
    this.onBoardedChanged,
    this.onDroppedOffChanged,
  });

  @override
  State<StudentPageTileStatus> createState() => _StudentPageTileStatusState();
}

class _StudentPageTileStatusState extends State<StudentPageTileStatus> {
  late bool _boardedBus;
  late bool _droppedOff;

  @override
  void initState() {
    super.initState();
    _boardedBus = widget.boardedBus;
    _droppedOff = widget.droppedOff;
  }

  @override
  void didUpdateWidget(covariant StudentPageTileStatus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.boardedBus != widget.boardedBus) {
      _boardedBus = widget.boardedBus;
    }
    if (oldWidget.droppedOff != widget.droppedOff) {
      _droppedOff = widget.droppedOff;
    }
  }

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
    widget.onBoardedChanged?.call(nextValue);
    if (!nextValue) {
      widget.onDroppedOffChanged?.call(false);
    }
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
    widget.onDroppedOffChanged?.call(nextValue);
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
