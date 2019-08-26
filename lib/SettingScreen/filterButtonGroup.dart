import 'package:flutter/material.dart';
import 'package:satu_tanya/model/appState.dart';
import 'package:satu_tanya/model/filter.dart';

class FilterButtonGroup extends StatefulWidget {
  @override
  _FilterButtonGroupState createState() => _FilterButtonGroupState();
}

class _FilterButtonGroupState extends State<FilterButtonGroup> {
  @override
  Widget build(BuildContext context) {
    final filters = AppStateContainer.of(context).state.filters;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: filters.length,
        itemBuilder: (ctx, idx) => FlatButton(
          child: Text(
            filters[idx].name,
            textAlign: TextAlign.center,
            style: TextStyle(color: pickColor(filters[idx].isActive)),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: pickColor(filters[idx].isActive), width: 3),
          ),
          onPressed: () => switchState(filters, idx),
        ),
      ),
    );
  }

  void switchState(List<Filter> filters, int index) {
    if (!mounted) return;
    setState(() {
      if (filters[index].isActive &&
          filters.where((filter) => filter.isActive).length > 1) {
        filters[index].isActive = false;
      } else if (!filters[index].isActive) {
        filters[index].isActive = true;
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Minimal satu ketegori terpilih'),
          backgroundColor: Colors.purple,
        ));
      }
    });
  }

  Color pickColor(bool isActive) => isActive ? Colors.white : Colors.white38;
}
