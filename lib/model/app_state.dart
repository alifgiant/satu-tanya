import 'package:flutter/material.dart';
import 'package:satu_tanya/model/filter.dart';
import 'package:satu_tanya/model/question.dart';

class AppState {
  final List<Filter> filters = [];
  final List<Question> questions = [];
}

class AppStateContainer extends InheritedWidget {
  final AppState state;
  final Widget child;

  AppStateContainer({@required this.child, this.state});

  static AppStateContainer of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppStateContainer);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
