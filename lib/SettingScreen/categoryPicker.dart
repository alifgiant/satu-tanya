import 'package:flutter/material.dart';
import 'package:satu_tanya/model/filter.dart';

class CategoryPicker extends StatefulWidget {
  final List<Filter> filters;

  const CategoryPicker({Key key, this.filters}) : super(key: key);

  @override
  _CategoryPickerState createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  List<Filter> selectedFilter;

  @override
  void initState() {
    super.initState();

    selectedFilter =
        widget.filters.map((f) => f.copyWith(isActive: false)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.filters.length,
          itemBuilder: (ctx, idx) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(widget.filters[idx].name),
              ),
              Checkbox(
                value: selectedFilter[idx].isActive,
                onChanged: (val) {
                  if (!mounted) return;
                  setState(() {
                    selectedFilter[idx].isActive = val;
                  });
                },
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: FlatButton(
            child: Text('Pilih', style: TextStyle(color: Colors.white)),
            color: Colors.teal,
            onPressed: () {
              Navigator.of(context).pop(selectedFilter);
            },
          ),
        )
      ],
    );
  }
}
