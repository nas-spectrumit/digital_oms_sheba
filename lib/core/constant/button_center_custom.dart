import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:digital_oms_sheba/core/constant/height_width.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CenterActionButton extends StatelessWidget {
  final dynamic icon;
  final bool isSvg;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const CenterActionButton({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isSvg = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: primaryColor(context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: isSvg
                        ? SvgPicture.asset(icon, height: 60, width: 60)
                        : Icon(icon, size: 48, color: primaryColor(context)),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      title,
                      style: textTheme(context).titleMedium!.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: textTheme(context).bodyMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                  height20(),
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_forward_ios, color: primaryColor(context), size: 34),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
