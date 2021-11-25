import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'constants.dart';
import 'label_painter.dart';
import 'overlay_painter.dart';
import 'step.dart';

class OnboardingStepper extends StatefulWidget {
  OnboardingStepper({
    Key? key,
    this.initialIndex = 0,
    required this.steps,
    this.duration = const Duration(milliseconds: 350),
    this.onChanged,
    this.onEnd,
    this.autoSizeTexts = false,
    this.stepIndexes = const <int>[],
  })  : assert(() {
          if (stepIndexes.isNotEmpty && !stepIndexes.contains(initialIndex)) {
            final List<DiagnosticsNode> information = <DiagnosticsNode>[
              ErrorSummary('stepIndexes should contain initialIndex'),
            ];

            throw FlutterError.fromParts(information);
          }
          return true;
        }()),
        super(key: key);

  /// is reqired
  final List<OnboardingStep> steps;

  /// By default, vali is 0
  final int initialIndex;

  /// By default stepIndexes os an empty array
  final List<int> stepIndexes;

  ///  `onChanged` is called everytime when the previous step has faded out,
  ///
  /// before the next step is shown with a value of the step index on which the user was
  final ValueChanged<int>? onChanged;

  /// `onEnd` is called when there are no more steps to transition to
  final ValueChanged<int>? onEnd;

  /// By default, the value is `Duration(milliseconds: 350)`
  final Duration duration;

  /// By default is false, turns on to usage of AutoSizeText widget and ignore maxLines
  final bool autoSizeTexts;

  @override
  _OnboardingStepperState createState() => _OnboardingStepperState();
}

