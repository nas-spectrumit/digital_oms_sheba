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
    await getDeviceUniqueSerial();
    await getDeviceDetails();
    await fetchLocation();
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
            'Device: ${info.device} (${info.model}) , Android Version: ${info.version.release}, Serial: $uniqueSerial, Latitude: $latitude, Longitude: $longitude';
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        deviceName = info.name;
        deviceFullInfo =
            'Device: ${info.name} (${info.utsname.machine}) , IOS Version: ${info.systemVersion}, Serial: $uniqueSerial, Latitude: $latitude, Longitude: $longitude';
      }
      log('Device Info: $deviceFullInfo');
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
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 15)),
      );
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      locationMessage = 'Latitude: $latitude, Longitude: $longitude';
      log(locationMessage);
      notifyListeners();
    } catch (e) {
      log('Location: fetchLocation error: $e');
    }
  }

  Future<void> getDeviceUniqueSerial() async {
    try {
      uniqueSerial = await UniqueIdentifier.serial ?? '';
      log('UniqueSerial: $uniqueSerial');
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
