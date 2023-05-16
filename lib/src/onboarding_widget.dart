import 'package:flutter/material.dart';

import 'onboarding_controller.dart';
import 'step.dart';
import 'stepper.dart';

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
    this.autoSizeTexts = false,
    required this.steps,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.globalOnboarding = false,
    this.debugBoundaries = false,
    this.scaleHeight = 1.0,
    this.scaleWidth = 1.0,
  }) : super(key: key);

  /// The first index of the Onboarding, by default it is 0
  final int initialIndex;

  /// A callback that signal when the `Onboarding` changes step
  final ValueChanged<int>? onChanged;

  /// A callback that signal when the `Onboarding` is finished or stopped
  final ValueChanged<int>? onEnd;

  /// By default, the value used is false
  /// Sometimes the `titleText` and the `bodyText` might not fit well in the constrained label box,
  /// because of the long texts, longer translations or smaller screens.
  /// There are 2 behaviors for this scenario.
  /// The default one will limit the title to 2 lines and the bodyText to 5 lines
  /// and will overflow both with ellipsis, the second one is to automatically resize the texts.
  /// This is controlled by the Onboarding property `autoSizeTexts`, which default value is `false`.
  final bool autoSizeTexts;

  /// By default, the value used is `false`
  final bool debugBoundaries;

  /// is required
  final List<OnboardingStep> steps;

  /// is required
  final Widget child;

  /// By default, the value used is `Duration(milliseconds: 350)`
  final Duration duration;

  /// By default, the value used is `false`
  /// If your app has 2 or more top level contexts and the Onboarding is set in the widget tree of one of them
  /// Because the `Onboarding` is using `Overlay` from the closest context,
  /// you might end up with not covering the whole app with the `Overlay` and have wrong positions of the hole for the focused widget
  /// Change to `true` if you have one or both of the above mentiond problems.
  /// This will make the Onboarding to use the root level `Overlay`
  final bool globalOnboarding;

  /// By default the value is 1.0.
  /// That property would be used with responsive_framework package,
  /// which scales the widgets
  final double scaleWidth;

  /// By default the value is 1.0.
  /// That property would be used with responsive_framework package,
  /// which scales the widgets
  final double scaleHeight;

  /// Get the closest Onboarding state in the widget tree
  static OnboardingState? of(BuildContext context,
      {bool rootOnboarding = false}) {
    final OnboardingState? result = rootOnboarding
        ? context.findRootAncestorStateOfType<OnboardingState>()
        : context.findAncestorStateOfType<OnboardingState>();
    assert(() {
      if (result == null) {
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
  late OnboardingController controller;

  @override
  void initState() {
    super.initState();
    controller = OnboardingController(steps: widget.steps);
  }

  /// Shows an onboarding session with all steps provided and initial index passed via the widget
  void show() {
    if (widget.steps.isNotEmpty) {
      _overlayEntry = _createOverlayEntry(initialIndex: widget.initialIndex);
      Overlay.of(context, rootOverlay: widget.globalOnboarding)!
          .insert(_overlayEntry);
      controller.setIsVisible(true);
    }
  }

  /// Shows an onboarding session from a specific step index
  void showFromIndex(int index) {
    if (widget.steps.isNotEmpty) {
      _overlayEntry = _createOverlayEntry(initialIndex: index);
      Overlay.of(context, rootOverlay: widget.globalOnboarding)!
          .insert(_overlayEntry);
      controller.setIsVisible(true);
    }
  }

  /// Shows an onboarding session from a specific step index and a specific order and set of step indexes
  void showWithSteps(int index, List<int> stepIndexes) {
    if (widget.steps.isNotEmpty && stepIndexes.isNotEmpty) {
      _overlayEntry =
          _createOverlayEntry(initialIndex: index, stepIndexes: stepIndexes);
      Overlay.of(context, rootOverlay: widget.globalOnboarding)!
          .insert(_overlayEntry);
      controller.setIsVisible(true);
    }
  }

  /// Hides the onboarding session overlay
  void hide() {
    if (!controller.isVisible) {
      return;
    }
    _overlayEntry.remove();
    controller.setIsVisible(false);
  }

  /// Returns true if onboarding session overlay is visible to user
  bool isVisible() {
    return controller.isVisible;
  }

  OverlayEntry _createOverlayEntry({
    required int initialIndex,
    List<int> stepIndexes = const <int>[],
  }) {
    controller.setCurrentIndex(initialIndex);
    return OverlayEntry(
      opaque: false,
      builder: (BuildContext context) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return OnboardingStepper(
            constraints: constraints,
            initialIndex: initialIndex,
            steps: widget.steps,
            stepIndexes: stepIndexes,
            duration: widget.duration,
            autoSizeTexts: widget.autoSizeTexts,
            debugBoundaries: widget.debugBoundaries,
            scaleWidth: widget.scaleWidth,
            scaleHeight: widget.scaleHeight,
            onChanged: (int index) {
              controller.setCurrentIndex(index);
              widget.onChanged?.call(index);
            },
            onEnd: (int index) {
              controller.setCurrentIndex(index);
              widget.onEnd?.call(index);
              hide();
            },
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
