import 'package:flutter/material.dart';
import 'package:satu_tanya/HomeScreen/homeContent.dart';
import 'package:satu_tanya/SettingScreen/settingScreen.dart';
import 'package:satu_tanya/model/app_state.dart';
import 'package:satu_tanya/model/filter.dart';
import 'package:satu_tanya/model/question.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isLoaded) loadFilters();
  }

  void loadFilters() {
    // load from internet logic

    // then
    setState(() {
      AppStateContainer.of(context).state.filters.addAll(dummyFilters);
      AppStateContainer.of(context).state.questions.addAll(dummyQuestions);
    });

    isLoaded = true;
  }

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
        'Satu Tanya',
        style: new TextStyle(
          letterSpacing: 3,
          fontWeight: FontWeight.bold,
        ),
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