[![Pub](https://img.shields.io/pub/v/onboarding_overlay)](https://pub.dev/packages/onboarding_overlay)

# onboarding_overlay

A flexible onboarding widget that can start and stop with an arbitrary number of steps
and arbitrary starting point

## Demo

<img src="https://github.com/talamaska/onboarding_overlay/blob/master/screenshots/demo.gif?raw=true"/>

## Usage

1. Create your `List<FocusNodes>` somewhere accessible

```dart
final List<FocusNode> overlayKeys = <FocusNode>[
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
```

2. Create your `List<OnboardingSteps>` somewhere accessible

```dart
final List<OnboardingSteps> steps = [OnboardingStep(
    focusNode: _focusNodes != null ? _focusNodes[0] : null,
    title: "Hi",
    titleTextStyle: Theme.of(context).textTheme.headline5.copyWith(
        color: Theme.of(context).canvasColor,
        ),
    bodyText:
        '''Check this out''',
    bodyTextStyle: Theme.of(context).textTheme.subtitle1.copyWith(
        color: Theme.of(context).canvasColor,
        ),
    hasLabelBox: false,
    fullscreen: true,
    overlayColor: Theme.of(context).primaryColorDark.withOpacity(0.8),
    hasArrow: false,
    ),]
```

3. Provide the `FocusNode`s to the widgets.

```dart
Focus(
    focusNode: focusNode[0]
    Text(
        'You have pushed the button this many times:',
    ),
)
```

4. Add Onboarding widget to your widget tree below MaterialWidget

```dart
void main() {
  runApp(App());
}

class App extends StatefulWidget {
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();

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
          steps: steps,
          onChanged: (int index) {
            debugPrint('----index $index');
            if (index == 5) {
              /// interrupt onboarding on specific step
              /// widget.onboardingKey.currentState.hide();
              /// or do something else
            }
          },
          child: Home(
            focusNodes: focusNodes,
          ),
        ),
      );
}
```

5. Show onboarding widget on some activity

```dart
final OnboardingState onboading = Onboarding.of(context);
onboading.show();
```

or immediately in initState

```dart
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final OnboardingState onboading = Onboarding.of(context);
      onboading.showWithSteps(3, <int>[3,4,5,6]);
    });
  }

```
