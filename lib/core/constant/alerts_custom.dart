import 'package:digital_oms_sheba/core/constant/height_width.dart';
import 'package:digital_oms_sheba/core/services/device_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomMaterialAlert extends StatelessWidget {
  final String? title;
  final String message;
  final String? svgAssetPath;
  final VoidCallback? rightButtonPressed;
  final VoidCallback? leftButtonPressed;
  final String? rightButtonText;
  final String? leftButtonText;
  final TextAlign? messageAlign;
  final Color? leftButtonColor;
  final Color? rightButtonColor;

  const CustomMaterialAlert({
    super.key,
    this.title,
    required this.message,
    this.svgAssetPath,
    this.rightButtonPressed,
    this.leftButtonPressed,
    this.rightButtonText,
    this.leftButtonText,
    this.messageAlign,
    this.leftButtonColor,
    this.rightButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Rounded corners
      contentPadding: const EdgeInsets.all(20),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: AppVersionDetails(fontColor: Colors.grey.shade400),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SvgPicture.asset(svgAssetPath ?? 'assets/svg/notice.svg', height: 50, width: 50),
            ),
            Text(
              title ?? 'দুঃখিত',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const Divider(color: Colors.black45, thickness: 1, indent: 40, endIndent: 40),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              textAlign: messageAlign ?? TextAlign.center,
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        _buildButton(
          context: context,
          text: leftButtonText ?? 'বন্ধ করুন',
          color: leftButtonColor ?? const Color(0xff941b0c),
          onPressed: leftButtonPressed,
        ),
        if (rightButtonPressed != null && rightButtonText != null) ...[
          width5(),
          _buildButton(
            context: context,
            text: rightButtonText!,
            color: rightButtonColor ?? Colors.green[700]!,
            onPressed: rightButtonPressed,
          ),
        ],
      ],
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        onPressed?.call();
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

//add left / right button color
void showCustomMaterialAlert({
  required BuildContext context,
  String? title,
  required String message,
  String? svgAssetPath,
  VoidCallback? leftButtonPressed,
  VoidCallback? rightButtonPressed,
  String? rightButtonText,
  String? leftButtonText,
  TextAlign? messageAlign,
  Color? leftButtonColor,
  Color? rightButtonColor,
}) {
  showDialog(
    context: context,
    builder: (context) => CustomMaterialAlert(
      title: title,
      message: message,
      svgAssetPath: svgAssetPath,
      rightButtonPressed: rightButtonPressed,
      rightButtonText: rightButtonText,
      leftButtonPressed: leftButtonPressed,
      leftButtonText: leftButtonText,
      messageAlign: messageAlign,
      leftButtonColor: leftButtonColor,
      rightButtonColor: rightButtonColor,
    ),
  );
}
