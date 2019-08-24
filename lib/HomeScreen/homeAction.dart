import 'package:flutter/material.dart';
import 'package:satu_tanya/model/question.dart';

class HomeAction extends StatefulWidget {
  final Function loadOnlyLoved;
  final Question question;

  const HomeAction(this.loadOnlyLoved, this.question, {Key key})
      : super(key: key);

  @override
  _HomeActionState createState() => _HomeActionState();
}

class _HomeActionState extends State<HomeAction> {
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
            onPressed: () {},
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
