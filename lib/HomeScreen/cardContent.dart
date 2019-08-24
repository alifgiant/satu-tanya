import 'package:flutter/material.dart';
import 'package:satu_tanya/model/question.dart';

class CardContent extends StatefulWidget {
  final Question question;
  final int scale;

  const CardContent({
    Key key,
    this.question,
    this.scale,
  }) : super(key: key);

  @override
  _CardContentState createState() => _CardContentState();
}

class _CardContentState extends State<CardContent> {
  bool shouldShowAds;

  @override
  void initState() {
    super.initState();
    shouldShowAds = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // logic to check ads
    // shouldShowAds = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (shouldShowAds)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(21),
                  child: Text(
                    'Ingin lanjut bermain?',
                    style: Theme.of(context).textTheme.title,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 42),
                  child: RaisedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.local_movies,
                          color: Colors.white,
                        ),
                        Container(width: 6),
                        Text('Nonton Video 30s',
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                    color: Colors.teal,
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        if (!shouldShowAds)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(21),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '"${widget.question?.content ?? '...'}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 24 - (3.0 * widget.scale)),
                  ),
                  if (widget.question.writer != null) Container(height: 12),
                  if (widget.question.writer != null)
                    Text('@${widget.question.writer}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subhead),
                ],
              ),
            ),
          )
      ],
    );
  }
}
