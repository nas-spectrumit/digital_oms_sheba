import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:digital_oms_sheba/core/constant/height_width.dart';
import 'package:digital_oms_sheba/core/constant/navigation_custom.dart';
import 'package:digital_oms_sheba/features/auth/login/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionPage extends StatelessWidget {
  const LocationPermissionPage({super.key});

  Future<void> _requestPermission(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('অনুগ্রহ করে ডিভাইসের লোকেশন চালু করুন')),
        );
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return;
    }
    
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      if (context.mounted) {
        pushReplacementPage(context, const LoginPage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('অনুমতি প্রয়োজন'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.location_on_rounded, size: 80, color: myGreen),
            height24(),
            Text(
              'লোকেশন অ্যাক্সেস প্রয়োজন',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey.shade900),
              textAlign: TextAlign.center,
            ),
            height16(),
            Text(
              'আপনাকে সঠিক সেবা প্রদান করতে এবং আপনার এলাকার নিকটবর্তী তথ্য নিশ্চিত করতে অ্যাপটির লোকেশন অ্যাক্সেস প্রয়োজন। অনুগ্রহ করে লোকেশন অনুমতি দিন।',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: myGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _requestPermission(context),
                child: const Text(
                  'অনুমতি দিন',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
