import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satu_tanya/HomeScreen/cardContent.dart';
import 'package:satu_tanya/HomeScreen/homeAction.dart';
import 'package:satu_tanya/model/app_state.dart';
import 'package:satu_tanya/model/filter.dart';
import 'package:satu_tanya/model/question.dart';
import 'package:satu_tanya/repository/prefHelper.dart';
import 'package:satu_tanya/repository/remoteRepoHelper.dart';

final maxCardStack = 3;
final waitDuration = 1;

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with WidgetsBindingObserver {
  List<Question> shuffledQuestions;
  List<Question> selected5Questions;
  int currentStart = maxCardStack;

  bool hasDataInMemory = false;
  bool hasReloaded = true;
  bool showOnlyLoved = false;
  bool shouldShowAds = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    runAdsTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AppStateContainer.of(context).state.save();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!hasDataInMemory) loadDataToMemory();
    resetView();
  }

  Future<bool> shouldLoadNewData() async {
    final remoteConfig = await RemoteRepoHelper.getRemoteConfig();
    final savedConfig = await PrefHelper.loadConfigFromDB();

    if (remoteConfig.dbVersion != savedConfig?.dbVersion) {
      await PrefHelper.storeConfigToDB(remoteConfig);
      return true;
    } else {
      return false;
    }
  }

  void runAdsTimer() async {
    await Future.delayed(Duration(seconds: 2));

    shouldShowAds = true;
    print(shouldShowAds);
  }

  void loadDataToMemory() async {
    List<Filter> filters = [];
    List<Question> questions = [];

    // read from db / pref
    filters = await PrefHelper.loadFiltersFromDB();
    questions = await PrefHelper.loadQuestionsFromDB();
    loadDataToAppState(filters, questions);

    if (filters.isNotEmpty) {
      hasDataInMemory = true;
      resetView();
    }

    if (await shouldLoadNewData()) {
      // read from internet
      filters = await RemoteRepoHelper.getFilters();
      questions = await RemoteRepoHelper.getQuestions();
      saveDataToDB(filters, questions);

      AppStateContainer.of(context).state.clearData();
      loadDataToAppState(filters, questions);

      // then
      resetView();
    }
  }

  void loadDataToAppState(List<Filter> filters, List<Question> questions) {
    // load to memory
    AppStateContainer.of(context).state.filters.addAll(filters);
    AppStateContainer.of(context).state.addQuestions(questions);
  }

  void saveDataToDB(List<Filter> filters, List<Question> questions) async {
    await PrefHelper.storeFiltersToDB(filters);
    await PrefHelper.storeQuestionsToDB(questions);
  }

  void resetView() {
    if (!mounted) return;
    setState(() {
      currentStart = 0; // resetCounter
      shuffledQuestions = AppStateContainer.of(context)
          .state
          .filteredQuestions()
          .where((question) => showOnlyLoved ? question.isLoved : true)
          .toList()
            ..shuffle();
      selected5Questions = shuffledQuestions.take(maxCardStack).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    int idx = 0;
    return Stack(
      alignment: AlignmentDirectional.center,
      children: (selected5Questions.map<Widget>(
        (question) {
          final i = idx++;
          return Positioned(
            bottom: 20 + (20.0 * i),
            child: buildCard(
                context: context,
                question: question,
                scale: i,
                isActive: i == 0 && hasReloaded),
          );
        },
      ).toList()
            ..add(Container(
              alignment: AlignmentDirectional.center,
              child: Text(
                hasDataInMemory ? 'Tanpa Tanya (?)' : 'Loading ...',
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(color: Colors.white, letterSpacing: 3),
              ),
            )))
          .reversed
          .toList()
            ..add(HomeAction(
                loadOnlyLoved,
                (selected5Questions.length > 0
                    ? selected5Questions[0]
                    : null))),
    );
  }

  Widget buildCard({
    @required BuildContext context,
    @required Question question,
    @required int scale,
    bool isActive = false,
  }) {
    final card = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 6,
      child: Container(
        child: CardContent(
          question: question,
          scale: scale,
          shouldShowAds: shouldShowAds,
        ),
        height: MediaQuery.of(context).size.height * 0.78,
        width: MediaQuery.of(context).size.width * (0.9 - (0.1 * scale)),
      ),
    );
    if (isActive) {
      return Dismissible(
        key: new Key(new Random().toString()),
        child: card,
        onDismissed: (direction) {
          if (!mounted) return;
          setState(() {
            hasReloaded = false;
            selected5Questions.remove(question);
          });
          addMoreQuestion();
        },
      );
    } else {
      return GestureDetector(
        child: card,
        onHorizontalDragStart: (detail) {
          if (scale == 0)
            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.purple,
              content: Text('Baca dan pahami dulu ya sebelum lanjut.. 😆'),
              duration: Duration(seconds: 1),
            ));
        },
      );
    }
  }

  void loadOnlyLoved({bool toggle = false}) {
    if (toggle) showOnlyLoved = !showOnlyLoved;
    resetView();

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
    hasReloaded = true;
    if (selected5Questions.length < maxCardStack) {
      if (!mounted) return;
      setState(() {
        selected5Questions.add(shuffledQuestions[currentStart++]);
        if (currentStart >= shuffledQuestions.length) {
          resetView();
        }
      });
    }
  }
}
