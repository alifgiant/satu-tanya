import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:satu_tanya/HomeScreen/cardContent.dart';
import 'package:satu_tanya/model/question.dart';
import 'dart:ui' as ui show ImageByteFormat, Image;
import 'package:wc_flutter_share/wc_flutter_share.dart';

class HomeAction extends StatefulWidget {
  final Function loadOnlyLoved;
  final Question question;
  final bool shouldShowAds;

  const HomeAction(
    this.loadOnlyLoved,
    this.question,
    this.shouldShowAds, {
    Key key,
  }) : super(key: key);

  @override
  _HomeActionState createState() => _HomeActionState();
}

class _HomeActionState extends State<HomeAction> {
  GlobalKey _globalKey = new GlobalKey();
  void shareQuestion() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      await WcFlutterShare.share(
        sharePopupTitle: 'Bagikan Pertanyaan',
        text: 'Ayo ikut keseruannya https://s.id/satu-tanya',
        fileName: 'satu-tanya.png',
        mimeType: 'image/png',
        bytesOfFile: pngBytes,
      );
    } catch (e) {
      print(e);
    }
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 8),
          children: <Widget>[
            RepaintBoundary(
              key: _globalKey,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Container(
                  child: CardContent(
                    question: widget.question,
                    scale: 0,
                    shouldShowAds: widget.shouldShowAds,
                    isWaterMarkOn: true,
                  ),
                  height: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Container(height: 6),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: RaisedButton(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Bagikan', style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryColor,
                onPressed: shareQuestion,
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 60,
      left: 28,
      right: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'share',
            tooltip: 'Bagikan Tanya',
            child: Icon(
              Icons.share,
              color: Theme.of(context).primaryColor,
            ),
            backgroundColor: Colors.white,
            onPressed: showBottomSheet,
          ),
          Container(width: 16),
          RaisedButton(
            elevation: 6,
            child: Row(
              children: <Widget>[
                (widget.question?.isLoved ?? false)
                    ? Icon(Icons.favorite_border, color: Colors.white)
                    : Icon(Icons.favorite_border,
                        color: Theme.of(context).accentColor),
                Container(width: 12),
                Text((widget.question?.isLoved ?? false) ? 'Hapus' : 'Simpan',
                    style: TextStyle(
                        color: (widget.question?.isLoved ?? false)
                            ? Colors.white
                            : Theme.of(context).accentColor)),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 21),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            color: (widget.question?.isLoved ?? false)
                ? Theme.of(context).accentColor
                : Colors.white,
            onPressed: () {
              if (!mounted) return;
              setState(() {
                widget.question?.isLoved = !widget.question.isLoved;
                if (widget.question?.isLoved == false) widget.loadOnlyLoved();
              });
            },
          ),
          Container(width: 16),
          FloatingActionButton(
            heroTag: 'favorite',
            tooltip: 'Mode favorit',
            child: Icon(
              Icons.bookmark_border,
              color: Theme.of(context).primaryColor,
            ),
            backgroundColor: Colors.white,
            onPressed: () => widget.loadOnlyLoved(toggle: true),
          ),
        ],
      ),
    );
  }
}
