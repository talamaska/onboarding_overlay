import 'package:flutter/widgets.dart';

import 'overlay_painter.dart';
import 'step.dart';

class AnimatedOverlay extends StatefulWidget {
  const AnimatedOverlay({
    Key? key,
    required this.overlayKey,
    required this.size,
    required this.step,
    required this.holeAnimatedValue,
    required this.overlayAnimation,
    required this.overlayController,
    required this.pulseController,
  }) : super(key: key);

  final GlobalKey<State<StatefulWidget>> overlayKey;
  final Size size;
  final OnboardingStep step;
  final Rect? holeAnimatedValue;
  final Animation<double> overlayAnimation;

  final AnimationController overlayController;
  final AnimationController pulseController;

  @override
  State<AnimatedOverlay> createState() => _AnimatedOverlayState();
}

class _AnimatedOverlayState extends State<AnimatedOverlay> {
  late Animation<double> pulseAnimationInner;
  late Animation<double> pulseAnimationOuter;
  late ColorTween overlayColorTween;

  void overlayStatusCallback(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.pulseController
        ..forward(from: 0.0)
        ..repeat(reverse: true);
    }

    if (status == AnimationStatus.reverse) {
      widget.pulseController.reset();
    }
  }

  @override
  void initState() {
    super.initState();

    overlayColorTween = ColorTween(
      begin: null,
      end: null,
    );

    pulseAnimationInner = CurvedAnimation(
      curve: Curves.ease,
      parent: widget.pulseController,
    );

    pulseAnimationOuter = CurvedAnimation(
      curve: const Interval(
        0.0,
        0.8,
        curve: Curves.ease,
      ),
      parent: widget.pulseController,
    );

    widget.overlayController.addListener(() {
      setState(() {});
    });

    widget.pulseController.addListener(() {
      setState(() {});
    });

    overlayColorTween = ColorTween(
      begin:
          widget.step.overlayColor.withOpacity(widget.overlayAnimation.value),
      end: widget.step.overlayColor,
    );

    if (widget.step.showPulseAnimation) {
      widget.overlayController.addStatusListener(overlayStatusCallback);
    }
  }

  @override
  void didUpdateWidget(AnimatedOverlay oldWidget) {
    if (oldWidget.step != widget.step) {
      overlayColorTween = ColorTween(
        begin:
            widget.step.overlayColor.withOpacity(widget.overlayAnimation.value),
        end: widget.step.overlayColor,
      );

      widget.overlayController.removeStatusListener(overlayStatusCallback);

      if (widget.step.showPulseAnimation) {
        widget.overlayController.addStatusListener(overlayStatusCallback);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        key: widget.overlayKey,
        size: Size(
          widget.size.width,
          widget.size.height,
        ),
        painter: OverlayPainter(
          fullscreen: widget.step.fullscreen,
          shape: widget.step.shape,
          overlayShape: widget.step.overlayShape,
          center: widget.step.focusNode.context == null
              ? widget.size.center(Offset.zero)
              : null,
          hole: widget.holeAnimatedValue ?? Rect.zero,
          overlayAnimation: widget.overlayAnimation.value,
          pulseInnerColor: widget.step.pulseInnerColor,
          pulseOuterColor: widget.step.pulseOuterColor,
          pulseAnimationInner: pulseAnimationInner.value,
          pulseAnimationOuter: pulseAnimationOuter.value,
          overlayColor: overlayColorTween.evaluate(widget.overlayAnimation),
          showPulseAnimation: widget.step.showPulseAnimation,
        ),
      ),
    );
  }
}
