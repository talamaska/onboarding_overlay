import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';
import 'constants.dart';

enum ArrowPosition { centerLeft, centerRight, topCenter, bottomCenter }

class LabelPainter extends CustomPainter {
  LabelPainter({
    required this.title,
    this.body = '',
    required this.titleTextStyle,
    required this.bodyTextStyle,
    this.textAlign = TextAlign.start,
    required this.width,
    required this.height,
    this.opacity,
    this.hasLabelBox = false,
    this.labelBoxColor = const Color(0x00000000),
    this.labelBoxRadius = const Radius.circular(3.0),
    this.labelBoxPadding = const EdgeInsets.all(8.0),
    this.hasArrow = false,
    this.arrowPosition = ArrowPosition.bottomCenter,
  });

  final Color labelBoxColor;
  final Radius labelBoxRadius;
  final EdgeInsets labelBoxPadding;
  final String title;
  final String? body;
  final TextStyle titleTextStyle;
  final TextStyle bodyTextStyle;
  final double? opacity;
  final double width;
  final double height;
  final TextAlign textAlign;
  final bool hasLabelBox;
  final bool hasArrow;
  final ArrowPosition arrowPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final ParagraphBuilder builder = ParagraphBuilder(ParagraphStyle(
      textAlign: textAlign,
    ))
      ..pushStyle(titleTextStyle.getTextStyle())
      ..addText(title)
      ..addText("\n");

    if (body != null && body!.isNotEmpty) {
      builder
        ..pushStyle(bodyTextStyle.getTextStyle())
        ..addText(body!);
    }

    final Paragraph paragraph = builder.build()
      ..layout(ParagraphConstraints(
          width: width - labelBoxPadding.left - labelBoxPadding.right));

    final double paragraphHeight = paragraph.height;
    final double paragraphWidth = paragraph.width;

    final Rect paraRect = Offset(
          (size.width - paragraphWidth) / 2,
          (size.height - paragraphHeight) / 2,
        ) &
        Size(paragraphWidth, paragraphHeight);

    final Rect paddingBox = rectWithPadding(paraRect, labelBoxPadding);

    if (hasLabelBox) {
      final Rect rect = Rect.fromLTWH(
        paraRect.left - labelBoxPadding.left,
        paraRect.top - labelBoxPadding.top,
        paddingBox.width,
        paddingBox.height,
      );
      final RRect rrect = RRect.fromRectAndRadius(rect, labelBoxRadius);
      final Paint labelBoxPaint = Paint()..color = labelBoxColor;
      canvas.drawRRect(rrect, labelBoxPaint);
    }
    if (hasArrow) {
      final Paint paintBody = Paint()..color = labelBoxColor;
      const double a = 16;
      final double c = a / math.sin(radians(60));
      final double b = math.cos(radians(60)) * c;

      Path arrowPath = Path();

      switch (arrowPosition) {
        case ArrowPosition.bottomCenter:
          arrowPath = drawBottomCenterArrow(paddingBox, a, b);
          break;
        case ArrowPosition.topCenter:
          arrowPath = drawTopCenterArrow(paddingBox, a, b);
          break;
        case ArrowPosition.centerLeft:
          arrowPath = drawCenterLeftArrow(paddingBox, a, b);
          break;
        case ArrowPosition.centerRight:
          arrowPath = drawCenterRightArrow(paddingBox, a, b);
          break;
        default:
      }

      canvas.drawPath(arrowPath, paintBody);
    }

    canvas.drawParagraph(
        paragraph,
        Offset(
          (size.width - paragraphWidth) / 2,
          (size.height - paragraphHeight) / 2,
        ));
  }

  Path drawCenterRightArrow(Rect paddingBox, double a, double b) {
    return Path()
      ..moveTo(
        paddingBox.centerRight.dx,
        paddingBox.centerRight.dy,
      )
      ..lineTo(
        paddingBox.centerRight.dx,
        paddingBox.centerRight.dy - b,
      )
      ..lineTo(
        paddingBox.centerRight.dx + a,
        paddingBox.centerRight.dy,
      )
      ..lineTo(
        paddingBox.centerRight.dx,
        paddingBox.centerRight.dy + b,
      )
      ..lineTo(
        paddingBox.centerRight.dx,
        paddingBox.centerRight.dy,
      );
  }

  Path drawCenterLeftArrow(Rect paddingBox, double a, double b) {
    return Path()
      ..moveTo(
        paddingBox.centerLeft.dx,
        paddingBox.centerLeft.dy,
      )
      ..lineTo(
        paddingBox.centerLeft.dx,
        paddingBox.centerLeft.dy - b,
      )
      ..lineTo(
        paddingBox.centerLeft.dx - a,
        paddingBox.centerLeft.dy,
      )
      ..lineTo(
        paddingBox.centerLeft.dx,
        paddingBox.centerLeft.dy + b,
      )
      ..lineTo(
        paddingBox.centerLeft.dx,
        paddingBox.centerLeft.dy,
      );
  }

  Path drawBottomCenterArrow(Rect paddingBox, double a, double b) {
    return Path()
      ..moveTo(
        paddingBox.bottomCenter.dx,
        paddingBox.bottomCenter.dy,
      )
      ..lineTo(
        paddingBox.bottomCenter.dx - b,
        paddingBox.bottomCenter.dy,
      )
      ..lineTo(
        paddingBox.bottomCenter.dx,
        paddingBox.bottomCenter.dy + a,
      )
      ..lineTo(
        paddingBox.bottomCenter.dx + b,
        paddingBox.bottomCenter.dy,
      )
      ..lineTo(
        paddingBox.bottomCenter.dx,
        paddingBox.bottomCenter.dy,
      );
  }

  Path drawTopCenterArrow(Rect paddingBox, double a, double b) {
    return Path()
      ..moveTo(
        paddingBox.topCenter.dx,
        paddingBox.topCenter.dy,
      )
      ..lineTo(
        paddingBox.topCenter.dx - b,
        paddingBox.topCenter.dy,
      )
      ..lineTo(
        paddingBox.topCenter.dx,
        paddingBox.topCenter.dy - a,
      )
      ..lineTo(
        paddingBox.topCenter.dx + b,
        paddingBox.topCenter.dy,
      )
      ..lineTo(
        paddingBox.topCenter.dx,
        paddingBox.topCenter.dy,
      );
  }

  Rect rectWithPadding(Rect rect, EdgeInsets padding) {
    return Rect.fromLTRB(
      rect.left - padding.left,
      rect.top - padding.top,
      rect.right + padding.right,
      rect.bottom + padding.bottom,
    );
  }

  @override
  bool shouldRepaint(LabelPainter oldDelegate) =>
      opacity != oldDelegate.opacity ||
      width != oldDelegate.width ||
      height != oldDelegate.height ||
      title != oldDelegate.title ||
      body != oldDelegate.body ||
      titleTextStyle != oldDelegate.titleTextStyle ||
      bodyTextStyle != oldDelegate.bodyTextStyle ||
      labelBoxColor != oldDelegate.labelBoxColor ||
      labelBoxPadding != oldDelegate.labelBoxPadding ||
      labelBoxRadius != oldDelegate.labelBoxRadius ||
      hasArrow != oldDelegate.hasArrow;
}
