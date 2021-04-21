import 'package:flutter/widgets.dart';
import 'constants.dart';

class LabelPainter extends CustomPainter {
  LabelPainter({
    this.label,
    this.opacity,
    this.hole,
    this.viewport,
    this.color = const Color(0xFFFFFFFF),
    this.style,
    this.labelBoxRadius = 10.0,
    this.labelBoxColor = const Color(0xFF0A76F1),
    this.hasLabelBox = false,
    this.hasArrow = false,
    this.fullscreen = true,
    this.margin = const EdgeInsets.all(8.0),
  });

  final String? label;
  final double? opacity;
  final Rect? hole;
  final Size? viewport;
  final Color color;
  final TextStyle? style;
  final double labelBoxRadius;
  final Color labelBoxColor;
  final bool hasLabelBox;
  final bool hasArrow;
  final bool fullscreen;
  final EdgeInsets margin;

  @override
  void paint(Canvas canvas, Size size) {
    final TextPainter textPainter = _createTextPainter(color, opacity, style);

    textPainter.layout(maxWidth: size.width * (fullscreen ? 0.8 : 0.55));
    // debugPrint('$hole');
    final Offset offset = Offset(
      hole == null || fullscreen
          ? size.width / 2 - textPainter.size.width / 2
          : size.width -
              (size.width * kOverlayRatio +
                      hole!.width +
                      (size.width - hole!.right)) /
                  2 -
              textPainter.size.width / 2,
      hole == null
          ? Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero))
              .center
              .dy
          : hole!.center.dy <= viewport!.height / 2
              ? hole!.bottom +
                  textPainter.size.height +
                  (hasLabelBox ? margin.bottom * 3 : margin.bottom * 2)
              : hole!.top -
                  textPainter.size.height -
                  (hasLabelBox ? margin.top * 3 : margin.top * 2),
    );

    final Paint labelBoxPaint = Paint()
      ..color = labelBoxColor
      ..style = PaintingStyle.fill;

    final Path triangleTop = _createTriangleTopPath(offset, textPainter);
    final Path triangleBottom = _createTriangleBottomPath(offset, textPainter);

    if (hasLabelBox) {
      _drawLabelBox(
        canvas: canvas,
        offset: offset,
        textPainter: textPainter,
        labelBoxPaint: labelBoxPaint,
        triangleTop: triangleTop,
        triangleBottom: triangleBottom,
      );
    }

    textPainter.paint(canvas, offset);
  }

  TextPainter _createTextPainter(
    Color color,
    double? opacity,
    TextStyle? style,
  ) {
    return TextPainter(
      text: TextSpan(
        text: label,
        style: style ??
            TextStyle(
              color: color.withOpacity(opacity!),
            ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
  }

  void _drawLabelBox({
    required Canvas canvas,
    required Offset offset,
    required TextPainter textPainter,
    required Paint labelBoxPaint,
    Path? triangleTop,
    Path? triangleBottom,
  }) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          offset.dx - margin.top,
          offset.dy - margin.left,
          textPainter.size.width + margin.left + margin.right,
          textPainter.size.height + margin.top + margin.bottom,
        ),
        Radius.circular(labelBoxRadius),
      ),
      labelBoxPaint,
    );

    // debugPrint('hasArrow $hasArrow');
    if (hole != null && hasArrow) {
      if (hole!.center.dy <= viewport!.height / 2 && triangleTop != null) {
        canvas.drawPath(triangleTop, labelBoxPaint);
      }
      if (hole!.center.dy > viewport!.height / 2 && triangleBottom != null) {
        canvas.drawPath(triangleBottom, labelBoxPaint);
      }
    }
  }

  Path _createTriangleTopPath(Offset offset, TextPainter p) {
    return Path()
      ..moveTo(
        offset.dx + p.size.width / 2,
        offset.dy - p.size.height * 1.2,
      )
      ..lineTo(
        offset.dx + p.size.width / 2 - p.size.height / 2,
        offset.dy - p.size.height / 2 + 1,
      )
      ..lineTo(
        offset.dx + p.size.width / 2 + p.size.height / 2,
        offset.dy - p.size.height / 2 + 1,
      )
      ..close();
  }

  Path _createTriangleBottomPath(Offset offset, TextPainter p) {
    return Path()
      ..moveTo(
        offset.dx + p.size.width / 2,
        offset.dy + p.size.height * 2.2,
      )
      ..lineTo(
        offset.dx + p.size.width / 2 - p.size.height / 2,
        offset.dy + p.size.height + p.size.height / 2 - 1,
      )
      ..lineTo(
        offset.dx + p.size.width / 2 + p.size.height / 2,
        offset.dy + p.size.height + p.size.height / 2 - 1,
      )
      ..close();
  }

  @override
  bool shouldRepaint(LabelPainter oldDelegate) =>
      opacity != oldDelegate.opacity;
}
