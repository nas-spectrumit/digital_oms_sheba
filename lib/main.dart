import 'package:digital_oms_sheba/core/constant/loadin_overlay.dart';
import 'package:digital_oms_sheba/core/constant/themedata.dart';
import 'package:digital_oms_sheba/core/providers/app_providers.dart';
import 'package:digital_oms_sheba/core/services/svg_preload.dart';
import 'package:digital_oms_sheba/features/auth/onboarding/view/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preLoadSVG();
  runApp(MultiProvider(providers: appProviders, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: MaterialApp(
        title: 'Digital OMS Sheba',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: const SplashPage(),
        builder: (context, child) {
          return Stack(children: [child ?? const SizedBox.shrink(), const GlobalLoadingOverlay()]);
        },
      ),
    );
  }
}
// flutter clean && flutter pub get && cd ios && pod install && cd ..