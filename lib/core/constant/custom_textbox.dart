import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final bool readOnly;
  final Color? prefixIconColor;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final List<BoxShadow>? boxShadow;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? inputDecoration;
  final bool optional;

  const CustomTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIconColor,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
    this.contentPadding,
    this.labelStyle,
    this.hintStyle,
    this.textStyle,
    this.boxShadow,
    this.inputFormatters,
    this.inputDecoration,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    //Need to a text title on upside of the textbox, whre label text is shown

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Text.rich(
            TextSpan(
              text: '$labelText ',
              style: textTheme(context).bodyMedium,
              children: [
                if (!optional)
                  TextSpan(
                    text: '*',
                    style: textTheme(context).bodyMedium?.copyWith(color: Colors.red, fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: fillColor ?? Colors.white,
            borderRadius: BorderRadius.circular(borderRadius ?? 16),
            boxShadow:
                boxShadow ?? [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: TextFormField(
            autofocus: false,
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            onTap: onTap,
            autovalidateMode: AutovalidateMode.onUserInteraction, // 👈 Key line
            maxLines: maxLines,
            minLines: minLines,
            enabled: enabled,
            readOnly: readOnly,
            inputFormatters: inputFormatters,
            style: textStyle ?? textTheme(context).bodyMedium,
            decoration:
                inputDecoration ??
                InputDecoration(
                  // labelText: labelText,
                  hintText: hintText,
                  labelStyle: labelStyle ?? textTheme(context).bodySmall,
                  hintStyle: hintStyle ?? textTheme(context).bodySmall,
                  prefixIcon: prefixIcon != null
                      ? Icon(prefixIcon, color: prefixIconColor ?? Colors.green.shade700)
                      : null,
                  suffixIcon: suffixIcon,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 16),
                    borderSide: borderColor != null ? BorderSide(color: borderColor!) : BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 16),
                    borderSide: borderColor != null
                        ? BorderSide(color: borderColor!)
                        : BorderSide(color: Colors.grey.withValues(alpha: .3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 16),
                    borderSide: BorderSide(color: borderColor ?? Colors.blue.shade400, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 16),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 16),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  filled: true,
                  fillColor: fillColor ?? Colors.white,
                  contentPadding: contentPadding ?? const EdgeInsets.all(10),
                ),
          ),
        ),
      ],
    );
  }
}
