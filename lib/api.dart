import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Api {
  Api();

  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference db = FirebaseDatabase(
    databaseURL:
        "https://tiksiweather-default-rtdb.europe-west1.firebasedatabase.app/",
  ).reference();

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

  Future<String> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return "ok";
    } catch (e) {
      return "error";
    }
  }

  bool checkAdmin() {
    if (auth.currentUser != null) {
      User currentUser = auth.currentUser!;
      currentUser.reload();
      if (currentUser.emailVerified == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
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
