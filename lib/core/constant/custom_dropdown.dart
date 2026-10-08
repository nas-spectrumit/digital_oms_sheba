import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdown2 extends StatelessWidget {
  final List<DropdownItem> items;
  final String hint;
  final void Function(dynamic)? onChanged;
  final dynamic value;
  final Color? fillColor;

  const CustomDropdown2({
    super.key,
    required this.items,
    required this.onChanged,
    required this.hint,
    this.value,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    bool hasItems = items.isNotEmpty;
    bool hasValue = value != null;

    return Container(
      height: 43,
      decoration: BoxDecoration(
        color: hasItems ? fillColor ?? Colors.white : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: !hasItems
              ? Colors.grey.withValues(alpha: 0.15)
              : hasValue
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: Text(
            hint.isNotEmpty ? hint : 'Select',
            style: textTheme(context).bodyMedium!.copyWith(color: Colors.grey.shade700),
          ),
          isExpanded: true,
          items: hasItems ? items : null,
          onChanged: hasItems ? onChanged : null,
          iconStyleData: IconStyleData(
            icon: Icon(
              hasItems ? Icons.keyboard_arrow_down_rounded : Icons.block_rounded,
              color: !hasItems
                  ? Colors.grey.shade400
                  : hasValue
                  ? Colors.green.shade600
                  : Colors.grey.shade700,
            ),
            iconSize: 24,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4)),
              ],
            ),
            elevation: 0,
            offset: const Offset(0, -4),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: WidgetStateProperty.all(6),
              thumbVisibility: WidgetStateProperty.all(true),
              thumbColor: WidgetStateProperty.all(Colors.grey.withValues(alpha: 0.3)),
            ),
          ),
          buttonStyleData: const ButtonStyleData(padding: EdgeInsets.symmetric(horizontal: 16), height: 48),
          menuItemStyleData: MenuItemStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.blue.withValues(alpha: 0.06);
              }
              if (states.contains(WidgetState.focused)) {
                return Colors.blue.withValues(alpha: 0.08);
              }
              return null;
            }),
          ),
        ),
      ),
    );
  }
}
