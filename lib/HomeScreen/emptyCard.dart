import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {
  const EmptyCard({
    Key key,
    @required this.hasDataInMemory,
  }) : super(key: key);

  final bool hasDataInMemory;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      child: Text(
        hasDataInMemory ? 'Tanpa Tanya (?)' : 'Loading ...',
        style: Theme.of(context)
            .textTheme
            .display1
            .copyWith(color: Colors.white, letterSpacing: 3),
      ),
    );
  }
}
