import 'package:flutter/material.dart';

class EmptyCard extends StatefulWidget {
  const EmptyCard(
      {Key key,
      @required this.hasDataInMemory,
      @required this.shouldShowReload,
      @required this.reloadAction})
      : super(key: key);

  final bool hasDataInMemory;
  final bool shouldShowReload;
  final VoidCallback reloadAction;

  @override
  _EmptyCardState createState() => _EmptyCardState();
}

class _EmptyCardState extends State<EmptyCard>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 400).animate(controller);
    controller.repeat();
  }

  String getText(double value) {
    if (value < 100)
      return "Loading";
    else if (value < 200)
      return "Loading .";
    else if (value < 300)
      return "Loading ..";
    else
      return "Loading ...";
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      child:
          widget.shouldShowReload ? buildReloadScreen() : buildAnimatedScreen(),
    );
  }

  Widget buildReloadScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Gagal Mengambil Data 😫',
          style: Theme.of(context)
              .textTheme
              .title
              .copyWith(color: Colors.white, letterSpacing: 3),
        ),
        Container(height: 16),
        RaisedButton(
          child: Text('Coba Lagi'),
          onPressed: widget.reloadAction,
        )
      ],
    );
  }

  Widget buildAnimatedScreen() {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Text(
        widget.hasDataInMemory ? 'Tanpa Tanya (?)' : getText(animation.value),
        style: Theme.of(context)
            .textTheme
            .display1
            .copyWith(color: Colors.white, letterSpacing: 3),
      ),
    );
  }
}
