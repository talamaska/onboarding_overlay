[![Pub](https://img.shields.io/pub/v/onboarding_overlay?include_prereleases)](https://pub.dev/packages/onboarding_overlay)

# onboarding_overlay

A flexible onboarding widget that can start and stop with an arbitrary number of steps
and arbitrary starting point

## Demo
<img src="https://github.com/talamaska/onboarding_overlay/blob/master/screenshots/demo.gif?raw=true" width="320"/>

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

4. Add Onboarding widget to your widget tree below MaterialWidget and above of everything else

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

5. Showing the onboarding 

  - On some activity somewhere down the widget tree in another widget with a new BuildContext

```dart
final OnboardingState? onboarding = Onboarding.of(context);

if (onboarding != null) {
  onboarding.show();
}
```
 - Or immediately in initState somewhere down the widget tree in another widget with a new BuildContext


```dart
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final OnboardingState? onboarding = Onboarding.of(context);
      if (onboarding != null) {
        onboarding.show();
      }
    });
  }

```

6. The text can be wrapped in a box, than support all kind of decorations and only shape: BoxShape.rectangle
For this to happen, you have to set `hasLabelBox` equal to `true`, `labelBoxDecoration`, which supports only `BoxDecoration`

7. The Label box also supports having an arrow. This is controlled by `hasArrow`. The position is not calculated automatically. The default position is top. You will have to specify the position via arrowPosition by using the enum `ArrowPosition`. The `ArrowPosition.top` and `ArrowPosition.bottom` calculates the horizontal position automatically according to the widget of interest (the focused one which is visible through the overlay), the other arrow positions are centered in the label box e.g. topCenter, bottomCenter, leftCenter and rightCenter.

8. The onboarding also supports forwarding the onTap event to the widget of interest. You can control the behavior for each step using the overlayBehavior. It accepts the Flutter enum HitTestBehavior. By default, the value used is `HitTestBehavior.opaque`.
  - `HitTestBehavior.opaque` blocks the onTap on the widget and will trigger the onTap only on the overlay
  - `HitTestBehavior.translucent` triggers onTap callbacks on the widget and on the overlay
  - `HitTestBehavior.deferToChild` triggers only the onTap on the widget

9. Sometimes the title and the bodyText might not fit well in the constrained label box, because of the long texts, longer translations or smaller screens. There are 2 behaviors for this scenario. The default one will limit the title to 2 lines and the bodyText to 5 lines and will overflow both with ellipsis, the second one is to automatically resize the texts. This is controlled by the Onboarding property `autoSizeTexts`, which default value is `false`. 

10. The onboarding can show only a portion of the defined steps with a specific start index. Use `showWithSteps` method. Remember that the steps indexes are 0-based (starting from zero)

```dart
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final OnboardingState? onboarding = Onboarding.of(context);
      if (onboarding != null) {
        onboarding.showWithSteps(3, <int>[3,4,5,6]);
      }
    });
  }

```

11. The onboarding can start from a specific index and play until the end step is reached. Use `showFromIndex` method. Remember that the steps indexes are 0-based (starting from zero)

```dart
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final OnboardingState? onboarding = Onboarding.of(context);
      if (onboarding != null) {
        onboarding.showFromIndex(3);
      }
    });
  }

```


