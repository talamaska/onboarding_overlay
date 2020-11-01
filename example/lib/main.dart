import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:onboard_overlay/onboard_overlay.dart';

void main() {
  // timeDilation = 2;

  runApp(App());
}

final GlobalKey<OnboardingState> onboadingKey = GlobalKey<OnboardingState>();

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
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    steps = <OnboardStep>[
      OnboardStep(
        key: GlobalKey(),
        title: 'Tap anywhere to continue',
        bodyText: 'Tap anywhere to continue',
        textColor: Colors.black,
        hasLabelBox: true,
        labelBoxColor: Colors.yellow,
        hasArrow: true,
      ),
      OnboardStep(
        key: GlobalKey(),
        title: 'Tap only here to increment & continue',
        bodyText: 'Tap only here to increment & continue',
        shape: const CircleBorder(),
        // tappable: false,
        // proceed: proceed.stream,
        overlayColor: Colors.blue.withOpacity(0.9),
        fullscreen: false,
        labelBoxColor: Colors.transparent,
        overlayShape: const CircleBorder(),
      ),
      OnboardStep(
        key: GlobalKey(),
        title: 'Easy to customise',
        bodyText: 'Easy to customise',
        overlayColor: Colors.red.withOpacity(0.9),
        labelBoxColor: Colors.transparent,
      ),
      OnboardStep(
        key: GlobalKey(),
        title: 'Add steps for any widget',
        bodyText: 'Add steps for any widget',
        overlayColor: Colors.green.withOpacity(0.9),
        labelBoxColor: Colors.transparent,
      ),
      const OnboardStep(
        key: null,
        title: "Or no widget at all! You're all done!",
        bodyText: "Or no widget at all! You're all done!",
        labelBoxColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _increment() {
    setState(() {
      _counter++;
    });
    // proceed.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Onboarding(
      key: onboadingKey,
      steps: steps,
      onChanged: (int index) {
        debugPrint('----index $index');
      },
      child: Scaffold(
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
          onPressed: () {
            onboadingKey.currentState.show();
            _increment();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
