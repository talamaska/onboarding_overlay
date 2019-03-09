# overlay_onboard

An onboarding method that gets the user straight into the app and doesn't require any splash screens.

## Usage

1. Create your `List<OnboardSteps>` somewhere accessible

```dart
    steps = [
      OnboardStep(
          key: GlobalKey(),
          label: "Tap to increment & continue",
          //this sets the shape of the hole
          shape: CircleBorder(),
          //tappable defaults to true, which means any tap will proceed to the next step
          tappable: false,
          //if set you false, you must provide a stream to listen to for when to proceed
          proceed: onboardStream.stream,
          //you can also specify a margin
          margin: EdgeInsets.all(8.0),
      ),
      OnboardStep(key: GlobalKey(), label: "Tap anywhere to continue."),
      OnboardStep(key: GlobalKey(), label: "Easy to customise"),
      OnboardStep(key: GlobalKey(), label: "Add steps for any widget"),
    ];
```

2. Provide the `GlobalKey`s to the widgets. You could use `GlobalValueKey`s to avoid referencing the `List<OnboardSteps>`

```dart
    Text(
        'You have pushed the button this many times:',
        key: steps[1].key,
    ),
```

3. Add logic for the streams required to proceed, if you use this option

4. Call `onboard` after the first build. The easiest way is to use the following in an `initStat()`

```dart
WidgetsBinding.instance
      .addPostFrameCallback((_) => onboard(steps, context));
```

For help getting started with Flutter, view our [online documentation](https://flutter.io/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.
