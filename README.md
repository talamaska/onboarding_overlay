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

7. The Label box also supports having an arrow. This is controlled by `hasArrow`. The position is not calculated automatically. The default position is top. You will have to specify the position via arrowPosition by using the enum `ArrowPosition`. The `ArrowPosition.top` and `ArrowPosition.bottom` calculates the horizontal position automatically according to the widget of interest (the focused one which is visible through the overlay), the other arrow positions are centered in the label box e.g. `ArrowPosition.topCenter`, `ArrowPosition.bottomCenter`. In addition there are 2 new settings **from v3.0.0** - `ArrowPosition.autoVertical` and `ArrowPosition.autoVerticalCenter`, which will take care of positioning the arrow automatically relative to the label box and widget position.

8. The onboarding also supports forwarding the onTap event to the widget of interest. You can control the behavior for each step using the overlayBehavior. It accepts an enum OverlayBehavior. By default, the value used is `OverlayBehavior.defetToOverlay`.

- `OverlayBehavior.defetToOverlay` blocks the onTap on the widget and will trigger the onTap only on the overlay

- `OverlayBehavior.deferToChild` triggers only the onTap on the widget

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

12. **From v.3.0.0** if you want to show something else, different from just title and explanation text, then `stepBuilder` 
is for you. With `stepBuilder`, you can change the layout, add images or something else.

**Important:** If you want to inherit your App `Theme` from your app instead of using the style properties. You need to wrap your `stepBuilder` code with a `Scaffold` or `Material` widgets.

```dart
OnboardingStep(
  focusNode: focusNodes[0],
  titleText: 'Tap anywhere to continue ',
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
  arrowPosition: ArrowPosition.autoVertical,
  hasArrow: true,
  hasLabelBox: true,
  fullscreen: true,
  stepBuilder: (
    BuildContext context,
    OnboardingStepRenderInfo renderInfo,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            renderInfo.titleText,
            style: renderInfo.titleStyle,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/demo.gif',
                width: 50,
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: AutoSizeText(
                  renderInfo.bodyText,
                  style: renderInfo.bodyStyle,
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: renderInfo.nextStep,
                child: Text('Next'),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: renderInfo.close,
                child: Text('close'),
              ),
            ],
          ),
        ],
      ),
    );
  },
),
```

<img src="https://github.com/talamaska/onboarding_overlay/blob/master/screenshots/demo3.png?raw=true" width="320"/>

13. **From v.3.0.0** If you want to navigate to the next step but at the same time trigger some other event, or call some other function, you could use onTapCallback.

```dart
OnboardingStep(
  focusNode: focusNodes[4],
  titleText: 'Menu',
  bodyText: 'You can open menu from here',
  overlayColor: Colors.green.withOpacity(0.9),
  shape: const CircleBorder(),
  overlayBehavior: OverlayBehavior.deferToOverlay,
  onTapCallback:
      (TapArea area, VoidCallback next, VoidCallback close) {
    scaffoldKey.currentState?.openDrawer();
    next();
  },
),
```

14. **From v3.0.0** there is an additional `OverlayController` (ChangeNotifier) attached to the OverlayState that provides the `currentIndex`, `currentStep` and `isVisible`.

```dart
final OnboardingState? onboarding = Onboarding.of(context);
if( onboarding?.controller.isVisible ?? false) {
  // do some logic here
}
```

15. **From v.3.0.0** you can also add a pulsing animation around the focused widget. Pulse animation will be displayed if the `overlayBehavior` is `HitTestBehavior.deferToChild` or `HitTestBehavior.translucent` and `showPulseAnimation` on an `OnboardingStep` is set to `true`. In addition you can change the inner and outer colors of the pulse animation. Thanks to the author [Gautier](https://github.com/g-apparence) of the [pal](http://pub.dev/packages/pal) package for the inspiration.

<img src="https://github.com/talamaska/onboarding_overlay/blob/master/screenshots/demo4.gif?raw=true" width="320"/>

16. **From v.3.0.0** you can show a red border around the label box for debugging purposes by using an `Onboarding` parameter `debugBoundaries` which is `false` by default.

<img src="https://github.com/talamaska/onboarding_overlay/blob/master/screenshots/demo2.png?raw=true" width="320"/>
