import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';

class Confidential extends StatefulWidget {
  Confidential({Key key}) : super(key: key);

  @override
  _ConfidentialState createState() => _ConfidentialState();
}

class _ConfidentialState extends State<Confidential>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Pantalla Confidencial"),
      ),
      child: AnimatedBackground(
        child: Text("Cool!"),
        vsync: this,
        behaviour: BubblesBehaviour(),
      ),
    );
  }
}
