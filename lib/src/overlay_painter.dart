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
    this.hole,
    this.center,
    this.animation,
    this.fullscreen = true,
    this.overlayColor = const Color(0xaa000000),
    this.margin = EdgeInsets.zero,
  });

  /// By default, the value is
  /// ```
  /// RoundedRectangleBorder(
  ///   borderRadius: BorderRadius.all(Radius.circular(8.0)),
  /// )
  /// ````
  final ShapeBorder shape;

  /// By default, the value is ```EdgeInsets.zero```
  final EdgeInsets margin;

  /// By default, the value is
  /// ```
  /// RoundedRectangleBorder(
  ///   borderRadius: BorderRadius.all(Radius.circular(8.0)),
  /// )
  /// ````
  final ShapeBorder overlayShape;
  final Rect? hole;
  final double? animation;

  /// By default, value is `Color(0xaa000000)`
  final Color? overlayColor;
  final Offset? center;

  /// By default value is `true`
  final bool fullscreen;

  @override
  bool hitTest(Offset position) {
    return !(hole?.contains(position) ?? false);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Path canvasPath = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final Path holePath = shape.getOuterPath(hole ?? Rect.zero);
    final Path holeWithMarginPath = shape.getOuterPath(margin.inflateRect(hole ?? Rect.zero));
    final Rect overlayRect =
        EdgeInsets.all(size.width * kOverlayRatio * animation!).inflateRect(
      hole ??
          Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: 0.0,
          ),
    );
    final Path overlayPath = overlayShape.getOuterPath(overlayRect);

    // First path. Visible to user
    final Path path = Path.combine(
      PathOperation.difference,
      fullscreen ? canvasPath : overlayPath,
      holeWithMarginPath,
    );
    // Second path. Fills gap between first path and hole without margin
    // needed for avoiding user tap registration in this gap
    final Path secondPath = Path.combine(
      PathOperation.difference,
      holeWithMarginPath,
      holePath
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = overlayColor!
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      secondPath,
      Paint()
        ..color = const Color.fromARGB(0, 0, 0, 0) // transparent color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(OverlayPainter oldDelegate) =>
      hole != oldDelegate.hole ||
      animation != oldDelegate.animation ||
      overlayColor != oldDelegate.overlayColor;
}
