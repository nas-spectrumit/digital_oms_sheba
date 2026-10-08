import 'dart:convert';
import 'package:digital_oms_sheba/core/constant/helper_class.dart';

GitVersionModel gitVersionModelFromJson(String str) => GitVersionModel.fromJson(json.decode(str));

String gitVersionModelToJson(GitVersionModel data) => json.encode(data.toJson());

class GitVersionModel {
  dynamic versionCode;
  dynamic versionName;
  dynamic apkUrl;
  dynamic changelog;
  dynamic updatePop;

  GitVersionModel({this.versionCode, this.versionName, this.apkUrl, this.changelog, this.updatePop});

  factory GitVersionModel.fromJson(Map<String, dynamic> json) => GitVersionModel(
    versionCode: nullConverter(json["versionCode"]),
    versionName: nullConverter(json["versionName"]),
    apkUrl: nullConverter(json["apkUrl"]),
    changelog: nullConverter(json["changelog"]),
    updatePop: nullConverter(json["update_pop"]),
  );

  Map<String, dynamic> toJson() => {
    "versionCode": versionCode,
    "versionName": versionName,
    "apkUrl": apkUrl,
    "changelog": changelog,
    "update_pop": updatePop,
  };
}
