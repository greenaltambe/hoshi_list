import 'package:flutter/material.dart';
import 'package:hoshi_list/core/utils/json.dart';

InputDecoration outlinedInputDecoration({
  IconData? icon,
  String? suffixText,
  String? hint,
}) {
  return InputDecoration(
    hintText: hint,
    suffixText: suffixText,
    suffixIcon: icon == null ? null : Icon(icon),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  );
}

/// A read-only field that opens a date picker and can be cleared.
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.hint = 'Not set',
  });

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now().clamp(firstDate, lastDate),
          firstDate: firstDate,
          lastDate: lastDate,
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: outlinedInputDecoration().copyWith(
          suffixIcon: value == null
              ? const Icon(Icons.calendar_month)
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => onChanged(null),
                ),
        ),
        child: Text(value == null ? hint : formatYmd(value!)),
      ),
    );
  }
}

extension on DateTime {
  DateTime clamp(DateTime min, DateTime max) =>
      isBefore(min) ? min : (isAfter(max) ? max : this);
}
