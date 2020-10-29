import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onboard_overlay/onboard_overlay.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Home(),
      );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<OnboardStep> steps;
  StreamController<dynamic> proceed;
  int _counter = 0;

  void initState() {
    super.initState();
    proceed = StreamController<dynamic>();
    steps = <OnboardStep>[
      OnboardStep(
        key: GlobalKey(),
        label: 'Tap anywhere to continue',
      ),
      OnboardStep(
        key: GlobalKey(),
        label: 'Tap only here to increment & continue',
        shape: const CircleBorder(),
        tappable: false,
        proceed: proceed.stream,
      ),
      OnboardStep(
        key: GlobalKey(),
        label: 'Easy to customise',
      ),
      OnboardStep(
        key: GlobalKey(),
        label: 'Add steps for any widget',
      ),
      const OnboardStep(
        key: null,
        label: "Or no widget at all! You're all done!",
        margin: EdgeInsets.zero,
      ),
    ];
    WidgetsBinding.instance
        .addPostFrameCallback((_) => onboard(steps, context));
  }

  @override
  void dispose() {
    proceed.close();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _counter++;
    });
    proceed.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(key: steps[3].key),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
              key: steps[0].key,
            ),
            Text(
              '$_counter',
              key: steps[2].key,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: steps[1].key,
        onPressed: _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
