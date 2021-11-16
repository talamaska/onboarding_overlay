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
    required this.animation,
    required this.pulseAnimation,
    required this.pulseAnimationOuter,
    this.fullscreen = true,
    this.overlayColor = const Color(0xaa000000),
    this.pulseColor = const Color(0xFFFFFFFF),
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
  final double animation;
  final double pulseAnimation;
  final double pulseAnimationOuter;

  /// By default, value is `Color(0xFFFFFFFF)`
  final Color pulseColor;

  /// By default, value is `Color(0xaa000000)`
  final Color? overlayColor;
  final Offset? center;

  /// By default value is `true`
  final bool fullscreen;

  @override
  bool hitTest(Offset position) {
    final bool hit = !(hole.contains(position));
    return hit;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Path canvasPath = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final Path holePath = shape.getOuterPath(hole);
    final Rect overlayRect =
        EdgeInsets.all(size.width * kOverlayRatio * animation).inflateRect(
      center != null
          ? Rect.fromCircle(
              center: center!,
              radius: 0.0,
            )
          : hole,
    );
    final Path overlayPath = overlayShape.getOuterPath(overlayRect);

    final Path path = Path.combine(
      PathOperation.difference,
      fullscreen ? canvasPath : overlayPath,
      holePath,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = overlayColor!
        ..style = PaintingStyle.fill,
    );

    final Path pulse1 = shape.getOuterPath(hole.inflate(20 * pulseAnimation));
    final Path pulsePath1 = Path.combine(
      PathOperation.difference,
      pulse1,
      holePath,
    );
    canvas.drawPath(
      pulsePath1,
      Paint()
        ..color = pulseColor.withOpacity(0.5)
        ..style = PaintingStyle.fill,
    );
    final Path pulse2 =
        shape.getOuterPath(hole.inflate(35 * pulseAnimationOuter));
    final Path pulsePath2 = Path.combine(
      PathOperation.difference,
      pulse2,
      holePath,
    );
    canvas.drawPath(
      pulsePath2,
      Paint()
        ..color = pulseColor.withOpacity(0.2)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(OverlayPainter oldDelegate) =>
      hole != oldDelegate.hole ||
      animation != oldDelegate.animation ||
      pulseAnimation != oldDelegate.pulseAnimation ||
      pulseAnimationOuter != oldDelegate.pulseAnimationOuter ||
      overlayColor != oldDelegate.overlayColor;
}
