import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';

void main() {
  // timeDilation = 2;

  runApp(App());
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class App extends StatefulWidget {
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();

    focusNodes = List<FocusNode>.generate(
      18,
      (int i) => FocusNode(debugLabel: 'Onboarding Focus Node $i'),
      growable: false,
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Onboarding(
          key: widget.onboardingKey,
          autoSizeTexts: true,
          steps: <OnboardingStep>[
            OnboardingStep(
                focusNode: focusNodes[0],
                title: 'Tap anywhere to continue ',
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
                  ),
                ),
                arrowPosition: ArrowPosition.bottom,
                hasArrow: true,
                hasLabelBox: true,
                fullscreen: true,
                stepBuilder: (
                  BuildContext context,
                  String title,
                  TextStyle titleStyle,
                  String body,
                  TextStyle bodyStyle,
                ) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: titleStyle,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/demo.gif',
                              width: 50,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: AutoSizeText(
                                body,
                                style: bodyStyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            OnboardingStep(
              focusNode: focusNodes[1],
              title: 'left fab',
              bodyText: 'Tap to continue',
              shape: const CircleBorder(),
              fullscreen: false,
              overlayColor: Colors.blue.withOpacity(0.9),
              overlayShape: const CircleBorder(),
              hasLabelBox: true,
              labelBoxDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: const Color(0xFF1100FF),
                border: Border.all(
                  color: const Color(0xFFE2FB05),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            OnboardingStep(
              focusNode: focusNodes[2],
              title: 'right fab',
              bodyText: 'Tap only here to increment',
              shape: const CircleBorder(),
              fullscreen: false,
              overlayColor: Colors.blue.withOpacity(0.9),
              overlayShape: const CircleBorder(),
              overlayBehavior: HitTestBehavior.deferToChild,
            ),
            OnboardingStep(
              focusNode: focusNodes[3],
              title: 'Easy to customize Easy to customize',
              titleTextColor: Colors.greenAccent,
              titleTextStyle: const TextStyle(
                fontSize: 16.0,
              ),
              bodyText:
                  'Easy to customize Easy to customize Easy to customize Easy to customize',
              bodyTextColor: Colors.greenAccent,
              bodyTextStyle: const TextStyle(
                color: Colors.red,
                fontSize: 12.0,
                fontStyle: FontStyle.italic,
              ),
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
                ),
              ),
              arrowPosition: ArrowPosition.top,
              hasArrow: true,
              hasLabelBox: true,
              textAlign: TextAlign.center,
            ),
            OnboardingStep(
              focusNode: focusNodes[4],
              title: 'Menu',
              bodyText: 'You can open menu from here',
              overlayColor: Colors.green.withOpacity(0.9),
              shape: const CircleBorder(),
              overlayBehavior: HitTestBehavior.translucent,
            ),
            OnboardingStep(
              focusNode: focusNodes[5],
              title: 'Settings',
              shape: const CircleBorder(),
              bodyText:
                  'Click here to access settings such as dark mode, daily limit, etc',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
              labelBoxDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: const Color(0xFF1100FF),
                border: Border.all(
                  color: const Color(0xFFE2FB05),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              hasLabelBox: true,
            ),
            OnboardingStep(
              focusNode: focusNodes[6],
              title: 'Counter Value',
              bodyText: 'With automatic vertical positioning of the text',
              labelBoxPadding: const EdgeInsets.all(16.0),
              labelBoxDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                color: const Color(0xFF1100FF),
                border: Border.all(
                  color: const Color(0xFFE2FB05),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              arrowPosition: ArrowPosition.bottom,
              hasArrow: true,
              hasLabelBox: true,
            ),
            OnboardingStep(
              focusNode: focusNodes[7],
              title: "Or no widget at all! You're all done!",
              bodyText: "Or no widget at all! You're all done!",
              margin: EdgeInsets.zero,
              labelBoxPadding: const EdgeInsets.all(8.0),
              shape: const CircleBorder(),
              overlayShape: const CircleBorder(),
              fullscreen: false,
            ),
            OnboardingStep(
              focusNode: focusNodes[8],
              title: 'Icon 1',
              shape: const CircleBorder(),
              bodyText: 'Icon 1Icon 1Icon 1Icon 1Icon 1Icon 1Icon 1Icon 1',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
            ),
            OnboardingStep(
              focusNode: focusNodes[9],
              title: 'Icon 2',
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              bodyText:
                  'Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2Icon 2',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
            ),
            OnboardingStep(
              focusNode: focusNodes[10],
              title: 'Icon 3',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              bodyText:
                  'Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3Icon 3',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
              hasArrow: true,
              hasLabelBox: true,
              labelBoxDecoration: BoxDecoration(color: Colors.orange.shade900),
              arrowPosition: ArrowPosition.top,
            ),
            OnboardingStep(
              focusNode: focusNodes[11],
              title: 'Icon 4',
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              bodyText:
                  'Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4Icon 4',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
              hasArrow: true,
              hasLabelBox: true,
              labelBoxDecoration: const BoxDecoration(color: Colors.green),
              arrowPosition: ArrowPosition.top,
            ),
            OnboardingStep(
              focusNode: focusNodes[12],
              title: 'Icon 5',
              shape: const CircleBorder(),
              bodyText:
                  'Icon 5Icon 5Icon 5Icon 5Icon 5Icon 5Icon 5Icon 5Icon 5',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
            ),
            OnboardingStep(
              focusNode: focusNodes[13],
              title: 'No icon',
              bodyText: 'No iconNo iconNo iconNo iconNo iconNo iconNo iconNo ',
              fullscreen: true,
              overlayColor: Colors.black.withOpacity(0.8),
              hasArrow: true,
              hasLabelBox: true,
              labelBoxDecoration: const BoxDecoration(color: Colors.purple),
              arrowPosition: ArrowPosition.bottom,
            ),
            OnboardingStep(
              focusNode: focusNodes[14],
              title: 'Icon 7',
              shape: const CircleBorder(),
              bodyText: 'Icon 7Icon 7Icon 7Icon 7Icon ',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: const CircleBorder(),
            ),
            OnboardingStep(
              focusNode: focusNodes[15],
              title: 'Icon 8',
              shape: const CircleBorder(),
              bodyText: 'Icon 8Icon 8Icon 8Icon 8Icon 8Icon 8Icon ',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              hasArrow: true,
              hasLabelBox: true,
              labelBoxDecoration: BoxDecoration(color: Colors.cyan.shade900),
              arrowPosition: ArrowPosition.bottom,
            ),
            OnboardingStep(
              focusNode: focusNodes[16],
              title: 'Icon 9',
              shape: const CircleBorder(),
              bodyText: 'Icon 9Icon 9Icon 9Icon 9Icon ',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              hasArrow: true,
              hasLabelBox: true,
              labelBoxDecoration: BoxDecoration(
                color: Colors.pink.shade900,
              ),
              arrowPosition: ArrowPosition.bottom,
            ),
            OnboardingStep(
              focusNode: focusNodes[17],
              title: 'Icon 10',
              shape: const CircleBorder(),
              bodyText: 'Icon 10Icon 10Icon 10Icon 10Icon 10Icon 10Icon',
              fullscreen: false,
              overlayColor: Colors.black.withOpacity(0.8),
              overlayShape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ],
          onChanged: (int index) {
            if (index == 4) {
              // close the drawer
              if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
                scaffoldKey.currentState?.openEndDrawer();
              }
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          focusNode: widget.focusNodes[4],
          icon: const Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Focus(
          focusNode: widget.focusNodes[3],
          child: const Text('Super Long Title'),
        ),
        actions: [
          IconButton(
            focusNode: widget.focusNodes[5],
            icon: const Icon(Icons.mic),
            onPressed: () {},
          ),
          IconButton(
            // focusNode: widget.focusNodes[5],
            icon: const Icon(Icons.subscript),
            onPressed: () {},
          ),
          IconButton(
            // focusNode: widget.focusNodes[5],
            icon: const Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      drawer: const Drawer(
        child: Center(
          child: Text('Menu'),
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return index == 5
              ? Focus(
                  focusNode: widget.focusNodes[13],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Focus(
                            focusNode: widget.focusNodes[0],
                            child: const Text(
                                'You have pushed the button this many times:'),
                          ),
                          Focus(
                            focusNode: widget.focusNodes[6],
                            child: Text(
                              '$_counter',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : ListTile(
                  leading: Focus(
                    child: Icon(Icons.alarm),
                    focusNode: widget.focusNodes[index + 8],
                  ),
                  title: Text('Item ${index + 1}'),
                  trailing: Text('${index + 8}'),
                );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
              focusNode: widget.focusNodes[1],
              onPressed: () {
                final OnboardingState? onboarding = Onboarding.of(context);
                if (onboarding != null) {
                  onboarding.show();
                }
              },
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              focusNode: widget.focusNodes[2],
              onPressed: () {
                _increment(context);
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
