import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:satu_tanya/SettingScreen/filterButtonGroup.dart';
import 'package:satu_tanya/SettingScreen/questionForm.dart';
import 'package:satu_tanya/model/appState.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class SettingScreen extends StatelessWidget {
  final AppState appState;

  const SettingScreen(this.appState, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStateContainer(
      state: appState,
      child: Scaffold(
        appBar: buildAppBar(context),
        backgroundColor: Theme.of(context).primaryColor,
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
      backgroundColor: Theme.of(context).primaryColor,
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
          if (Platform.isAndroid)
            createButton(
              'Beri bintang di Play Store',
              SvgPicture.asset(
                'assets/store/playstore.svg',
                semanticsLabel: 'Play Store Logo',
                height: 28,
                color: Colors.white,
              ),
              Colors.redAccent,
              () => LaunchReview.launch(
                writeReview: true,
                androidAppId: "com.buahbatu.satu_tanya",
                iOSAppId: "-",
              ),
            ),
          if (Platform.isIOS)
            createButton(
              'Beri bintang di App Store',
              SvgPicture.asset(
                'assets/store/applestore.svg',
                semanticsLabel: 'App Store Logo',
                height: 28,
                color: Colors.white,
              ),
              Colors.blueGrey,
              () => LaunchReview.launch(
                writeReview: true,
                androidAppId: "com.buahbatu.satu_tanya",
                iOSAppId: "-",
              ),
            ),
          Container(height: 12),
          createButton(
            'Bagikan aplikasi',
            Icon(Icons.share, size: 28, color: Colors.white),
            Colors.blueAccent,
            () async {
              final ByteData bytes =
                  await rootBundle.load('assets/logo_satu_tanya_round2.png');
              await WcFlutterShare.share(
                  sharePopupTitle: 'Bagikan Aplikasi',
                  subject: 'Aplikasi random paling asik',
                  text:
                      'Lagi ngumpul dan pengen diskusi random? Ayo download Satu Tanya dan rasakan keseruan bersama. \n\nAyo ikut keseruannya https://s.id/satu-tanya',
                  fileName: 'logo.png',
                  mimeType: 'image/png',
                  bytesOfFile: bytes.buffer.asUint8List());
            },
          ),
          Container(height: 32),
          createButton(
            'Aturan Bermain',
            Icon(Icons.style, size: 28, color: Colors.white),
            Colors.orangeAccent,
            () => showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Text(
                        'Aturan bermain',
                        style: Theme.of(context).textTheme.title,
                      ),
                      Container(height: 20),
                      Text('1. Baca dengan seksama pertanyaan yang muncul'),
                      Container(height: 6),
                      Text(
                          '2. Jawab sejujur jujurnya, ijinkan teman mu untuk menggali informasi tambahan'),
                      Container(height: 6),
                      Text('3. Berikan HP mu kepada orang berikutnya'),
                      Container(height: 6),
                      Text('4. Swipe kartu untuk mengganti pertanyaan'),
                      Container(height: 6),
                      Text(
                          '5. Jika tidak bisa menjawab berikan orang tersebut hukuman 😈'),
                      Container(height: 20),
                      Text(
                        'Selamat bermain.. ',
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      Text(
                        'Roses are red, violet are blue. \nI ❤️ this, and I hope you guys are too.',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  RaisedButton createButton(
      String text, Widget icon, Color color, VoidCallback onPressed) {
    return RaisedButton(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          Container(width: 16),
          Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
