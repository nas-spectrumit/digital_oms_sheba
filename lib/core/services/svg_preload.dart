import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> preloadSvgAssetsFunc(List<String> assetPaths) async {
  for (final path in assetPaths) {
    try {
      final loader = SvgAssetLoader(path);
      await svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    } catch (e) {
      debugPrint('Failed to load SVG at $path: $e');
      // Optionally log to Crashlytics or another services
    }
  }
}

Future<void> preLoadSVG() async {
  await preloadSvgAssetsFunc(SvgMyAsset.all);
}

class SvgMyAsset {
  static const String barcode = 'assets/svg/barcode.svg';
  static const String beneficiaryRegistration = 'assets/svg/beneficiary_registration.svg';
  static const String call = 'assets/svg/call.svg';
  static const String calculator = 'assets/svg/calculator.svg';
  static const String calender = 'assets/svg/calender.svg';
  static const String camera = 'assets/svg/camera.svg';
  static const String captcha = 'assets/svg/captcha.svg';
  static const String card = 'assets/svg/card.svg';
  static const String cardActivation = 'assets/svg/card_activation.svg';
  static const String cardDelivery = 'assets/svg/card_delivery.svg';
  static const String cardEdit = 'assets/svg/card_edit.svg';
  static const String doc1 = 'assets/svg/doc1.svg';
  static const String duplicate = 'assets/svg/duplicate.svg';
  static const String eye = 'assets/svg/eye.svg';
  static const String faceScan = 'assets/svg/face_scan.svg';
  static const String fingerScan = 'assets/svg/finger_scan.svg';
  static const String gender = 'assets/svg/gender.svg';
  static const String googlePlay = 'assets/svg/google_play.svg';
  static const String info = 'assets/svg/info.svg';
  static const String idCard = 'assets/svg/id_card.svg';
  static const String imageBox = 'assets/svg/image_box.svg';
  static const String loadingA = 'assets/svg/loading_a.svg';
  static const String location = 'assets/svg/location.svg';
  static const String login = 'assets/svg/login.svg';
  static const String mail = 'assets/svg/mail.svg';
  static const String mapMarker = 'assets/svg/map_marker.svg';
  static const String marital = 'assets/svg/marital.svg';
  static const String notice = 'assets/svg/notice.svg';
  static const String noticeYellow = 'assets/svg/notice_yellow.svg';
  static const String otp = 'assets/svg/otp.svg';
  static const String payment = 'assets/svg/payment.svg';
  static const String payment2 = 'assets/svg/payment_2.svg';
  static const String pdf = 'assets/svg/pdf.svg';
  static const String pdf2 = 'assets/svg/pdf2.svg';
  static const String play = 'assets/svg/play.svg';
  static const String pos = 'assets/svg/pos.svg';
  static const String profile = 'assets/svg/profile.svg';
  static const String product = 'assets/svg/product.svg';
  static const String qr = 'assets/svg/qr.svg';
  static const String search = 'assets/svg/search.svg';
  static const String shop = 'assets/svg/shop.svg';
  static const String stop = 'assets/svg/stop.svg';
  static const String success = 'assets/svg/success.svg';
  static const String warning = 'assets/svg/warning.svg';
  static const String whatsapp = 'assets/svg/whatsapp.svg';
  static const String youtube = 'assets/svg/youtube.svg';

  static const List<String> all = [
    barcode,
    beneficiaryRegistration,
    calculator,
    calender,
    call,
    camera,
    captcha,
    card,
    cardActivation,
    cardDelivery,
    cardEdit,
    doc1,
    duplicate,
    eye,
    faceScan,
    fingerScan,
    gender,
    googlePlay,
    info,
    idCard,
    imageBox,
    loadingA,
    location,
    login,
    mail,
    mapMarker,
    marital,
    notice,
    noticeYellow,
    otp,
    payment,
    payment2,
    pdf,
    pdf2,
    play,
    pos,
    profile,
    product,
    qr,
    search,
    shop,
    stop,
    success,
    warning,
    whatsapp,
    youtube,
  ];
}
