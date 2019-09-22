import 'package:flutter/material.dart';
import 'package:satu_tanya/SettingScreen/categoryPicker.dart';
import 'package:satu_tanya/model/appState.dart';
import 'package:satu_tanya/model/filter.dart';
import 'package:firebase_database/firebase_database.dart';

class QuestionForm extends StatefulWidget {
  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final TextEditingController _questionField = TextEditingController();

  final TextEditingController _categoryField = TextEditingController();

  final TextEditingController _accountField = TextEditingController();

  final DatabaseReference questionRef =
      FirebaseDatabase.instance.reference().child('submit-questions');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        children: <Widget>[
          TextField(
            minLines: 3,
            maxLines: 5,
            controller: _questionField,
            decoration: InputDecoration(
                hintText: 'Ajukan tanya mu disini...',
                isDense: true,
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true),
          ),
          Container(height: 6),
          InkWell(
            onTap: () => showCategoryPicker(context),
            child: TextField(
              maxLines: 1,
              controller: _categoryField,
              decoration: InputDecoration(
                  enabled: false,
                  hintText: 'Pilih Kategori',
                  isDense: true,
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  maxLines: 1,
                  controller: _accountField,
                  decoration: InputDecoration(
                      prefixText: '@',
                      hintText: 'Akun Social Media',
                      isDense: true,
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true),
                ),
              ),
              Container(width: 6),
              RaisedButton(
                child: Text('Kirim'),
                onPressed: () => submitQuestion(context),
              ),
            ],
          )
        ],
      ),
    );
  }

  void submitQuestion(BuildContext context) async {
    if (_questionField.text.isEmpty ||
        _categoryField.text.isEmpty ||
        _accountField.text.isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Silahkan isi form nya terlebih dahulu'),
        backgroundColor: Colors.purple,
        duration: Duration(seconds: 1),
      ));
      return;
    }

    final question = _questionField.text;
    final account = _accountField.text;
    final rawCategory = _categoryField.text;

    final filters = AppStateContainer.of(context).state.filters;
    final categoryIds = rawCategory
        .split(', ')
        .map((cat) => filters.where((fil) => fil.name == cat).first.id)
        .join(',');

    try {
      // show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Container(
          child: Center(child: CircularProgressIndicator()),
        ),
      );

      final newQuestion = questionRef.push();
      final data = <String, String>{
        'id': newQuestion.key,
        'categoryId': categoryIds,
        'content': question,
        'writer': account
      };

      // upload
      await newQuestion.set(data);

      // clear field
      _questionField.clear();
      _categoryField.clear();
      _accountField.clear();
    } finally {
      // unshow loading
      Navigator.of(context).pop();

      // show snack bar
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('Pertanyaan terkirim!! Admin akan mereview pertanyaan mu 😎'),
        backgroundColor: Colors.purple,
        duration: Duration(seconds: 1),
      ));
    }
  }

  void showCategoryPicker(BuildContext context) async {
    List<Filter> selectedFilter = await showModalBottomSheet(
      context: context,
      builder: (ctx) => CategoryPicker(
        filters: AppStateContainer.of(context).state.filters,
      ),
    );

    if (selectedFilter != null) {
      final selectedText =
          selectedFilter.where((f) => f.isActive).map((f) => f.name).join(', ');
      _categoryField.text = selectedText;
    }
  }
}
