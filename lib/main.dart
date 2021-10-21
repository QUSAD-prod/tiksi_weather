import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tiksi_weather/splash_screen_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print(message.notification!.android!.smallIcon);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  MobileAds.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.subscribeToTopic('weather');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
        appBarTheme: AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFF3f8ae0)),
            backgroundColor: Colors.white),
      ),
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [
        const Locale('ru'),
      ],
      home: SplashScreen(),
    );
  }
}
