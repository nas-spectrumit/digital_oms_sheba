import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:digital_oms_sheba/core/constant/custom_background.dart';
import 'package:digital_oms_sheba/core/constant/height_width.dart';
import 'package:digital_oms_sheba/core/constant/navigation_custom.dart';
import 'package:digital_oms_sheba/core/services/device_info_controller.dart';
import 'package:digital_oms_sheba/core/services/svg_preload.dart';
import 'package:digital_oms_sheba/features/auth/information/view/information_list_page.dart';
import 'package:digital_oms_sheba/features/auth/login/view/login_page.dart';
import 'package:digital_oms_sheba/features/auth/onboarding/view/location_permission_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 32,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Top Header Section ─────────────────────────────
                  Column(
                    children: [
                      height16(),

                      // Ministry & App Logo
                      ClipOval(
                        child: Image.asset('assets/images/main_logo.png', height: 76, width: 76, fit: BoxFit.contain),
                      ),
                      height14(),

                      Text(
                        'খাদ্য অধিদপ্তর',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey.shade800),
                      ),
                      height2(),
                      Text(
                        'ডিজিটাল ওএমএস সেবা',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: myGreen,
                          letterSpacing: -0.3,
                        ),
                      ),
                      height5(),
                      Text(
                        'সহজ ও স্বচ্ছ উপায়ে ন্যায্যমূল্যের খাদ্যপণ্য প্রাপ্তির ডিজিটাল প্ল্যাটফর্ম',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                      ),
                    ],
                  ),

                  // ── Middle Action Cards (লগইন | তথ্য বাতায়ন) ────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Column(
                      children: [
                        Text(
                          'আপনার সেবাটি বেছে নিন',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.grey.shade800),
                        ),
                        height16(),

                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildAuthCard(
                                  context: context,
                                  title: 'লগইন',
                                  subtitle: 'বিদ্যমান অ্যাকাউন্টে প্রবেশ করুন',
                                  svgPath: SvgMyAsset.login,
                                  isPrimary: true,
                                  onTap: () async {
                                    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                                    LocationPermission permission = await Geolocator.checkPermission();
                                    
                                    if (!serviceEnabled || permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
                                      if (context.mounted) {
                                        pushPage(context, const LocationPermissionPage());
                                      }
                                    } else {
                                      if (context.mounted) {
                                        pushPage(context, const LoginPage());
                                      }
                                    }
                                  },
                                ),
                              ),
                              width16(),
                              Expanded(
                                child: _buildAuthCard(
                                  context: context,
                                  title: 'তথ্য বাতায়ন',
                                  subtitle: 'গুরুত্বপূর্ণ তথ্য ও সেবাসমূহ',
                                  iconData: Icons.info_outline_rounded,
                                  isPrimary: false,
                                  onTap: () {
                                    pushPage(context, const InformationListPage());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Bottom Info & Helpline ────────────────────────
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: myGreenAccent.withValues(alpha: 0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.phone_in_talk, color: myGreen, size: 18),
                            ),
                            width12(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'জরুরি সহায়তায় ওএমএস হেল্পলাইন',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  height2(),
                                  Row(
                                    children: [
                                      Text(
                                        '১৬২৫১',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: myGreen),
                                      ),
                                      Text(
                                        '  |  জাতীয় কল সেন্টার: ৩৩৩',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      height14(),
                      Text(
                        'কারিগরি সহায়তায়: খাদ্য অধিদপ্তর, বাংলাদেশ',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                      height5(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('সংস্করণ ', style: TextStyle(fontSize: 9.5, color: Colors.grey.shade500)),
                          AppVersionDetails(fontColor: Colors.grey.shade600, fontSize: 9.5),
                        ],
                      ),
                      height10(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    String? svgPath,
    IconData? iconData,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    final primary = myGreen;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPrimary ? primary.withValues(alpha: 0.5) : Colors.grey.shade300,
              width: isPrimary ? 1.6 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isPrimary ? primary.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Container
              Container(
                width: 54,
                height: 54,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isPrimary ? primary.withValues(alpha: 0.1) : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: svgPath != null
                    ? SvgPicture.asset(
                        svgPath,
                        colorFilter: ColorFilter.mode(isPrimary ? primary : Colors.grey.shade800, BlendMode.srcIn),
                      )
                    : Icon(iconData, color: isPrimary ? primary : Colors.grey.shade800, size: 26),
              ),
              height14(),
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isPrimary ? primary : Colors.grey.shade900,
                ),
                textAlign: TextAlign.center,
              ),
              height5(),
              // Subtitle
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade600, height: 1.3),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget width8() => const SizedBox(width: 8);
}
