import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiksi_weather/api.dart';
import 'package:tiksi_weather/weather_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('ru'),
      ],
      home: WeatherPage(firebase: Api()),
    );
  }
}
