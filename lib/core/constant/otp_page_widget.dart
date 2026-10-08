import 'dart:async';

import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:digital_oms_sheba/core/constant/mask_number.dart';
import 'package:digital_oms_sheba/core/services/svg_preload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';

// ════════════════════════════════════════════════
//  Reusable OTP Page
//  Required params: phoneNumber, otpController, onSubmit
//  Optional params: resendSeconds, onResend, onCompleted
// ════════════════════════════════════════════════

class OtpPageWidget extends StatefulWidget {
  final String phoneNumber;
  final TextEditingController otpController;
  final VoidCallback onSubmit;
  final int resendSeconds;
  final VoidCallback? onResend;
  final ValueChanged<String>? onCompleted;

  const OtpPageWidget({
    super.key,
    required this.phoneNumber,
    required this.otpController,
    required this.onSubmit,
    this.resendSeconds = 260,
    this.onResend,
    this.onCompleted,
  });

  @override
  State<OtpPageWidget> createState() => _OtpPageWidgetState();
}

class _OtpPageWidgetState extends State<OtpPageWidget> {
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.resendSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _onResendTapped() {
    setState(() => _secondsLeft = widget.resendSeconds);
    _startTimer();
    widget.onResend?.call();
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor(context);

    final defaultTheme = PinTheme(
      width: 48,
      height: 52,
      textStyle: textTheme(context).titleMedium,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: .5), width: 1.5),
      ),
    );

    final focusedTheme = defaultTheme.copyWith(
      decoration: BoxDecoration(
        color: const Color(0xFFE6F1FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary, width: 2),
      ),
    );

    final submittedTheme = defaultTheme.copyWith(
      decoration: BoxDecoration(
        color: const Color(0xFFE6F1FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withValues(alpha: .5), width: 1.5),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: Text('ওটিপি ভেরিফিকেশন')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              SvgPicture.asset(SvgMyAsset.otp, width: 80, height: 80, fit: BoxFit.contain),
              const SizedBox(height: 24),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: textTheme(context).bodyMedium,
                  children: [
                    TextSpan(
                      text: 'ওটিপি পাঠানো হয়েছে ',

                      style: textTheme(context).bodyMedium!.copyWith(color: Colors.blueGrey),
                    ),
                    TextSpan(
                      text: maskPhoneNumber(widget.phoneNumber.toString()),
                      style: textTheme(context).bodyMedium!.copyWith(color: primaryColor(context)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Each pin box takes equal share of available width (minus total gap)
                  final boxSize = ((constraints.maxWidth - (5 * 8)) / 6).clamp(40.0, 64.0);
                  final dynamicTheme = defaultTheme.copyWith(width: boxSize, height: boxSize + 4);
                  return Pinput(
                    length: 6,
                    controller: widget.otpController,
                    keyboardType: TextInputType.number,
                    defaultPinTheme: dynamicTheme,
                    focusedPinTheme: focusedTheme.copyWith(width: boxSize, height: boxSize + 4),
                    submittedPinTheme: submittedTheme.copyWith(width: boxSize, height: boxSize + 4),
                    separatorBuilder: (index) => const SizedBox(width: 8),
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    closeKeyboardWhenCompleted: true,
                    onCompleted: widget.onCompleted,
                  );
                },
              ),

              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_secondsLeft > 0) ...[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 44,
                          width: 44,
                          child: CircularProgressIndicator(
                            value: _secondsLeft / widget.resendSeconds,
                            valueColor: AlwaysStoppedAnimation(primaryColor(context)),
                            backgroundColor: Colors.red.withValues(alpha: 0.2),
                            strokeWidth: 4,
                          ),
                        ),
                        Text(
                          _formatTime(_secondsLeft),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor(context)),
                        ),
                      ],
                    ),
                  ] else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ওটিপি পাননি?', style: textTheme(context).bodyMedium),
                        GestureDetector(
                          onTap: _onResendTapped,
                          child: Text(
                            'পুনরায় পাঠান',
                            style: textTheme(context).bodyMedium!
                                .copyWith(color: Colors.blue, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(onPressed: widget.onSubmit, child: Text('যাচাই করুন')),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
