import 'package:flutter/material.dart';
import 'package:satu_tanya/HomeScreen/homeContent.dart';
import 'package:satu_tanya/SettingScreen/settingScreen.dart';
import 'package:satu_tanya/model/appState.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Theme.of(context).primaryColor,
      body: HomeContent(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'SatuTanya',
        style: new TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
      ),
      elevation: 0,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          tooltip: 'Pengaturan',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => SettingScreen(
                AppStateContainer.of(context).state,
              ),
            ));
          },
        ),
      ],
    );
  }
}
