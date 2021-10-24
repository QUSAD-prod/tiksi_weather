import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class Api {
  Api();

  FirebaseAuth auth = FirebaseAuth.instance;

  DatabaseReference db = FirebaseDatabase().reference();

  FirebaseMessaging messagingService = FirebaseMessaging.instance;

  Future<String> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "ok";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "user-not-found";
      } else if (e.code == 'wrong-password') {
        return "wrong-password";
      } else if (e.code == 'invalid-email') {
        return "invalid-email";
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  pushNotification(bool newWeather) async {
    if (newWeather) {
      try {
        var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAgHTyIY4:APA91bEt_7SM63V8V4G51zlzudhO73ZiTh5kY3sg4dKjfAhIq2dLh8IpYyEtU6DvKzSR00sMXwZHgHofTucYyvVg5SwatZ55Xb0xQauVYvC7V5-EiNOXqptaOVjHheCOHg_ixOraO8zQ'
          },
          body: jsonEncode({
            "to": "/topics/weather",
            "notification": {
              "title": "TiksiWeather",
              "body": "Доступен новый прогноз погоды"
            },
            "direct_boot_ok": true
          }),
        );
        print("RESPONSE STATUS: " + response.statusCode.toString());
        print("RESPONSE REQUEST: " + response.request.toString());
        print("RESPONSE HEADERS: " + response.headers.toString());
      } catch (e) {
        print(e);
      }
    } else {
      try {
        var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAgHTyIY4:APA91bEt_7SM63V8V4G51zlzudhO73ZiTh5kY3sg4dKjfAhIq2dLh8IpYyEtU6DvKzSR00sMXwZHgHofTucYyvVg5SwatZ55Xb0xQauVYvC7V5-EiNOXqptaOVjHheCOHg_ixOraO8zQ'
          },
          body: jsonEncode({
            "to": "/topics/weather",
            "notification": {
              "title": "TiksiWeather",
              "body": "Прогноз погоды обновлён"
            },
            "direct_boot_ok": true
          }),
        );
        print("RESPONSE STATUS: " + response.statusCode.toString());
        print("RESPONSE REQUEST: " + response.request.toString());
        print("RESPONSE HEADERS: " + response.headers.toString());
      } catch (e) {
        print(e);
      }
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return "ok";
    } catch (e) {
      return "error";
    }
  }

  Future<String> signOut() async {
    try {
      await auth.currentUser!.reload();
      await auth.signOut();
      return "ok";
    } on FirebaseAuthException {
      return "error";
    }
  }

  Future<Map> getWeather(String date) async {
    DatabaseReference ref = db.child("weather").child(date);
    Map<dynamic, dynamic> values = {};
    await ref.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        values = Map.from(snapshot.value);
        values.addAll({"result": "ok"});
      } else {
        values.addAll({"result": "error"});
      }
    });
    return values;
  }
}
