import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:url_launcher/url_launcher.dart';

class DeviceInfoController extends ChangeNotifier {
  String deviceFullInfo = '';
  String deviceName = '';
  String locationMessage = '';
  String latitude = '';
  String longitude = '';
  String myIpAddress = '';
  String uniqueSerial = '';
  String totalRam = '';
  String currentVersionCode = '';
  String currentBuildNo = '';

  Future<void> fetchLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      locationMessage = 'Latitude: $latitude, Longitude: $longitude';
      notifyListeners();
    } catch (e) {
      debugPrint('DeviceInfoController: fetchLocation error: $e');
    }
  }

  Future<void> getIpAddress() async {
    myIpAddress = await NetworkInfo().getWifiIP() ?? 'Unknown';
    notifyListeners();
  }

  Future<void> getDeviceUniqueSerial() async {
    try {
      uniqueSerial = await UniqueIdentifier.serial ?? '';
      debugPrint('Unique Identifier: $uniqueSerial');
    } catch (e) {
      uniqueSerial = '';
      debugPrint('Error fetching unique identifier: $e');
    }
  }

  Future<void> launchMap(String latitude, String longitude) async {
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not launch map";
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
