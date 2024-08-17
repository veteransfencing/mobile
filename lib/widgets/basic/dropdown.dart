import 'package:flutter/material.dart';

typedef DropdownCallback = void Function(DropdownOption);

class DropdownOption {
  final String value;
  final String label;
  const DropdownOption(this.value, this.label);
}

class Dropdown extends StatelessWidget {
  final List<DropdownOption> options;
  final String value;
  final DropdownCallback callback;
  final bool disabled;

  const Dropdown(
      {super.key, required this.options, required this.value, required this.callback, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        items: options.map<DropdownMenuItem<String>>((DropdownOption value) {
          return DropdownMenuItem(value: value.value, child: Text(value.label));
        }).toList(),
        onChanged: disabled ? null : _onChanged,
        value: value);
  }

  void _onChanged(String? value) {
    for (var option in options) {
      if (option.value == value) {
        callback(option);
        break;
      }
    }
  }
}
