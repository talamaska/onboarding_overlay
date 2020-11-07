import 'package:flutter/material.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';

void main() {
  // timeDilation = 2;

  runApp(App());
}

class App extends StatefulWidget {
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<FocusNode> focusNodes = <FocusNode>[];

  @override
  void initState() {
    super.initState();

    focusNodes = List<FocusNode>.generate(
      7,
      (int i) => FocusNode(debugLabel: i.toString()),
      growable: false,
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Onboarding(
          key: widget.onboardingKey,
          steps: <OnboardingStep>[
            OnboardingStep(
              focusNode: focusNodes[0],
              title: 'Tap anywhere to continue',
              bodyText: 'Tap anywhere to continue',
              titleTextColor: Colors.black,
              hasLabelBox: true,
              labelBoxPadding: const EdgeInsets.all(8.0),
              labelBoxDecoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              hasArrow: true,
            ),
            OnboardingStep(
              focusNode: focusNodes[1],
              title: 'Tap only here to increment & continue',
              bodyText: 'Tap only here to increment & continue',
              shape: const CircleBorder(),
              fullscreen: false,
              overlayColor: Colors.blue.withOpacity(0.9),
              overlayShape: const CircleBorder(),
            ),
            OnboardingStep(
              focusNode: focusNodes[2],
              title: 'Easy to customise',
              bodyText: 'Easy to customise',
              overlayColor: Colors.red.withOpacity(0.9),
            ),
            OnboardingStep(
              focusNode: focusNodes[3],
              title: 'Add steps for any widget',
              bodyText: 'Add steps for any widget',
              overlayColor: Colors.green.withOpacity(0.9),
            ),
            OnboardingStep(
              focusNode: focusNodes[4],
              title: 'Settings',
              shape: const CircleBorder(),
              bodyText:
                  'Click here to access settings such as dark mode, daily limit, etc',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
            ),
            OnboardingStep(
              focusNode: focusNodes[5],
              title: 'test!',
              bodyText: 'test test test!',
              delay: const Duration(milliseconds: 300),
            ),
            OnboardingStep(
              focusNode: focusNodes[6],
              title: "Or no widget at all! You're all done!",
              bodyText: "Or no widget at all! You're all done!",
              margin: EdgeInsets.zero,
            ),
          ],
          onChanged: (int index) {
            if (index == 5) {
              // widget.scaffoldKey.currentState.openDrawer();

              // interrupt onboarding on specific step
              // widget.onboardingKey.currentState.hide();
            }
          },
          child: Home(
            scaffoldKey: widget.scaffoldKey,
            focusNodes: focusNodes,
          ),
        ),
      );
}

class Home extends StatefulWidget {
  const Home({Key key, this.scaffoldKey, this.focusNodes}) : super(key: key);

  final List<FocusNode> focusNodes;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<OnboardingStep> steps;

  int _counter = 0;

  @override
  void dispose() {
    super.dispose();
  }

  void _increment(BuildContext context) {
    setState(() {
      _counter++;
    });

    final OnboardingState onboading = Onboarding.of(context);

    onboading.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          focusNode: widget.focusNodes[4],
          icon: const Icon(Icons.menu),
          onPressed: () {
            widget.scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Focus(
          focusNode: widget.focusNodes[3],
          child: const Text('Title'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Focus(
              focusNode: widget.focusNodes[0],
              child: const Text('You have pushed the button this many times:'),
            ),
            Focus(
              focusNode: widget.focusNodes[2],
              child: Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Focus(
        focusNode: widget.focusNodes[1],
        child: FloatingActionButton(
          onPressed: () {
            _increment(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
