import 'package:flutter/material.dart';
import 'package:satu_tanya/model/filter.dart';
import 'package:satu_tanya/model/question.dart';
import 'package:satu_tanya/repository/prefHelper.dart';

class AppState {
  final List<Filter> filters = [];
  final List<Question> _questions = [];

  List<Question> filteredQuestions() {
    return _questions.where((question) => isFilterPassed(question)).toList();
  }

  bool isFilterPassed(Question question) {
    final questionFilterIds = question.categoryId.split(',');
    return filters.any(
        (filter) => filter.isActive && questionFilterIds.contains(filter.id));
  }

  void addQuestions(Iterable<Question> iterable) {
    _questions.addAll(iterable);
  }

  void clearData() {
    _questions.clear();
    filters.clear();
  }

  void save() {
    PrefHelper.storeFiltersToDB(filters);
    PrefHelper.storeQuestionsToDB(_questions);
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