class _OnboardingStepperState extends State<OnboardingStepper>
    with SingleTickerProviderStateMixin {
  late int stepperIndex;
  late ColorTween overlayColorTween;
  late AnimationController controller;
  late Animation<double> animation;
  late List<int> _stepIndexes;
  late RectTween holeTween;
  Offset? holeOffset;
  Rect? widgetRect;
  final GlobalKey overlayKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    stepperIndex = widget.initialIndex;
    _stepIndexes = List<int>.from(widget.stepIndexes);
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    animation = const AlwaysStoppedAnimation<double>(0.0);
    controller.addListener(() => setState(() {}));

    holeTween = RectTween(
      begin: Rect.zero,
      end: Rect.zero,
    );
    overlayColorTween = ColorTween(
      begin: const Color(0x00000000),
      end: const Color(0x00000000),
    );

    startStepper(fromIndex: widget.initialIndex);
  }

  Future<void> startStepper({int fromIndex = 0}) async {
    assert(() {
      if (widget.stepIndexes.isNotEmpty &&
          !widget.stepIndexes.contains(widget.initialIndex)) {
        final List<DiagnosticsNode> information = <DiagnosticsNode>[
          ErrorSummary('stepIndexes should contain initialIndex'),
        ];

        throw FlutterError.fromParts(information);
      }
      return true;
    }());
    assert(() {
      if (fromIndex >= widget.steps.length && fromIndex < 0) {
        final List<DiagnosticsNode> information = <DiagnosticsNode>[
          ErrorSummary(
              'fromIndex cannot be bigger then the number of steps or smaller than zero.'),
        ];

        throw FlutterError.fromParts(information);
      }
      return true;
    }());
    OnboardingStep step;

    if (widget.stepIndexes.isEmpty) {
      stepperIndex = fromIndex;
      step = widget.steps[stepperIndex];
      if (stepperIndex > 0) {
        await Future<void>.delayed(step.delay);
      }
    } else {
      stepperIndex = widget.initialIndex;
      _stepIndexes.removeAt(0);
      step = widget.steps[stepperIndex];
    }

    setTweensAndAnimate(step);
    step.focusNode.requestFocus();
  }

  Future<void> nextStep() async {
    assert(() {
      if (widget.stepIndexes.isNotEmpty &&
          !widget.stepIndexes.contains(widget.initialIndex)) {
        final List<DiagnosticsNode> information = <DiagnosticsNode>[
          ErrorSummary('stepIndexes should contain initialIndex'),
        ];

        throw FlutterError.fromParts(information);
      }
      return true;
    }());

    if (widget.stepIndexes.isEmpty) {
      await controller.reverse();
      widget.onChanged?.call(stepperIndex);

      if (stepperIndex < widget.steps.length - 1) {
        stepperIndex++;
      } else {
        widget.onEnd?.call(stepperIndex);
        return;
      }

      final OnboardingStep step = widget.steps[stepperIndex];
      if (stepperIndex > 0) {
        await Future<void>.delayed(step.delay);
      }
      if (stepperIndex < widget.steps.length && stepperIndex >= 0) {
        setTweensAndAnimate(step);
      }

      step.focusNode.requestFocus();
    } else {
      await controller.reverse();

      widget.onChanged?.call(stepperIndex);

      if (_stepIndexes.isEmpty) {
        widget.onEnd?.call(stepperIndex);
        return;
      }

      if (_stepIndexes.isNotEmpty) {
        stepperIndex = _stepIndexes.first;
        _stepIndexes.removeAt(0);
      }

      final OnboardingStep step = widget.steps[stepperIndex];
      await Future<void>.delayed(step.delay);

      if (widget.stepIndexes.indexWhere((int el) => el == stepperIndex) != -1) {
        setTweensAndAnimate(step);
      }

      step.focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void calcWidgetRect(OnboardingStep step) {
    final RenderBox? box =
        step.focusNode.context?.findRenderObject() as RenderBox?;

    holeOffset = box?.localToGlobal(Offset.zero);
    widgetRect = box != null ? holeOffset! & box.size : null;
    holeTween = widgetRect != null
        ? RectTween(
            begin: Rect.zero.shift(widgetRect!.center),
            end: step.margin.inflateRect(widgetRect!),
          )
        : RectTween(
            begin: Rect.zero,
            end: Rect.zero,
          );
  }

  void setTweensAndAnimate(OnboardingStep step) {
    overlayColorTween = ColorTween(
      begin: step.overlayColor.withOpacity(animation.value),
      end: step.overlayColor,
    );

    animation = CurvedAnimation(curve: Curves.ease, parent: controller);

    controller.forward(from: 0.0);
  }

  double _getHorizontalPosition(OnboardingStep step, Size size) {
    final double boxWidth = step.fullscreen
        ? size.width * kLabelBoxWidthRatioLarge
        : size.width * kLabelBoxWidthRatio;
    if (widgetRect != null) {
      if (widgetRect!.center.dx > size.width / 2) {
        return (widgetRect!.center.dx - boxWidth / 2)
            .clamp(0, size.width - boxWidth);
      } else if (widgetRect!.center.dx == size.width / 2) {
        return (widgetRect!.center.dx - boxWidth / 2)
            .clamp(0, size.width - boxWidth);
      } else {
        return (widgetRect!.center.dx - boxWidth / 2)
            .clamp(0, size.width - boxWidth);
      }
    } else {
      return size.width / 2 - boxWidth / 2;
    }
  }

  double _getVerticalPosition(OnboardingStep step, Size size) {
    final double boxHeight = size.shortestSide * kLabelBoxHeightRatio;
    final double bottomSpace = (step.hasArrow ? kArrowHeight + kSpace : kSpace);
    final double topSpace = (step.hasArrow ? kArrowHeight + kSpace : kSpace);
    if (widgetRect != null) {
      final Rect holeRect = step.margin.inflateRect(widgetRect!);

      if (widgetRect!.center.dy > size.height / 2) {
        return (holeRect.top - boxHeight - topSpace)
            .clamp(0, size.height - boxHeight);
      } else {
        return (holeRect.bottom + bottomSpace)
            .clamp(0, size.height - boxHeight);
      }
    } else {
      return size.height / 2 - boxHeight / 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = MediaQuery.of(context).size;
        final OnboardingStep step = widget.steps[stepperIndex];
        final double boxWidth = step.fullscreen
            ? size.width * kLabelBoxWidthRatioLarge
            : size.width * kLabelBoxWidthRatio;
        final double boxHeight = size.shortestSide * kLabelBoxHeightRatio;
        final ThemeData theme = Theme.of(context);

        final TextTheme textTheme = theme.textTheme;
        final TextStyle localTitleTextStyle =
            textTheme.headline5!.copyWith(color: step.titleTextColor);
        final TextStyle localBodyTextStyle =
            textTheme.bodyText1!.copyWith(color: step.bodyTextColor);

        final TextStyle stepTitleTextStyle = textTheme.headline5!.copyWith(
          color: step.titleTextStyle?.color ?? step.titleTextColor,
        );

        final TextStyle stepBodyTextStyle = textTheme.bodyText1!.copyWith(
          color: step.bodyTextStyle?.color ?? step.bodyTextColor,
        );

        final TextStyle activeTitleStyle = textTheme.headline5!.merge(
            step.titleTextStyle != null
                ? stepTitleTextStyle
                : localTitleTextStyle);

        final TextStyle activeBodyStyle = textTheme.bodyText1!.merge(
            step.bodyTextStyle != null
                ? stepBodyTextStyle
                : localBodyTextStyle);

        Rect holeRect = Rect.fromCenter(
          center: Offset(size.shortestSide / 2, size.longestSide / 2),
          width: 0,
          height: 0,
        );

        calcWidgetRect(step);

        if (widgetRect != null) {
          holeRect = step.margin.inflateRect(widgetRect!);
        }

        final bool isTop = holeRect.center.dy > size.height / 2;
        final double leftPos = _getHorizontalPosition(step, size);
        final double topPos = _getVerticalPosition(step, size);
        final Rect? hole = holeTween.evaluate(animation);

        return GestureDetector(
          behavior: step.overlayBehavior,
          onTapDown: (TapDownDetails details) {
            final RenderBox overlayBox =
                overlayKey.currentContext?.findRenderObject() as RenderBox;

            Offset localOverlay =
                overlayBox.globalToLocal(details.globalPosition);

            final BoxHitTestResult result = BoxHitTestResult();
            if (overlayBox.hitTest(result, position: localOverlay) ||
                step.overlayBehavior != HitTestBehavior.deferToChild) {
              nextStep();
            }
          },
          child: Stack(
            key: step.key,
            clipBehavior: Clip.antiAlias,
            children: <Widget>[
              RepaintBoundary(
                child: CustomPaint(
                  key: overlayKey,
                  size: Size(
                    size.width,
                    size.height,
                  ),
                  painter: OverlayPainter(
                    fullscreen: step.fullscreen,
                    shape: step.shape,
                    overlayShape: step.overlayShape,
                    center: step.focusNode.context == null
                        ? size.center(Offset.zero)
                        : null,
                    hole: hole ?? Rect.zero,
                    animation: animation.value,
                    overlayColor: overlayColorTween.evaluate(animation),
                  ),
                ),
              ),
              Positioned(
                left: leftPos,
                top: topPos,
                child: FadeTransition(
                  opacity: animation,
                  child: SizedBox(
                    width: boxWidth,
                    height: boxHeight,
                    child: Stack(
                      clipBehavior: Clip.antiAlias,
                      alignment:
                          isTop ? Alignment.bottomCenter : Alignment.topCenter,
                      children: [
                        RepaintBoundary(
                          child: CustomPaint(
                            painter: LabelPainter(
                              opacity: animation.value,
                              hasLabelBox: step.hasLabelBox,
                              labelBoxPadding: step.labelBoxPadding,
                              labelBoxDecoration: step.labelBoxDecoration,
                              hasArrow: step.hasArrow,
                              arrowPosition: step.arrowPosition,
                              hole: hole!.shift(Offset(-leftPos, -topPos)),
                            ),
                            child: SizedBox(
                              width: boxWidth,
                              child: Padding(
                                padding: step.labelBoxPadding,
                                child: step.stepBuilder != null
                                    ? step.stepBuilder!(
                                        context,
                                        step.title,
                                        activeTitleStyle,
                                        step.bodyText,
                                        activeBodyStyle,
                                      )
                                    : widget.autoSizeTexts
                                        ? AutoSizeText.rich(
                                            TextSpan(
                                              text: step.title,
                                              style: activeTitleStyle,
                                              children: <InlineSpan>[
                                                const TextSpan(text: '\n'),
                                                TextSpan(
                                                  text: step.bodyText,
                                                  style: activeBodyStyle,
                                                )
                                              ],
                                            ),
                                            textDirection:
                                                Directionality.of(context),
                                            textAlign: step.textAlign,
                                            minFontSize: 12,
                                          )
                                        : Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment: isTop
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                step.title,
                                                style: activeTitleStyle,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: step.textAlign,
                                                textDirection:
                                                    Directionality.of(context),
                                              ),
                                              Text(
                                                step.bodyText,
                                                style: activeBodyStyle,
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: step.textAlign,
                                                textDirection:
                                                    Directionality.of(context),
                                              )
                                            ],
                                          ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
