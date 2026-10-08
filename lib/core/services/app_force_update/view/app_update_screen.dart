import 'package:digital_oms_sheba/core/constant/height_width.dart';
import 'package:digital_oms_sheba/core/services/device_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateScreen extends StatefulWidget {
  const AppUpdateScreen({super.key, required this.storeUrl});

  final String storeUrl;

  @override
  State<AppUpdateScreen> createState() => _AppUpdateScreenState();
}

class _AppUpdateScreenState extends State<AppUpdateScreen> {
  Future<void> launchUpdate() async {
    debugPrint(widget.storeUrl);
    canLaunchUrl(Uri.parse(widget.storeUrl)).then((canLaunch) async {
      if (canLaunch) {
        launchUrl(Uri.parse(widget.storeUrl));
      } else {
        debugPrint('Could not launch Google Play Store');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ClipRRect(child: Image.asset('assets/images/main_logo_transparent.png', height: 100, width: 100)),
                    height30(),
                    const Text(
                      'App Update Required (অ্যাপ আপডেট প্রয়োজন)',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * .04),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: .5),
                        color: Colors.grey.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Image(
                            image: AssetImage('assets/images/rocket.png'),
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          ),
                          height5(),
                          const Center(
                            child: Text(
                              'Please update the app to access new services (নতুন পরিষেবাগুলি অ্যাক্সেস করতে অনুগ্রহ করে অ্যাপটি আপডেট করুন)',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    height20(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Colors.green[700]!, Colors.green[500]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          await launchUpdate();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // Make background transparent
                          shadowColor: Colors.transparent, // Remove default shadow
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Rounded corners
                          ),
                        ),
                        child: const Text(
                          'Update App (অ্যাপ আপডেট করুন)',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ),
                    ),
                    height20(),
                    InkWell(
                      onTap: () async {
                        await launchUpdate();
                      },
                      child: const Center(child: Image(image: AssetImage('assets/images/google_play.png'), height: 40)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppVersionDetails(fontSize: 8, fontColor: Colors.blueGrey),
            height10(),
          ],
        ),
      ),
    );
  }
}
