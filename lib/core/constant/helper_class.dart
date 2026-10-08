import 'dart:io';

import 'package:digital_oms_sheba/core/constant/height_width.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class HelperClass {
  static String dateTimeAsCode(String dateTime) {
    String myDateTime;

    try {
      DateTime dateTimes = DateTime.parse(dateTime);
      myDateTime = DateFormat('ddMMyyyyHHmmss').format(dateTimes);
    } catch (e) {
      myDateTime = '';
    }

    return myDateTime;
  }

  //converdateandtime
  static String convertDateTime(String date) {
    try {
      return DateFormat('dd MMM yyyy, h:mm a').format(DateTime.parse(date));
    } catch (e) {
      return "-";
    }
  }

  static String convertDate2(String date) {
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(date));
    } catch (e) {
      return "-";
    }
  }

  static String convertDate(String date) {
    try {
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    } catch (e) {
      return "-";
    }
  }

  static DateTime? parseDate(String date) {
    try {
      return DateFormat('dd-MM-yyyy').parse(date);
    } catch (e) {
      return null;
    }
  }

  static FilteringTextInputFormatter get passwordFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s@#!%$\-_\+^/\\<>/&?]'));

  static List<TextInputFormatter> banglaTextOnly({int length = 150}) {
    return [FilteringTextInputFormatter.allow(RegExp(r'[\u0980-\u09FFঃ\s]')), LengthLimitingTextInputFormatter(length)];
  }

  static List<TextInputFormatter> englishTextOnly({int length = 150}) {
    return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z:\s]')), LengthLimitingTextInputFormatter(length)];
  }

  static List<TextInputFormatter> numberOnlyFormatter({int length = 150}) {
    return [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(length)];
  }

  static Future<bool> isInternetAvailable() async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('https://google.com')).timeout(const Duration(seconds: 5));
      final response = await request.close().timeout(const Duration(seconds: 5));
      client.close();
      debugPrint('Internet check success: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 301 || response.statusCode == 302;
    } catch (e) {
      debugPrint('Internet check failed: $e');
      return false;
    }
  }

  static bool isValidBangladeshiPhone(String phone) {
    final validPrefixes = ["013", "014", "015", "016", "017", "018", "019"];

    final trimmedPhone = phone.trim();

    return trimmedPhone.length == 11 &&
        trimmedPhone.startsWith("01") &&
        validPrefixes.contains(trimmedPhone.substring(0, 3));
  }
}

Widget passwordNotice(BuildContext context, {EdgeInsetsGeometry? padding}) {
  Widget myDotText(String text) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.circle, size: 13, color: Colors.redAccent),
          width5(),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      myDotText('appLocalizations(context).passwordMustBe8Char'),
      myDotText('appLocalizations(context).pwdNoticeCapital'),
    ],
  );
}

Future<void> clearImageCache() async {
  var appDir = (await getTemporaryDirectory()).path;
  Directory(appDir).delete(recursive: true);
}

String nullConverter(dynamic data) {
  if (data != null && data != "") {
    return data.toString();
  } else {
    return "-";
  }
}

String nullBlankConverter(dynamic data) {
  if (data != null) {
    return data.toString();
  } else {
    return "";
  }
}

String nullConverterNumber(dynamic data) {
  if (data != null) {
    return data.toString();
  } else {
    return "0";
  }
}
