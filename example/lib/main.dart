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
        label: 'Tap anywhere to continue',
        textColor: Colors.black,
        hasLabelBox: true,
        labelBoxColor: Colors.yellow,
        hasArrow: true,
      ),
      OnboardStep(
        key: GlobalKey(),
        label: 'Tap only here to increment & continue',
        shape: const CircleBorder(),
        // tappable: false,
        // proceed: proceed.stream,
        overlayColor: Colors.blue.withOpacity(0.8),
        fullscreen: false,
        overlayShape: const CircleBorder(),
      ),
      OnboardStep(
        key: GlobalKey(),
        label: 'Easy to customise',
        overlayColor: Colors.red.withOpacity(0.8),
      ),
      OnboardStep(
        key: GlobalKey(),
        label: 'Add steps for any widget',
        overlayColor: Colors.green.withOpacity(0.8),
      ),
      const OnboardStep(
        key: null,
        label: "Or no widget at all! You're all done!",
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
