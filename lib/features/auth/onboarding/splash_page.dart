import 'dart:async';
import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:digital_oms_sheba/core/constant/custom_background.dart';
import 'package:digital_oms_sheba/core/constant/height_width.dart';
import 'package:digital_oms_sheba/core/constant/navigation_custom.dart';
import 'package:digital_oms_sheba/core/services/device_info_controller.dart';
import 'package:digital_oms_sheba/features/auth/onboarding/welcome_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
    );

    _animController.forward();

    // Navigate to WelcomePage after 2.2 seconds
    _navTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        pushReplacementPage(context, const WelcomePage());
      }
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top govt indicator
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: myGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: myGreen.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, size: 16, color: Color(0xff137547)),
                        width5(),
                        Text(
                          'গণপ্রজাতন্ত্রী বাংলাদেশ সরকার',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: myGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Center animated brand section
                FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // App Logo with subtle halo
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: myGreen.withValues(alpha: 0.15),
                                  blurRadius: 28,
                                  spreadRadius: 6,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/main_logo.png',
                              height: 110,
                              width: 110,
                              fit: BoxFit.contain,
                            ),
                          ),
                          height20(),

                          // Title and Ministry Info
                          Text(
                            'খাদ্য মন্ত্রণালয় • খাদ্য অধিদপ্তর',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          height5(),
                          Text(
                            'ডিজিটাল ওএমএস সেবা',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: myGreen,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          height10(),
                          Container(
                            width: 60,
                            height: 3,
                            decoration: BoxDecoration(
                              color: const Color(0xffe3bb00),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          height12(),
                          Text(
                            'স্বচ্ছতা ও সমতাভিত্তিক খাদ্য সহায়তা বিতরণ কার্যক্রম',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom loading & version info
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.8,
                          valueColor: AlwaysStoppedAnimation<Color>(myGreen),
                        ),
                      ),
                      height16(),
                      Text(
                        'অ্যাপ লোড হচ্ছে, অনুগ্রহ করে অপেক্ষা করুন...',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      height8(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'সংস্করণ ',
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                          ),
                          AppVersionDetails(fontColor: Colors.grey.shade600, fontSize: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget height8() => const SizedBox(height: 8);
}
