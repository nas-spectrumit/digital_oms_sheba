import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:digital_oms_sheba/core/constant/custom_background.dart';
import 'package:digital_oms_sheba/core/constant/height_width.dart';
import 'package:digital_oms_sheba/core/constant/navigation_custom.dart';
import 'package:digital_oms_sheba/core/services/device_info_controller.dart';
import 'package:digital_oms_sheba/core/services/svg_preload.dart';
import 'package:digital_oms_sheba/features/auth/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                minHeight: size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 32,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Top Header Section ─────────────────────────────
                  Column(
                    children: [
                      height10(),
                      // Bangladesh Govt Pill Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: myGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: myGreen.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified, size: 15, color: Color(0xff137547)),
                            width5(),
                            Text(
                              'গণপ্রজাতন্ত্রী বাংলাদেশ সরকার',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: myGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      height16(),

                      // Ministry & App Logo
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: myGreen.withValues(alpha: 0.14),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/main_logo.png',
                          height: 76,
                          width: 76,
                          fit: BoxFit.contain,
                        ),
                      ),
                      height14(),

                      Text(
                        'খাদ্য অধিদপ্তর',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
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
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  // ── Middle Action Cards (লগইন | সাইন আপ) ────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Column(
                      children: [
                        Text(
                          'আপনার সেবাটি বেছে নিন',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        height16(),

                        // Card Button 1: লগইন
                        _buildAuthCard(
                          context: context,
                          title: 'লগইন',
                          subtitle: 'বিদ্যমান ওএমএস অ্যাকাউন্টে প্রবেশ করতে ট্যাপ করুন',
                          svgPath: SvgMyAsset.login,
                          isPrimary: true,
                          badgeText: 'সরাসরি প্রবেশ',
                          onTap: () {
                            pushPage(context, const LoginPage());
                          },
                        ),

                        height16(),

                        // Card Button 2: সাইন আপ (Nothing to do, just button placed)
                        _buildAuthCard(
                          context: context,
                          title: 'সাইন আপ',
                          subtitle: 'নতুন ওএমএস কার্ডের জন্য নিবন্ধন করুন',
                          svgPath: SvgMyAsset.beneficiaryRegistration,
                          isPrimary: false,
                          badgeText: 'নতুন সুবিধাভোগী',
                          onTap: () {
                            // Signup: nothing to do. Just place the button.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('নতুন নিবন্ধন সেবা শীঘ্রই উন্মুক্ত করা হবে।'),
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
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
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: myGreen,
                                        ),
                                      ),
                                      Text(
                                        '  |  জাতীয় কল সেন্টার: ৩৩৩',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
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
                          Text(
                            'সংস্করণ ',
                            style: TextStyle(fontSize: 9.5, color: Colors.grey.shade500),
                          ),
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
    required String svgPath,
    required bool isPrimary,
    required String badgeText,
    required VoidCallback onTap,
  }) {
    final primary = myGreen;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 54,
                  height: 54,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isPrimary ? primary.withValues(alpha: 0.1) : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    svgPath,
                    colorFilter: ColorFilter.mode(
                      isPrimary ? primary : Colors.grey.shade800,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                width14(),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isPrimary ? primary : Colors.grey.shade900,
                            ),
                          ),
                          width8(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: isPrimary ? primary.withValues(alpha: 0.12) : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isPrimary ? primary : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      height5(),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing Arrow Circle
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isPrimary ? primary : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: isPrimary ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget width8() => const SizedBox(width: 8);
}
