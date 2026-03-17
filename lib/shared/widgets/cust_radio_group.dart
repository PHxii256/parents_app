import 'package:flutter/material.dart';

final class CustRadioOption<T> {
  final String label;
  final T value;

  const CustRadioOption({required this.label, required this.value});
}

class CustRadioGroup<T> extends StatefulWidget {
  const CustRadioGroup({
    required this.options,
    required this.initialValue,
    this.onChanged,
    super.key,
  });

  final List<CustRadioOption<T>> options;
  final T initialValue;
  final ValueChanged<T>? onChanged;

  @override
  State<CustRadioGroup<T>> createState() => _CustRadioGroupState<T>();
}

class _CustRadioGroupState<T> extends State<CustRadioGroup<T>> {
  late T _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: _selectedValue,
      onChanged: (value) {
        if (value == null) {
          return;
        }
        setState(() => _selectedValue = value);
        widget.onChanged?.call(value);
      },
      child: Column(
        children: widget.options
            .map(
              (option) => RadioListTile<T>(
                title: Text(option.label),
                value: option.value,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            )
            .toList(),
      ),
    );
  }
}
