import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:digital_oms_sheba/core/constant/custom_background.dart';
import 'package:digital_oms_sheba/core/constant/custom_textbox.dart';
import 'package:digital_oms_sheba/core/constant/height_width.dart';
import 'package:digital_oms_sheba/core/constant/navigation_custom.dart';
import 'package:digital_oms_sheba/core/services/device_info_controller.dart';
import 'package:digital_oms_sheba/features/user/user_dashboard_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Static UI: direct login navigation to user dashboard as requested
    pushAndRemoveAll(context, const UserDashboardPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: myGreen, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'লগইন',
          style: TextStyle(
            color: Colors.grey.shade900,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                height10(),

                // Logo with subtle badge
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: myGreen.withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/main_logo.png',
                    height: 68,
                    width: 68,
                    fit: BoxFit.contain,
                  ),
                ),
                height14(),

                Text(
                  'ওএমএস সেবা পোর্টালে স্বাগতম',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: myGreen,
                  ),
                ),
                height5(),
                Text(
                  'আপনার ইউজারনেম এবং পাসওয়ার্ড দিয়ে প্রবেশ করুন',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                height25(),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username Input
                      CustomTextField(
                        controller: _usernameController,
                        labelText: 'ইউজারনেম / মোবাইল নম্বর',
                        hintText: 'উদা: 017XXXXXXXX বা ইউজারনেম',
                        prefixIcon: Icons.person_outline_rounded,
                        prefixIconColor: myGreen,
                        keyboardType: TextInputType.text,
                      ),
                      height18(),

                      // Password Input
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'পাসওয়ার্ড',
                        hintText: 'আপনার পাসওয়ার্ড লিখুন',
                        prefixIcon: Icons.lock_outline_rounded,
                        prefixIconColor: myGreen,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      height12(),

                      // Remember Me & Forgot Password Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: Checkbox(
                                  value: _rememberMe,
                                  activeColor: myGreen,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  onChanged: (val) {
                                    setState(() {
                                      _rememberMe = val ?? false;
                                    });
                                  },
                                ),
                              ),
                              width8(),
                              Text(
                                'সংরক্ষণ করুন',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('পাসওয়ার্ড পুনরুদ্ধারের জন্য ওএমএস ডিলারের সাথে যোগাযোগ করুন।'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'পাসওয়ার্ড ভুলে গেছেন?',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: myGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                      height24(),

                      // Login Button (Navigates directly to dashboard on click)
                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 2,
                          shadowColor: myGreen.withValues(alpha: 0.4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.login_rounded, size: 20, color: Colors.white),
                            width8(),
                            const Text(
                              'লগইন করুন',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                height20(),

                // Govt Helpline Notice
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: myGreen.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: myGreen.withValues(alpha: 0.18)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: myGreen, size: 20),
                      width10(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'সাহায্য ও তথ্য সেবা',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: myGreen,
                              ),
                            ),
                            height2(),
                            Text(
                              'লগইন সংক্রান্ত কোনো সমস্যায় আপনার এলাকার উপজেলা খাদ্য কর্মকর্তা বা ডিলারের সাথে যোগাযোগ করুন অথবা হেল্পলাইন ১৬২৫১-এ কল দিন।',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey.shade700,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                height25(),

                // Version and copyright
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'খাদ্য অধিদপ্তর • সংস্করণ ',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                    ),
                    AppVersionDetails(fontColor: Colors.grey.shade600, fontSize: 10),
                  ],
                ),
                height10(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget width8() => const SizedBox(width: 8);
}
