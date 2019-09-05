import 'package:flutter/material.dart';
import 'package:satu_tanya/model/question.dart';

class CardContent extends StatelessWidget {
  final Question question;
  final int scale;
  final bool shouldShowAds;
  final VoidCallback tryShowAds;

  const CardContent({
    Key key,
    this.question,
    this.scale,
    this.shouldShowAds,
    this.tryShowAds,
  }) : super(key: key);

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
                    onPressed: tryShowAds,
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
                    '"${question?.content ?? '...'}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 24 - (3.0 * scale)),
                  ),
                  if (question.writer != null) Container(height: 12),
                  if (question.writer != null)
                    Text('@${question.writer}',
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
