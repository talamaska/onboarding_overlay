import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onboarding_overlay/src/stepper.dart';

import 'step.dart';

class Onboarding extends StatefulWidget {
  /// Onboarding is a widget that hold all the logic about reading the provided steps,
  /// launching OnboardingOverlay on demand, paginate trought steps and notify you
  /// via callbacks for the progress and the end of the onboarding session
  /// At least [steps] and [child] should be non-null
  ///
  /// This class creates an instance of [StatefulWidget].
  const Onboarding({
    Key? key,
    this.initialIndex = 0,
    this.onChanged,
    this.onEnd,
    required this.steps,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
  }) : super(key: key);

  final int initialIndex;
  final ValueChanged<int>? onChanged;
  final ValueChanged<int>? onEnd;

  /// is required
  final List<OnboardingStep> steps;

  /// is required
  final Widget child;

  /// By default, the value used is `Duration(milliseconds: 350)`
  final Duration duration;

  /// or
  /// context.findAncestorStateOfType\<OnboardingState\>();
  static OnboardingState? of(
    BuildContext context, {
    bool rootOnboarding = false,
    Widget? debugRequiredFor,
  }) {
    final OnboardingState? result = rootOnboarding
        ? context.findRootAncestorStateOfType<OnboardingState>()
        : context.findAncestorStateOfType<OnboardingState>();
    assert(() {
      if (debugRequiredFor != null && result == null) {
        final List<DiagnosticsNode> information = <DiagnosticsNode>[
          ErrorSummary('No Onboarding widget found.'),
          ErrorDescription(
              'Accessing the OnboardingState with Onboarding.of(context) needs an Onboarding widget ancestor'),
          ErrorHint(
              'The most common way to add an Onboarding to an application is to include it, below MaterialApp widget in the runApp() call.'),
          context.describeElement(
              'The context from which that widget was searching for an OnboardingState was')
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
  late OverlayEntry _overlayEntry;

  /// Shows an onboarding session with all steps provided and initial index passed via the widget
  void show() {
    _overlayEntry = _createOverlayEntry(initialIndex: widget.initialIndex);
    Overlay.of(context)!.insert(_overlayEntry);
  }

  /// Shows an onboarding session from a specific step index
  void showFromIndex(int index) {
    _overlayEntry = _createOverlayEntry(initialIndex: index);
    Overlay.of(context)!.insert(_overlayEntry);
  }

  /// Shows an onboarding session from a specific step index and a specific order and set of step indexes
  void showWithSteps(int index, List<int> stepIndexes) {
    _overlayEntry =
        _createOverlayEntry(initialIndex: index, stepIndexes: stepIndexes);
    Overlay.of(context)!.insert(_overlayEntry);
  }

  /// Hides the onboarding session overlay
  void hide() {
    _overlayEntry.remove();
  }

  OverlayEntry _createOverlayEntry({
    required int initialIndex,
    List<int> stepIndexes = const <int>[],
  }) {
    return OverlayEntry(
      opaque: false,
      builder: (BuildContext context) {
        return OnboardingStepper(
          initialIndex: initialIndex,
          steps: widget.steps,
          stepIndexes: stepIndexes,
          duration: widget.duration,
          onChanged: (int index) {
            widget.onChanged?.call(index);
          },
          onEnd: (int index) {
            widget.onEnd?.call(index);
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
