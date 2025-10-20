import 'dart:developer';
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'constants.dart';
import 'label_painter.dart';
import 'overlay_painter.dart';
import 'step.dart';

const double sideGap = 5;
const Color debugBorderColor = Color(0xFFFF0000);
const TextStyle headlineStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.normal,
  color: Color(0xFF000000),
);

const TextStyle bodyTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.normal,
  color: Color(0xFF000000),
);

class OnboardingStepper extends StatefulWidget {
  OnboardingStepper({
    Key? key,
    this.initialIndex = 0,
    required this.steps,
    this.duration = const Duration(milliseconds: 350),
    this.pulseDuration = const Duration(milliseconds: 1000),
    this.onChanged,
    this.onEnd,
    this.autoSizeTexts = false,
    this.stepIndexes = const <int>[],
    this.debugBoundaries = false,
    this.scaleWidth = 1.0,
    this.scaleHeight = 1.0,
    required this.constraints,
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

  /// is required
  final List<OnboardingStep> steps;

  /// By default, value is 0
  final int initialIndex;

  /// By default stepIndexes os an empty array
  final List<int> stepIndexes;

  /// `onChanged` is called every time when the previous step has faded out,
  ///
  /// before the next step is shown with a value of the step index on which the user was
  final ValueChanged<int>? onChanged;

  /// `onEnd` is called when there are no more steps to transition to
  final ValueChanged<int>? onEnd;

  /// By default, the value is `Duration(milliseconds: 350)`
  final Duration duration;

  /// By default, the value is `Duration(milliseconds: 1000)`
  final Duration pulseDuration;

  /// By default is `false`, turns on to usage of `AutoSizeText` widget and ignore `maxLines`
  final bool autoSizeTexts;

  /// By default the value is false
  final bool debugBoundaries;

  final BoxConstraints constraints;

  /// By default the value is 1.0
  /// That property would be used with responsive_framework package
  final double scaleWidth;

  /// By default the value is 1.0
  /// That property would be used with responsive_framework package
  final double scaleHeight;

  @override
  OnboardingStepperState createState() => OnboardingStepperState();
}

class OnboardingStepperState extends State<OnboardingStepper>
    with TickerProviderStateMixin {
  late int stepperIndex;
  late ColorTween overlayColorTween;
  late AnimationController overlayController;
  late AnimationController pulseController;
  late Animation<double> overlayAnimation;
  late Animation<double> pulseAnimationInner;
  late Animation<double> pulseAnimationOuter;
  late List<int> _stepIndexes;
  late RectTween holeTween;
  late Offset holeOffset;
  late Rect widgetRect;
  final GlobalKey overlayKey = GlobalKey();
  final GlobalKey labelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _stepIndexes = List<int>.from(widget.stepIndexes);
    overlayController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() {
        setState(() {});
      });

    pulseController = AnimationController(
      vsync: this,
      duration: widget.pulseDuration,
    )..addListener(() {
        setState(() {});
      });

    overlayAnimation = CurvedAnimation(
      curve: Curves.ease,
      parent: overlayController,
    );

    pulseAnimationInner = CurvedAnimation(
      curve: Curves.ease,
      parent: pulseController,
    );

    pulseAnimationOuter = CurvedAnimation(
      curve: const Interval(
        0.0,
        0.8,
        curve: Curves.ease,
      ),
      parent: pulseController,
    );

    holeTween = RectTween(
      begin: Rect.zero,
      end: Rect.zero,
    );

    overlayColorTween = ColorTween(
      begin: null,
      end: null,
    );

    if (widget.steps.isNotEmpty) {
      startStepper(fromIndex: widget.initialIndex);
      calcWidgetRect(widget.steps[stepperIndex]);
    }
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

    if (widget.stepIndexes.isEmpty) {
      stepperIndex = fromIndex;
    } else {
      stepperIndex = widget.initialIndex;
      _stepIndexes.removeAt(0);
    }

    final OnboardingStep step = widget.steps[stepperIndex];

    if (stepperIndex > 0 && step.delay != Duration.zero) {
      await Future<void>.delayed(step.delay);
    }

    setTweensAndAnimate(step);
    step.focusNode.requestFocus();
  }

