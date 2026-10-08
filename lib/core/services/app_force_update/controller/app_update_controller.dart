import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:digital_oms_sheba/core/constant/api_string.dart';
import 'package:digital_oms_sheba/core/constant/loadin_overlay.dart';
import 'package:digital_oms_sheba/core/constant/navigation_custom.dart';
import 'package:digital_oms_sheba/core/services/app_force_update/model/git_version_model.dart';
import 'package:digital_oms_sheba/core/services/device_info_controller.dart';
import 'package:digital_oms_sheba/features/auth/onboarding/view/welcome_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../view/app_update_screen.dart';

class AppUpdateController extends ChangeNotifier {
  GitVersionModel? gitVersionModel;

  Future<void> deviceAllInfo(BuildContext context) async {
    await Provider.of<DeviceInfoController>(context, listen: false).initAllInfo();
    if (context.mounted) await verifyVersion(context);
  }

  Future<void> verifyVersion(BuildContext context, {String userType = 'public'}) async {
    if (Platform.isIOS) {
      log("🍏 iOS detected — skipping update check.");
      await checkForUpdateFromGithub(context, userType: userType);
      return;
    }

    if (context.mounted) {
      await checkForUpdateFromGithub(context, userType: userType);
    }
  }

  String? updatePop;
  String? noticeStatus;
  String? noticeText;

  String? dealerNoticeStatus;
  String? dealerNoticeText;

  String? currentVersionName;
  String? currentBuildNo;

  Future<void> checkForUpdateFromGithub(BuildContext context, {String userType = 'public'}) async {
    String url = AppString.gitUpdateUrl;

    MyGlobalLoader.show();
    try {
      final response = await Dio().get(url, options: Options(responseType: ResponseType.plain));

      log("$url ${response.statusCode}");

      if (response.statusCode != 200) {
        MyGlobalLoader.hide();
        log('Failed to load version info');
        if (context.mounted) {
          startApp(context);
        }
        return;
      }

      final versionJson = _parseVersionResponse(response.data);
      gitVersionModel = GitVersionModel.fromJson(versionJson);

      final latestVersionName = gitVersionModel!.versionName;
      final latestVersionCode = gitVersionModel!.versionCode;
      // final changelog = nullConverter(gitVersionModel!.changelog);
      // final apkUrl = nullConverter(gitVersionModel!.apkUrl);
      updatePop = gitVersionModel!.updatePop;
      notifyListeners();
      if (context.mounted) {
        currentVersionName = Provider.of<DeviceInfoController>(context, listen: false).currentVersionCode;
        currentBuildNo = Provider.of<DeviceInfoController>(context, listen: false).currentBuildNo;
      }

      log('Current: $currentVersionName ($currentBuildNo)');
      log('Latest:  $latestVersionName ($latestVersionCode)');

      final hasUpdate = int.parse(latestVersionCode) > int.parse(currentBuildNo!);

      MyGlobalLoader.hide();

      if (hasUpdate && updatePop == '1') {
        if (context.mounted) {
          navigateToAppUpdate(context);
        }
      } else {
        log('App is up to date');
        if (context.mounted) {
          startApp(context);
        }
      }
    } catch (e) {
      MyGlobalLoader.hide();
      log('Update check failed: $e');
      if (context.mounted) {
        startApp(context);
      }
    }
  }

  void startApp(BuildContext context) async {
    pushReplacementPage(context, const WelcomePage());
  }

  void navigateToAppUpdate(BuildContext context) {
    MyGlobalLoader.hide();
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (context) => AppUpdateScreen(storeUrl: AppString.googlePlayUrl)),
      (Route<dynamic> route) => false,
    );
  }

  Map<String, dynamic> _parseVersionResponse(dynamic data) {
    if (data is Map<String, dynamic>) return data;

    if (data is String) {
      final trimmed = data.trim();
      final objectStart = trimmed.indexOf('{');
      final objectEnd = trimmed.lastIndexOf('}');

      // Some hosts return JSON with extra wrappers/new lines; extract object safely.
      final candidate = (objectStart >= 0 && objectEnd > objectStart)
          ? trimmed.substring(objectStart, objectEnd + 1)
          : trimmed;

      final decoded = jsonDecode(candidate);
      if (decoded is Map<String, dynamic>) return decoded;
    }

    throw const FormatException('Invalid version payload format');
  }
}
