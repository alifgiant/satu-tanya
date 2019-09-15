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

  static void showTutorial(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(
                'Aturan bermain',
                style: Theme.of(context).textTheme.title,
              ),
              Container(height: 20),
              Text('1. Baca dengan seksama pertanyaan yang muncul'),
              Container(height: 6),
              Text(
                  '2. Jawab sejujur jujurnya secara lisan'),
              Container(height: 6),
              Text('3. Persilahkan teman mu untuk menggali informasi tambahan secara bergantian'),
              Container(height: 6),
              Text('4. Berikan HP mu kepada orang berikutnya, lalu swipe kartu untuk mengganti pertanyaan'),
              Container(height: 6),
              Text(
                  '5. Jika menolak menjawab tanya, berikan orang tersebut hukuman 😈'),
              Container(height: 20),
              Text(
                'Selamat bermain.. ',
                style: Theme.of(context).textTheme.subtitle,
              ),
              Text(
                'Roses are red, violet are blue. \nI ❤️ this, and I hope you guys are too.',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        );
      },
    );
  }
}
