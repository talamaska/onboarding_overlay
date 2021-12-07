import 'package:flutter/widgets.dart';

import 'constants.dart';

class OverlayPainter extends CustomPainter {
  OverlayPainter({
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    this.overlayShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    required this.hole,
    this.center,
    required this.overlayAnimation,
    required this.pulseAnimationInner,
    required this.pulseAnimationOuter,
    this.fullscreen = true,
    this.overlayColor = const Color(0xaa000000),
    this.pulseInnerColor = defaultInnerPulseColor,
    this.pulseOuterColor = defaultOuterPulseColor,
    this.showPulseAnimation = false,
  });

  /// By default, the value is
  /// ```
  /// RoundedRectangleBorder(
  ///   borderRadius: BorderRadius.all(Radius.circular(8.0)),
  /// )
  /// ````
  final ShapeBorder shape;

  /// By default, the value is
  /// ```
  /// RoundedRectangleBorder(
  ///   borderRadius: BorderRadius.all(Radius.circular(8.0)),
  /// )
  /// ````
  final ShapeBorder overlayShape;
  final Rect hole;
  final double overlayAnimation;
  final double pulseAnimationInner;
  final double pulseAnimationOuter;

  /// By default, value is `Color(0xFFFFFFFF)`
  final Color pulseInnerColor;

  /// By default, value is `Color(0xFFFFFFFF)`
  final Color pulseOuterColor;

  /// By default, value is `Color(0xaa000000)`
  final Color? overlayColor;
  final Offset? center;

  /// By default value is `true`
  final bool fullscreen;

  /// By default value is `false`
  final bool showPulseAnimation;

  @override
  void paint(Canvas canvas, Size size) {
    final Path canvasPath = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final Path holePath = shape.getOuterPath(hole);
    final EdgeInsets overlayInsets =
        EdgeInsets.all(size.width * kOverlayRatio * overlayAnimation);
    final Rect overlayRect = overlayInsets.inflateRect(
      center != null
          ? Rect.fromCircle(
              center: center!,
              radius: 0.0,
            )
          : hole,
    );
    final Path overlayPath = overlayShape.getOuterPath(overlayRect);

    final Path mainPath = Path.combine(
      PathOperation.difference,
      fullscreen ? canvasPath : overlayPath,
      holePath,
    );

    canvas.drawPath(
      mainPath,
      Paint()
        ..color = overlayColor!
        ..style = PaintingStyle.fill,
    );

    if (hole.width != 0 && hole.height != 0 && showPulseAnimation) {
      final Rect pulseInnerRect = hole.inflate(20 * pulseAnimationInner);
      final Path pulseInnerPath = shape.getOuterPath(pulseInnerRect);
      final Path pulseInnerPathHole = Path.combine(
        PathOperation.difference,
        pulseInnerPath,
        holePath,
      );
      final Paint pulseInnerPaint = Paint()
        ..color = pulseInnerColor.withOpacity(0.5)
        ..style = PaintingStyle.fill;
      canvas.drawPath(pulseInnerPathHole, pulseInnerPaint);

      final Rect pulseOuterRect = hole.inflate(35 * pulseAnimationOuter);
      final Path pulseOuterPath = shape.getOuterPath(pulseOuterRect);
      final Path pulseOuterPathHole = Path.combine(
        PathOperation.difference,
        pulseOuterPath,
        pulseInnerPath,
      );
      final Paint pulseOuterPaint = Paint()
        ..color = pulseOuterColor.withOpacity(0.2)
        ..style = PaintingStyle.fill;
      canvas.drawPath(pulseOuterPathHole, pulseOuterPaint);
    }
  }

  @override
  bool shouldRepaint(OverlayPainter oldDelegate) =>
      hole != oldDelegate.hole ||
      overlayAnimation != oldDelegate.overlayAnimation ||
      pulseAnimationInner != oldDelegate.pulseAnimationInner ||
      pulseAnimationOuter != oldDelegate.pulseAnimationOuter ||
      overlayColor != oldDelegate.overlayColor;

  @override
  bool hitTest(Offset position) {
    final bool hit = !(hole.contains(position));
    // log('overlay hit $hit');
    return hit;
  }
}
