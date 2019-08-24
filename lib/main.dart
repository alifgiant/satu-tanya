import 'package:satu_tanya/HomeScreen/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:satu_tanya/model/app_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Satu Tanya',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: AppStateContainer(
          child: HomeScreen(),
          state: AppState(),
        ));
  }
}
