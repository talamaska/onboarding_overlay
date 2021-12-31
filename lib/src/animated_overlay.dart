import 'package:flutter/widgets.dart';

import 'overlay_painter.dart';
import 'step.dart';

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
