import 'package:digital_oms_sheba/core/services/svg_preload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

class LoaderCustomInitiate extends StatefulWidget {
  const LoaderCustomInitiate({super.key, required this.onState});
  final Future<void> Function() onState;

  @override
  State<LoaderCustomInitiate> createState() => _LoaderCustomInitiateState();
}

class _LoaderCustomInitiateState extends State<LoaderCustomInitiate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1));
      await widget.onState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false, body: loaderCustomNew(context));
  }
}

Widget loaderCustomNew(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.green[50]!, Colors.green[100]!, Colors.green[200]!],
      ),
    ),
    child: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom loader container
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.green.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated loader
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                        ),
                      ),
                      // Pulsing inner circle
                      SvgPicture.asset(height: 50, width: 50, SvgMyAsset.loadingA),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Animated loading text
                  Text(
                    'দয়া করে অপেক্ষা করুন',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
