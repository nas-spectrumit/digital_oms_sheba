import 'package:digital_oms_sheba/core/constant/custom_textbox.dart';
import 'package:digital_oms_sheba/core/constant/helper_class.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final bool optional;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime)? onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.optional = false,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required TextEditingController controller,
    DateTime? firstDate,
    DateTime? lastDate,
    void Function(DateTime)? onDateSelected,
  }) async {
    final DateTime resolvedLastDate = lastDate ?? DateTime.now().subtract(const Duration(days: 15 * 365));
    final DateTime resolvedFirstDate = firstDate ?? DateTime(1950);
    DateTime initialDate = resolvedLastDate;

    if (controller.text.isNotEmpty) {
      final DateTime? parsed = HelperClass.parseDate(controller.text);
      if (parsed != null && !parsed.isBefore(resolvedFirstDate) && !parsed.isAfter(resolvedLastDate)) {
        initialDate = parsed;
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: resolvedFirstDate,
      lastDate: resolvedLastDate,
    );

    if (picked != null) {
      controller.text = HelperClass.convertDate(picked.toString());
      debugPrint('Selected date: ${controller.text}');
      if (onDateSelected != null) {
        onDateSelected(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText ?? 'Select date',
      optional: optional,
      readOnly: true,
      suffixIcon: const Icon(Icons.calendar_month),
      onTap: () => show(
        context,
        controller: controller,
        firstDate: firstDate,
        lastDate: lastDate,
        onDateSelected: onDateSelected,
      ),
    );
  }
}
