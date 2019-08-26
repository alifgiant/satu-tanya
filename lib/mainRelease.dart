import 'package:satu_tanya/HomeScreen/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:satu_tanya/model/appState.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Satu Tanya',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(36, 48, 80, 1),
          accentColor: Color.fromRGBO(255, 55, 95, 1),
        ),
        home: AppStateContainer(
          child: HomeScreen(),
          state: AppState(),
        ));
  }
}