  Future<void> _nextStep() async {
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
      await overlayController.reverse();
      widget.onChanged?.call(stepperIndex);
      // await Future<void>.delayed(Duration(milliseconds: 1000));
      if (stepperIndex < widget.steps.length - 1) {
        setState(() {
          stepperIndex++;
        });
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
        step.focusNode.requestFocus();
      }
    } else {
      await overlayController.reverse();

      widget.onChanged?.call(stepperIndex);

      if (_stepIndexes.isEmpty) {
        widget.onEnd?.call(stepperIndex);
        return;
      }

      if (_stepIndexes.isNotEmpty) {
        setState(() {
          stepperIndex = _stepIndexes.first;
        });
        _stepIndexes.removeAt(0);
      }

      final OnboardingStep step = widget.steps[stepperIndex];
      await Future<void>.delayed(step.delay);

      if (widget.stepIndexes.indexWhere((int el) => el == stepperIndex) != -1) {
        setTweensAndAnimate(step);
        step.focusNode.requestFocus();
      }
    }
    setState(() {
      calcWidgetRect(widget.steps[stepperIndex]);
    });
  }

  @override
  void didUpdateWidget(OnboardingStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.constraints != widget.constraints) {
      setState(() {
        calcWidgetRect(widget.steps[stepperIndex]);
      });
    }
  }

  @override
  void dispose() {
    overlayController.dispose();
    pulseController.dispose();
    super.dispose();
  }

  void calcWidgetRect(OnboardingStep step) {
    final RenderBox? box =
        step.focusNode.context?.findRenderObject() as RenderBox?;

    holeOffset = box?.localToGlobal(Offset.zero) ?? Offset.zero;
    widgetRect = box != null
        ? holeOffset &
            Size(box.size.width * widget.scaleWidth,
                box.size.height * widget.scaleHeight)
        : Rect.zero;
    holeTween = RectTween(
      begin: Rect.zero.shift(widgetRect.center),
      end: step.margin.inflateRect(widgetRect),
    );
  }

  void _overlayStatusCallback(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      pulseController
        ..forward(from: 0.0)
        ..repeat(reverse: true);
    }

    if (status == AnimationStatus.reverse) {
      pulseController.reset();
    }
  }

  void setTweensAndAnimate(OnboardingStep step) async {
    overlayColorTween = ColorTween(
      begin: step.overlayColor.withOpacity(overlayAnimation.value),
      end: step.overlayColor,
    );

    overlayController.removeStatusListener(_overlayStatusCallback);

    if (step.showPulseAnimation) {
      overlayController.addStatusListener(_overlayStatusCallback);
    }

    await overlayController.forward(from: 0.0);
  }

  double _getHorizontalPosition(
    OnboardingStep step,
    Size size,
    double boxWidth,
  ) {
    if (widgetRect.width != 0 && widgetRect.height != 0) {
      return (widgetRect.center.dx - boxWidth / 2).clamp(
          sideGap, (size.width - boxWidth - sideGap).clamp(0, size.width));
    } else {
      return size.width / 2 - boxWidth / 2;
    }
  }

  double _getVerticalPosition(
    OnboardingStep step,
    Size size,
    double boxHeight,
    MediaQueryData media,
  ) {
    final double spacer = step.hasArrow ? kArrowHeight + kSpace : kSpace;

    if (widgetRect.width != 0 && widgetRect.height != 0) {
      final Rect holeRect = step.margin.inflateRect(widgetRect);

      if (holeRect.center.dy > size.height / 2) {
        // log('11. 0 - ${size.height - boxHeight}');
        return (holeRect.top - boxHeight - spacer)
            .clamp(0, (size.height - boxHeight).abs());
      } else {
        // log('12. 0 - ${size.height - boxHeight}');
        return (holeRect.bottom + spacer)
            .clamp(0, (size.height - boxHeight).abs());
      }
    } else if (!step.fullscreen) {
      return size.center(Offset.zero).dy - boxHeight / 2;
    } else {
      return media.padding.top;
    }
  }

  void _close() {
    widget.onEnd?.call(stepperIndex);
  }

  double _calcWidth(
    OnboardingStep step,
    Rect holeRect,
    Size mediaSize,
  ) {
    final double radius = mediaSize.width * kOverlayRatio;
    final double a = math.sqrt(math.pow(radius, 2) / 2);

    final double boxWidth = step.fullscreen
        ? (mediaSize.width - 2 * sideGap)
        : ((widgetRect.width != 0 && widgetRect.height != 0)
            ? a + holeRect.width / 4
            : a * 2);
    // log('boxWidth $boxWidth');
    return boxWidth;
  }

  double _calcHeight(
    OnboardingStep step,
    Rect holeRect,
    bool isTop,
    MediaQueryData media,
    Size mediaSize,
  ) {
    double boxHeight = 0;
    final double radius = mediaSize.width * kOverlayRatio;
    final double a = math.sqrt(math.pow(radius, 2) / 2);

    if (step.fullscreen) {
      if (widgetRect.width != 0 && widgetRect.height != 0) {
        if (isTop) {
          boxHeight = holeRect.top -
              sideGap -
              (step.hasArrow ? kArrowHeight + sideGap : sideGap) -
              media.padding.top -
              media.padding.bottom;
        } else {
          boxHeight = mediaSize.height -
              holeRect.bottom -
              sideGap -
              (step.hasArrow ? kArrowHeight + sideGap : sideGap) -
              media.padding.top -
              media.padding.bottom;
        }
      } else {
        boxHeight = (mediaSize.height -
                sideGap -
                (step.hasArrow ? kArrowHeight + sideGap : sideGap) -
                media.padding.top -
                media.padding.bottom)
            .clamp(0, mediaSize.height);
      }
    } else {
      if (widgetRect.width != 0 && widgetRect.height != 0) {
        if (isTop) {
          boxHeight = (a -
                  sideGap -
                  (step.hasArrow ? kArrowHeight + sideGap : sideGap) +
                  holeRect.height / 2)
              .clamp(
                  0,
                  holeRect.top -
                      sideGap -
                      (step.hasArrow ? kArrowHeight + sideGap : sideGap) -
                      step.margin.top -
                      media.padding.top -
                      media.padding.bottom);
        } else {
          boxHeight = (a -
                  sideGap -
                  (step.hasArrow ? kArrowHeight + sideGap : sideGap) +
                  holeRect.height / 2)
              .clamp(
                  0,
                  mediaSize.height -
                      holeRect.bottom -
                      sideGap -
                      (step.hasArrow ? kArrowHeight + sideGap : sideGap) -
                      step.margin.bottom -
                      media.padding.top -
                      media.padding.bottom);
        }
      } else {
        boxHeight = (a * 2).clamp(
            0,
            mediaSize.height -
                media.padding.top -
                media.padding.bottom -
                2 * kSpace);
      }
    }
    // log('radius ${mediaSize.width * kOverlayRatio}');
    // log('boxHeight $boxHeight');
    return boxHeight;
  }

  TextStyle _setupTitleStyle(OnboardingStep step, TextTheme textTheme) {
    final TextStyle localTitleTextStyle =
        (textTheme.headlineSmall ?? headlineStyle)
            .copyWith(color: step.titleTextColor);

    final TextStyle stepTitleTextStyle =
        (textTheme.headlineSmall ?? headlineStyle).copyWith(
      color: step.titleTextStyle?.color ?? step.titleTextColor,
    );

    final TextStyle activeTitleStyle =
        stepTitleTextStyle.merge(step.titleTextStyle ?? localTitleTextStyle);

    return activeTitleStyle;
  }

  TextStyle _setupBodyStyle(OnboardingStep step, TextTheme textTheme) {
    final TextStyle localBodyTextStyle = (textTheme.bodyLarge ?? bodyTextStyle)
        .copyWith(color: step.bodyTextColor);

    final TextStyle stepBodyTextStyle =
        (textTheme.bodyLarge ?? bodyTextStyle).copyWith(
      color: step.bodyTextStyle?.color ?? step.bodyTextColor,
    );

    final TextStyle activeBodyStyle =
        stepBodyTextStyle.merge(step.bodyTextStyle ?? localBodyTextStyle);

    return activeBodyStyle;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData media = MediaQuery.of(context);
    final Size mediaSize = media.size;
    final OnboardingStep step = widget.steps[stepperIndex];
    final TextTheme textTheme = theme.textTheme;

    final TextStyle activeTitleStyle = _setupTitleStyle(step, textTheme);
    final TextStyle activeBodyStyle = _setupBodyStyle(step, textTheme);

    Rect holeRect = Rect.fromCenter(
      center: Offset(mediaSize.shortestSide / 2, mediaSize.longestSide / 2),
      width: 0,
      height: 0,
    );

    if (widgetRect.width != 0 && widgetRect.height != 0) {
      holeRect = step.margin.inflateRect(widgetRect);
    }

    final bool isTop = holeRect.center.dy > mediaSize.height / 2;
    final double boxWidth = _calcWidth(step, holeRect, mediaSize);
    final double boxHeight = _calcHeight(
      step,
      holeRect,
      isTop,
      media,
      mediaSize,
    );

    final double leftPos = _getHorizontalPosition(step, mediaSize, boxWidth);
    final double topPos =
        _getVerticalPosition(step, mediaSize, boxHeight, media);
    final Rect? holeAnimatedValue = step.animateOverlayHole
        ? holeTween.evaluate(overlayAnimation)
        : holeRect;
    final Color? colorAnimatedValue =
        overlayColorTween.evaluate(overlayAnimation);

    log('=== LABEL POSITIONING ===');
    log('leftPos: $leftPos');
    log('topPos: $topPos');
    log('boxWidth: $boxWidth');
    log('boxHeight: $boxHeight');
    log('holeAnimatedValue (before shift): $holeAnimatedValue');

    return Listener(
      behavior: step.overlayBehavior,
      onPointerDown: (PointerDownEvent details) {
        // log('global listener');
        final BoxHitTestResult result = BoxHitTestResult();
        final RenderBox overlayBox =
            overlayKey.currentContext?.findRenderObject() as RenderBox;
        final Offset localOverlay = overlayBox.globalToLocal(details.position);

        if (step.onTapCallback != null) {
          final RenderBox labelBox =
              labelKey.currentContext?.findRenderObject() as RenderBox;
          final Offset localLabel = labelBox.globalToLocal(details.position);

          final bool isLabelClicked =
              labelBox.hitTest(result, position: localLabel);
          final bool isOverlayClicked =
              overlayBox.hitTest(result, position: localOverlay);
          final TapArea area = isOverlayClicked && !isLabelClicked
              ? TapArea.overlay
              : isOverlayClicked && isLabelClicked
                  ? TapArea.label
                  : TapArea.hole;
          log('onTapCallback $area');
          step.onTapCallback?.call(area, _nextStep, _close);
          return;
        }

        if (step.stepBuilder != null) {
          return;
        }

        if (overlayBox.hitTest(result, position: localOverlay) ||
            step.overlayBehavior != HitTestBehavior.deferToChild) {
          _nextStep();
        }
      },
      child: Stack(
        key: step.key,
        clipBehavior: Clip.antiAlias,
        children: <Widget>[
          AnimatedOverlay(
            overlayKey: overlayKey,
            size: mediaSize,
            step: step,
            holeAnimatedValue: holeAnimatedValue,
            overlayAnimation: overlayAnimation.value,
            pulseAnimationInner: pulseAnimationInner.value,
            pulseAnimationOuter: pulseAnimationOuter.value,
            colorAnimatedValue: colorAnimatedValue,
            isEmpty: !(widgetRect.width != 0 && widgetRect.height != 0),
          ),
          Positioned(
            left: leftPos,
            top: topPos,
            child: AnimatedLabel(
              labelKey: labelKey,
              overlayAnimation: overlayAnimation,
              debugBoundaries: widget.debugBoundaries,
              size: Size(boxWidth, boxHeight),
              isTop: isTop,
              step: step,
              isEmpty: !(widgetRect.width != 0 && widgetRect.height != 0),
              holeAnimatedValue:
                  holeAnimatedValue?.shift(Offset(-leftPos, -topPos)) ??
                      Rect.zero,
              leftPos: leftPos,
              topPos: topPos,
              autoSizeTexts: widget.autoSizeTexts,
              activeTitleStyle: activeTitleStyle,
              activeBodyStyle: activeBodyStyle,
              next: _nextStep,
              close: _close,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedLabel extends StatelessWidget {
  const AnimatedLabel({
    Key? key,
    required this.labelKey,
    required this.overlayAnimation,
    required this.debugBoundaries,
    required this.size,
    required this.isTop,
    required this.isEmpty,
    required this.step,
    required this.holeAnimatedValue,
    required this.leftPos,
    required this.topPos,
    required this.autoSizeTexts,
    required this.activeTitleStyle,
    required this.activeBodyStyle,
    required this.close,
    required this.next,
  }) : super(key: key);

  final Animation<double> overlayAnimation;
  final GlobalKey labelKey;
  final Size size;
  final bool isTop;
  final bool isEmpty;
  final OnboardingStep step;
  final Rect holeAnimatedValue;
  final double leftPos;
  final double topPos;
  final bool autoSizeTexts;
  final bool debugBoundaries;
  final TextStyle activeTitleStyle;
  final TextStyle activeBodyStyle;
  final VoidCallback close;
  final VoidCallback next;

  bool isNotEmptyHole() {
    return !isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: overlayAnimation,
      child: Container(
        decoration: debugBoundaries
            ? BoxDecoration(
                border: Border.all(color: debugBorderColor),
              )
            : null,
        width: size.width,
        height: size.height,
        child: Stack(
          clipBehavior: Clip.antiAlias,
          alignment: isNotEmptyHole()
              ? (isTop ? Alignment.bottomCenter : Alignment.topCenter)
              : Alignment.center,
          children: <Widget>[
            RepaintBoundary(
              child: CustomPaint(
                key: labelKey,
                painter: step.stepPainterBuilder != null
                    ? step.stepPainterBuilder
                        ?.call(context, holeAnimatedValue, isTop)
                    : LabelPainter(
                        opacity: 1,
                        hasLabelBox: step.hasLabelBox,
                        labelBoxPadding: step.labelBoxPadding,
                        labelBoxDecoration: step.labelBoxDecoration,
                        hasArrow: step.hasArrow,
                        arrowPosition: step.arrowPosition,
                        hole: holeAnimatedValue,
                        isTop: isTop,
                      ),
                child: step.stepBuilder != null
                    ? Padding(
                        padding: step.labelBoxPadding,
                        child: step.stepBuilder?.call(
                          context,
                          OnboardingStepRenderInfo(
                            titleText: step.titleText,
                            titleStyle: activeTitleStyle,
                            bodyText: step.bodyText,
                            bodyStyle: activeBodyStyle,
                            size: size,
                            nextStep: next,
                            close: close,
                          ),
                        ),
                      )
                    : SizedBox(
                        width: size.width,
                        child: Padding(
                          padding: step.labelBoxPadding,
                          child: autoSizeTexts
                              ? AutoSizeText.rich(
                                  TextSpan(
                                    text: step.titleText,
                                    style: activeTitleStyle,
                                    children: <InlineSpan>[
                                      const TextSpan(text: '\n'),
                                      TextSpan(
                                        text: step.bodyText,
                                        style: activeBodyStyle,
                                      )
                                    ],
                                  ),
                                  textDirection: Directionality.of(context),
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
                                  children: <Widget>[
                                    Text(
                                      step.titleText,
                                      style: activeTitleStyle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: step.textAlign,
                                      textDirection: Directionality.of(context),
                                    ),
                                    Text(
                                      step.bodyText,
                                      style: activeBodyStyle,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: step.textAlign,
                                      textDirection: Directionality.of(context),
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
    );
  }
}

class AnimatedOverlay extends StatelessWidget {
  const AnimatedOverlay({
    Key? key,
    required this.overlayKey,
    required this.size,
    required this.step,
    this.holeAnimatedValue,
    this.colorAnimatedValue,
    required this.overlayAnimation,
    required this.pulseAnimationInner,
    required this.pulseAnimationOuter,
    required this.isEmpty,
  }) : super(key: key);

  final GlobalKey<State<StatefulWidget>> overlayKey;
  final Size size;
  final OnboardingStep step;
  final Rect? holeAnimatedValue;
  final double overlayAnimation;
  final double pulseAnimationInner;
  final double pulseAnimationOuter;
  final Color? colorAnimatedValue;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        key: overlayKey,
        size: Size(
          size.width,
          size.height,
        ),
        painter: OverlayPainter(
          fullscreen: step.fullscreen,
          shape: step.shape,
          isEmpty: isEmpty,
          overlayShape: step.overlayShape,
          center:
              step.focusNode.context == null ? size.center(Offset.zero) : null,
          hole: holeAnimatedValue ?? Rect.zero,
          overlayAnimation: overlayAnimation,
          pulseInnerColor: step.pulseInnerColor,
          pulseOuterColor: step.pulseOuterColor,
          pulseAnimationInner: pulseAnimationInner,
          pulseAnimationOuter: pulseAnimationOuter,
          overlayColor: colorAnimatedValue ?? const Color(0xaa000000),
          showPulseAnimation: step.showPulseAnimation,
        ),
      ),
    );
  }
}
