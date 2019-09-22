import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:satu_tanya/HomeScreen/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:satu_tanya/model/appState.dart';

void main() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = await auth.currentUser();
  // auth
  if (user == null) {
    await auth.signInAnonymously();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        title: 'Satu Tanya',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(46, 122, 236, 1),
          accentColor: Color.fromRGBO(255, 55, 95, 1),
        ),
        home: AppStateContainer(
          child: HomeScreen(),
          state: AppState(),
        ));
  }
}
