import 'package:flutter/material.dart';
import 'package:satu_tanya/SettingScreen/categoryPicker.dart';
import 'package:satu_tanya/model/appState.dart';
import 'package:satu_tanya/model/filter.dart';

class QuestionForm extends StatelessWidget {
  final TextEditingController _categoryField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        children: <Widget>[
          TextField(
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
                hintText: 'Hal gila apa yang kamu lakukan bersama sahabat mu?',
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
                  hintText: 'Kategori',
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
                  decoration: InputDecoration(
                      prefixText: '@',
                      hintText: 'Akun instagram atau twitter',
                      isDense: true,
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true),
                ),
              ),
              Container(width: 6),
              RaisedButton(
                child: Text('Kirim'),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
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
