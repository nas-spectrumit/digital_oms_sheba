import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:unique_identifier/unique_identifier.dart';

class DeviceInfoController extends ChangeNotifier {
  String deviceFullInfo = '';
  String deviceName = '';
  String locationMessage = '';
  String latitude = '';
  String longitude = '';
  String uniqueSerial = '';
  String currentVersionCode = '';
  String currentBuildNo = '';

  Future<void> initAllInfo() async {
    await fetchLocation();
    await getDeviceUniqueSerial();
    await getDeviceDetails();
    notifyListeners();
  }

  Future<void> getDeviceDetails() async {
    final packageInfo = await PackageInfo.fromPlatform();
    currentVersionCode = packageInfo.version;
    currentBuildNo = packageInfo.buildNumber;
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        deviceName = info.device;
        deviceFullInfo =
            'DV: ${info.device} (${info.model}) , AVr: ${info.version.release}, USr: $uniqueSerial, Latitude: $latitude, Longitude: $longitude';
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        deviceName = info.name;
        deviceFullInfo =
            'DV: ${info.name} (${info.utsname.machine}) , AVr: ${info.systemVersion}, USr: $uniqueSerial, Latitude: $latitude, Longitude: $longitude';
      }
    } catch (e) {
      log('Error fetching device info: $e');
    }
    notifyListeners();
  }

  Future<void> fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log('Location permissions are permanently denied.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      locationMessage = 'Latitude: $latitude, Longitude: $longitude';
      notifyListeners();
    } catch (e) {
      log('DeviceInfoController: fetchLocation error: $e');
    }
  }



  Future<void> getDeviceUniqueSerial() async {
    try {
      uniqueSerial = await UniqueIdentifier.serial ?? '';
      log('Unique Identifier: $uniqueSerial');
    } catch (e) {
      uniqueSerial = '';
      log('Error fetching unique identifier: $e');
    }
  }
}

class AppVersionDetails extends StatelessWidget {
  const AppVersionDetails({super.key, this.fontColor = Colors.blueGrey, this.fontSize = 8});

  final Color fontColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceInfoController>(
      builder: (context, provider, child) {
        return Text(
          'v ${provider.currentVersionCode}.${provider.currentBuildNo}',
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700, color: fontColor),
        );
      },
    );
  }
}
