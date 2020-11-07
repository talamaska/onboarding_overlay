import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onboard_overlay/src/foundation.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({
    Key key,
    this.initialIndex,
    this.onChanged,
    this.onEnd,
    @required this.steps,
    @required this.child,
  })  : assert(steps != null),
        assert(child != null),
        super(key: key);

  final int initialIndex;
  final ValueChanged<int> onChanged;
  final ValueChanged<int> onEnd;
  final List<OnboardStep> steps;
  final Widget child;

  static OnboardingState of(
    BuildContext context, {
    bool rootOnboarding = false,
    Widget debugRequiredFor,
  }) {
    final OnboardingState result = rootOnboarding
        ? context.findRootAncestorStateOfType<OnboardingState>()
        : context.findAncestorStateOfType<OnboardingState>();
    assert(() {
      if (debugRequiredFor != null && result == null) {
        final List<DiagnosticsNode> information = <DiagnosticsNode>[
          ErrorSummary('No Onboarding widget found.'),
          ErrorDescription(
              '${debugRequiredFor.runtimeType} widgets require an Onboarding widget ancestor for correct operation.'),
          ErrorHint(
              'The most common way to add an Onboarding to an application is to wrap your home page in your app.'),
          DiagnosticsProperty<Widget>(
              'The specific widget that failed to find an overlay was',
              debugRequiredFor,
              style: DiagnosticsTreeStyle.errorProperty),
          if (context.widget != debugRequiredFor)
            context.describeElement(
                'The context from which that widget was searching for an overlay was')
        ];

        throw FlutterError.fromParts(information);
      }
      return true;
    }());
    return result;
  }

  @override
  OnboardingState createState() => OnboardingState();
}

class OnboardingState extends State<Onboarding> {
  OverlayEntry _overlayEntry;

  void show() {
    _overlayEntry = _createOverlayEntry(initialIndex: widget.initialIndex);
    Overlay.of(context).insert(_overlayEntry);
  }

  void showFromIndex(int index) {
    _overlayEntry = _createOverlayEntry(initialIndex: index);
    Overlay.of(context).insert(_overlayEntry);
  }

  void showWithSteps(int index, List<int> stepIndexes) {
    _overlayEntry =
        _createOverlayEntry(initialIndex: index, stepIndexes: stepIndexes);
    Overlay.of(context).insert(_overlayEntry);
  }

  void hide() {
    _overlayEntry.remove();
  }

  OverlayEntry _createOverlayEntry({
    int initialIndex,
    List<int> stepIndexes = const <int>[],
  }) {
    return OverlayEntry(
      opaque: false,
      builder: (BuildContext context) {
        return OnboardingStepper(
          initialIndex: initialIndex ?? widget.initialIndex,
          steps: widget.steps,
          stepIndexes: stepIndexes,
          onChanged: (int index) {
            debugPrint('change from $index');
            if (widget.onChanged != null) {
              widget.onChanged(index);
            }
          },
          onEnd: (int index) {
            debugPrint('end --- $index');
            if (widget.onEnd != null) {
              widget.onEnd(index);
            }
            hide();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
