import 'package:flutter/material.dart';
import 'package:satu_tanya/SettingScreen/filterButtonGroup.dart';
import 'package:satu_tanya/SettingScreen/questionForm.dart';
import 'package:satu_tanya/model/app_state.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingScreen extends StatelessWidget {
  final AppState appState;

  const SettingScreen(this.appState, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStateContainer(
      state: appState,
      child: Scaffold(
        appBar: buildAppBar(context),
        backgroundColor: Theme.of(context).accentColor,
        body: ListView(
          children: <Widget>[
            createSectionTitle(context, 'Kategori Tanya'),
            FilterButtonGroup(),
            Container(height: 24), // space
            createSectionTitle(context, 'Ajukan Tanya'),
            QuestionForm(),
            Container(height: 32), // space
            createActionButton(context),
            Container(height: 24), // space
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Pengaturan',
        style: TextStyle(
          letterSpacing: 3,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).accentColor,
      centerTitle: true,
    );
  }

  Padding createSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),
      ),
    );
  }

  Padding createActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (Theme.of(context).platform == TargetPlatform.android)
            createButton(
              'Beri bintang di Play Store',
              'assets/store/playstore.svg',
              Colors.redAccent,
            ),
          if (Theme.of(context).platform == TargetPlatform.iOS)
            createButton(
              'Beri bintang di App Store',
              'assets/store/applestore.svg',
              Colors.blueGrey,
            ),
          Container(height: 12),
          createButton(
            'Bagikan Aplikasi',
            null,
            Colors.blueAccent,
          ),
          Container(height: 12),
          createButton(
            'Tentang Kami',
            null,
            Colors.brown,
          ),
        ],
      ),
    );
  }

  RaisedButton createButton(String text, String icon, Color color) {
    return RaisedButton(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (icon != null)
            SvgPicture.asset(
              icon,
              semanticsLabel: 'Play Store Logo',
              height: 28,
              color: Colors.white,
            ),
          if (icon == null)
            Icon(
              Icons.info_outline,
              size: 28,
              color: Colors.white,
            ),
          Container(width: 16),
          Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      onPressed: () {},
    );
  }
}
