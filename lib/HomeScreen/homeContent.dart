import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satu_tanya/HomeScreen/cardContent.dart';
import 'package:satu_tanya/HomeScreen/emptyCard.dart';
import 'package:satu_tanya/HomeScreen/homeAction.dart';
import 'package:satu_tanya/model/appAds.dart';
import 'package:satu_tanya/model/appState.dart';
import 'package:satu_tanya/model/config.dart';
import 'package:satu_tanya/model/filter.dart';
import 'package:satu_tanya/model/question.dart';
import 'package:satu_tanya/repository/prefHelper.dart';
import 'package:satu_tanya/repository/remoteRepoHelper.dart';
import 'dart:io';

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
  bool shouldShowReload = false;
  bool isLoadingShowed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // admob = Ads(AppState.adsAppId, testing: true);
    AppAds.init();

    // ads setting
    runAdsTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // dispose ads
    AppAds.dispose();

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
    final savedConfig = await PrefHelper.loadConfigFromDB();
    final isDataNotExist =
        AppStateContainer.of(context).state.filteredQuestions().isEmpty;

    Config remoteConfig;
    try {
      remoteConfig = await RemoteRepoHelper.getRemoteConfig();
    } on SocketException catch (_) {
      if (isDataNotExist) shouldShowReload = true;
      return false;
    }

    if (isDataNotExist ||
        remoteConfig.dbVersion != savedConfig?.dbVersion ||
        remoteConfig.appBuildNumber != savedConfig?.appBuildNumber) {
      await PrefHelper.storeConfigToDB(remoteConfig);
      return true;
    } else {
      return false;
    }
  }

  void turnOffAdsTimer() {
    shouldShowAds = false;
    PrefHelper.storeAdsState(shouldShowAds);
  }

  void runAdsTimer() async {
    if (shouldShowAds) return;
    // if last time haven't see ads,
    // force user to watch first
    shouldShowAds = await PrefHelper.loadAdsState();
    if (shouldShowAds) {
      resetView();
      return;
    }

    await Future.delayed(Duration(minutes: 30));
    shouldShowAds = true;
    PrefHelper.storeAdsState(shouldShowAds);
    resetView();
  }

  void loadDataToMemory() async {
    List<Filter> filters = [];
    List<Question> questions = [];

    // read from db / pref
    filters = await PrefHelper.loadFiltersFromDB();
    questions = await PrefHelper.loadQuestionsFromDB();
    loadDataToAppState(filters, questions);
    shouldShowReload = false;

    if (filters.isNotEmpty && questions.isNotEmpty) {
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

      // show tutorial on new data
      await Future.delayed(Duration(seconds: waitDuration));
      AppStateContainer.showTutorial(context);
    } else {
      // then
      resetView();
    }
  }

  void loadDataToAppState(List<Filter> filters, List<Question> questions) {
    // load to memory
    AppStateContainer.of(context).state.setFilters(filters);
    AppStateContainer.of(context).state.setQuestions(questions);
  }

  void saveDataToDB(List<Filter> filters, List<Question> questions) async {
    await PrefHelper.storeFiltersToDB(filters);
    await PrefHelper.storeQuestionsToDB(questions);
  }

  void resetView() {
    if (!mounted) return;
    if (!shouldShowAds) runAdsTimer();

    setState(() {
      currentStart = maxCardStack; // resetCounter
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
    final content = (buildCardList()
          ..add(EmptyCard(
            hasDataInMemory: hasDataInMemory,
            shouldShowReload: shouldShowReload,
            reloadAction: loadDataToMemory,
          )))
        .reversed
        .toList();
    return Stack(
      alignment: AlignmentDirectional.center,
      children: content
        ..add(HomeAction(
          loadOnlyLoved,
          (selected5Questions.length > 0 ? selected5Questions[0] : null),
        )),
    );
  }

  List<Widget> buildCardList() {
    int idx = 0;
    return selected5Questions.map<Widget>(
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
    ).toList();
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
          tryShowAds: tryShowAds,
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

  void tryShowAds() {
    // show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => WillPopScope(
        onWillPop: () async {
          isLoadingShowed = false;
          if (shouldShowAds)
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Silahkan tunggu videonya sampai selesai 😖'),
              backgroundColor: Colors.purple,
            ));
          return true;
        },
        child: Center(child: CircularProgressIndicator()),
      ),
    );
    isLoadingShowed = true;

    AppAds.ads?.showVideoAd(listener: (
      event, {
      String rewardType,
      int rewardAmount,
    }) {
      switch (event) {
        case RewardedVideoAdEvent.rewarded:
          turnOffAdsTimer();
          break;
        case RewardedVideoAdEvent.closed:
          if (isLoadingShowed) Navigator.of(context).pop();
          resetView();
          break;
        default:
          break;
      }
    });
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
