import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satu_tanya/HomeScreen/cardContent.dart';
import 'package:satu_tanya/model/app_state.dart';
import 'package:satu_tanya/model/question.dart';

final maxCardStack = 3;
final waitDuration = 1;

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Question> shuffledQuestions;
  List<Question> selected5Questions;
  int currentStart = maxCardStack;

  bool hasLoaded = true;
  bool showOnlyLoved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    shuffledQuestions = AppStateContainer.of(context).state.questions
      ..shuffle();
    selected5Questions = shuffledQuestions.take(maxCardStack).toList();
  }

  @override
  Widget build(BuildContext context) {
    int idx = 0;
    return Stack(
      alignment: AlignmentDirectional.center,
      children: selected5Questions
          .map((question) {
            final i = idx++;
            return Positioned(
              height: 550,
              bottom: 26 + (15.0 * i),
              child: buildCard(
                  context: context,
                  question: question,
                  scale: i,
                  isActive: i == 0 && hasLoaded),
            );
          })
          .toList()
          .reversed
          .toList()
            ..add(Positioned(
              bottom: 20,
              right: 28,
              child: FloatingActionButton(
                tooltip: 'Favorite Tanya',
                child: showOnlyLoved
                    ? Icon(Icons.bookmark)
                    : Icon(Icons.bookmark_border),
                backgroundColor: Colors.redAccent,
                onPressed: loadOnlyLoved,
              ),
            )),
    );
  }

  Widget buildCard({
    @required BuildContext context,
    @required Question question,
    @required int scale,
    bool isActive = false,
  }) {
    final card = Card(
      elevation: 6,
      child: Container(
        child: CardContent(
          question: question,
          scale: scale,
        ),
        width: MediaQuery.of(context).size.width * (0.85 - (0.05 * scale)),
      ),
    );
    if (isActive) {
      return Dismissible(
        key: new Key(new Random().toString()),
        child: card,
        onDismissed: (direction) {
          setState(() {
            hasLoaded = false;
            selected5Questions.remove(question);
          });
          addMoreQuestion();
        },
      );
    } else {
      return GestureDetector(
        child: card,
        onHorizontalDragStart: (detail) {
          Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.purple,
            content: Text('Baca dan pahami dulu ya sebelum lanjut.. 😆'),
            duration: Duration(seconds: 1),
          ));
        },
      );
    }
  }

  void loadOnlyLoved() {
    setState(() {
      showOnlyLoved = !showOnlyLoved;
      shuffledQuestions = AppStateContainer.of(context)
          .state
          .questions
          .where((question) => question.isLoved == showOnlyLoved)
          .toList()
            ..shuffle();
      selected5Questions = shuffledQuestions.take(maxCardStack).toList();
      currentStart = 0;
    });
    String text = 'Menampilkan tanya favorit mu';
    if (!showOnlyLoved) text = 'Menampilkan semua tanya';
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.purple,
      duration: Duration(seconds: 1),
    ));
  }

  void addMoreQuestion() async {
    await Future.delayed(Duration(seconds: waitDuration));
    hasLoaded = true;
    if (selected5Questions.length < maxCardStack) {
      setState(() {
        selected5Questions.add(shuffledQuestions[currentStart++]);
        if (currentStart >= shuffledQuestions.length) {
          shuffledQuestions.shuffle();
          currentStart = 0;
        }
      });
    }
  }
}
