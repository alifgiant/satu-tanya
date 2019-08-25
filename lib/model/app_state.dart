import 'package:flutter/material.dart';
import 'package:satu_tanya/model/filter.dart';
import 'package:satu_tanya/model/question.dart';

class AppState {
  final List<Filter> filters = [];
  final List<Question> _questions = [];

  List<Question> filteredQuestions() {
    return _questions
        .where((question) => filters.any(
            (filter) => filter.isActive && filter.id == question.categoryId))
        .toList();
  }

  void addQuestions(Iterable<Question> iterable) {
    _questions.addAll(iterable);
  }

  void clearData() {
    _questions.clear();
    filters.clear();
  }
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
