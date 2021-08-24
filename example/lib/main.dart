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
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();

    focusNodes = List<FocusNode>.generate(
      6,
      (int i) => FocusNode(debugLabel: 'Onboarding Focus Node $i'),
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
              title: 'Tap anywhere to continue Tap anywhere to continue',
              titleTextColor: Colors.black,
              bodyText: 'Tap anywhere to continue Tap anywhere to continue',
              labelBoxPadding: const EdgeInsets.all(16.0),
              labelBoxDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  color: const Color(0xFF00E1FF),
                  border: Border.all(
                    color: const Color(0xFF1E05FB),
                    width: 1.0,
                    style: BorderStyle.solid,
                  )),
              arrowPosition: ArrowPosition.bottomCenter,
              hasArrow: true,
              hasLabelBox: true,
              fullscreen: true,
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
              title: 'Easy to customize',
              bodyText: 'Easy to customize',
              overlayColor: Colors.red.withOpacity(0.9),
              labelBoxPadding: const EdgeInsets.all(16.0),
              labelBoxDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  color: const Color(0xFF1100FF),
                  border: Border.all(
                    color: const Color(0xFFE2FB05),
                    width: 1.0,
                    style: BorderStyle.solid,
                  )),
              arrowPosition: ArrowPosition.bottomCenter,
              hasArrow: true,
              hasLabelBox: true,
              textAlign: TextAlign.center,
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
              title: "Or no widget at all! You're all done!",
              bodyText: "Or no widget at all! You're all done!",
              margin: EdgeInsets.zero,
            ),
          ],
          onChanged: (int index) {
            if (index == 2) {
              // widget.scaffoldKey.currentState.openDrawer();

              // interrupt onboarding on specific step
              // widget.onboardingKey.currentState.hide();
            }
          },
          child: Home(
            focusNodes: focusNodes,
          ),
        ),
      );
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.focusNodes,
  }) : super(key: key);

  final List<FocusNode> focusNodes;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _counter;

  @override
  void initState() {
    super.initState();
    _counter = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _increment(BuildContext context) {
    setState(() {
      _counter++;
      final OnboardingState? onboarding = Onboarding.of(context);
      if (onboarding != null) {
        onboarding.show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          focusNode: widget.focusNodes[4],
          icon: const Icon(Icons.menu),
          onPressed: () {},
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
      floatingActionButton: FloatingActionButton(
        focusNode: widget.focusNodes[1],
        onPressed: () {
          _increment(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
