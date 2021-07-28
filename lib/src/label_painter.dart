import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';
import 'constants.dart';

enum ArrowPosition { centerLeft, centerRight, topCenter, bottomCenter }

const Color transparentColor = Color(0x00000000);

class LabelPainter extends CustomPainter {
  LabelPainter({
    required this.title,
    required this.titleTextStyle,
    this.body = '',
    required this.bodyTextStyle,
    this.textAlign = TextAlign.start,
    this.opacity = 1,
    this.hasArrow = false,
    this.hasLabelBox = false,
    this.arrowPosition = ArrowPosition.topCenter,
    this.arrowHeight = kArrowHeight,
    this.labelBoxPadding = const EdgeInsets.all(8.0),
    this.labelBoxDecoration = const BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      color: Color(0x00000000),
    ),
  })  : assert(
            (hasArrow && hasLabelBox) ||
                (!hasArrow && !hasLabelBox) ||
                !hasArrow && hasLabelBox,
            'hasArrow $hasArrow cannot be true if hasLabelBox $hasLabelBox is false'),
        _decoration = labelBoxDecoration.copyWith(
          shape: BoxShape.rectangle,
        );

  /// By default, the value is
  /// ```
  /// BoxDecoration(
  ///     shape: BoxShape.rectangle,
  ///     borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ///     color: Color(0x00000000),
  ///   )
  /// ```
  /// Any shape different from ```BoxShape.rectangle``` will be ignored
  final BoxDecoration labelBoxDecoration;

  /// By default, the value is EdgeInsets.all(8.0)
  final EdgeInsets labelBoxPadding;

  final BoxDecoration _decoration;

  /// Triangle height will be used to calculate all the side of equilateral triangle
  /// representing the arrow
  final double arrowHeight;

  /// By the default the value is ArrowPosition.topCenter
  /// you have to set the arrow position according to your widget position
  /// It will not be calculated automatically
  final ArrowPosition arrowPosition;

  /// By default, the value is TextAlign.start
  final TextAlign textAlign;

  final String title;
  final TextStyle titleTextStyle;

  /// By default, the value is an empty string and will not be displayed.
  final String body;
  final TextStyle bodyTextStyle;

  /// By default, the value is false
  final bool hasLabelBox;

  /// By default, the value is false. The arrow will not be displayed if the hasLabelBox is false.
  /// the background color and the border will be read from the the labelBoxDecoration
  final bool hasArrow;

  /// By default, the value is 1.
  /// This property is used for fading animation of the texts and the label box
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final Paragraph paragraph = buildParagraph(size);

    final Rect paragraphRect = Offset(
          (size.width - paragraph.width) / 2,
          (size.height - paragraph.height) / 2,
        ) &
        Size(paragraph.width, paragraph.height);

    final Rect paddingBox = rectWithPadding(paragraphRect, labelBoxPadding);

    final Paint paintBody = Paint()
      ..isAntiAlias = true
      ..color = _decoration.color?.withOpacity(opacity) ?? transparentColor;

    final Paint paintBorder = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..color = _decoration.border?.top.color.withOpacity(opacity) ??
          transparentColor;

    if (hasLabelBox) {
      final Offset labelOffset = Offset(
        paragraphRect.left - labelBoxPadding.left,
        paragraphRect.top - labelBoxPadding.top,
      );

      final Size labelSize = Size(
        paddingBox.width,
        paddingBox.height,
      );

      Path labelBoxPath = _decoration.getClipPath(
        labelOffset & labelSize,
        TextDirection.ltr,
      );

      Path arrowPath = Path();

      if (hasArrow) {
        final double a = arrowHeight;
        final double c = a / math.sin(radians(60));
        final double b = math.cos(radians(60)) * c;

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

        labelBoxPath =
            Path.combine(PathOperation.union, labelBoxPath, arrowPath);
      }

      canvas.drawPath(labelBoxPath, paintBorder);
      canvas.drawPath(labelBoxPath, paintBody);
    }

    canvas.drawParagraph(
        paragraph,
        Offset(
          (size.width - paragraph.width) / 2,
          (size.height - paragraph.height) / 2,
        ));
  }

  Paragraph buildParagraph(Size size) {
    final ParagraphBuilder builder = ParagraphBuilder(ParagraphStyle(
      textAlign: textAlign,
    ))
      ..pushStyle(titleTextStyle
          .copyWith(color: titleTextStyle.color?.withOpacity(opacity))
          .getTextStyle())
      ..addText(title)
      ..addText("\n");

    if (body.isNotEmpty) {
      builder
        ..pushStyle(bodyTextStyle
            .copyWith(color: bodyTextStyle.color?.withOpacity(opacity))
            .getTextStyle())
        ..addText(body);
    }

    final Paragraph paragraph = builder.build()
      ..layout(ParagraphConstraints(
        width: size.width - labelBoxPadding.left - labelBoxPadding.right,
      ));

    return paragraph;
  }

  Path drawCenterRightArrow(Rect paddingBox, double a, double b) {
    return Path()
      ..moveTo(
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
        paddingBox.centerRight.dx - labelBoxPadding.right,
        paddingBox.centerRight.dy + b,
      )
      ..lineTo(
        paddingBox.centerRight.dx - labelBoxPadding.right,
        paddingBox.centerRight.dy - b,
      )
      ..lineTo(
        paddingBox.centerRight.dx,
        paddingBox.centerRight.dy - b,
      );
  }

  Path drawCenterLeftArrow(Rect paddingBox, double a, double b) {
    return Path()
      ..moveTo(
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
        paddingBox.centerLeft.dx + labelBoxPadding.left,
        paddingBox.centerLeft.dy + b,
      )
      ..lineTo(
        paddingBox.centerLeft.dx + labelBoxPadding.left,
        paddingBox.centerLeft.dy - b,
      )
      ..lineTo(
        paddingBox.centerLeft.dx,
        paddingBox.centerLeft.dy - b,
      );
  }

  Path drawBottomCenterArrow(Rect paddingBox, double a, double b) {
    return Path()
      ..moveTo(
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
        paddingBox.bottomCenter.dx + b,
        paddingBox.bottomCenter.dy - labelBoxPadding.bottom,
      )
      ..lineTo(
        paddingBox.bottomCenter.dx - b,
        paddingBox.bottomCenter.dy - labelBoxPadding.bottom,
      )
      ..lineTo(
        paddingBox.bottomCenter.dx - b,
        paddingBox.bottomCenter.dy,
      );
  }

  Path drawTopCenterArrow(Rect paddingBox, double a, double b) {
    return Path()
      ..moveTo(
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
        paddingBox.topCenter.dx + b,
        paddingBox.topCenter.dy + labelBoxPadding.top,
      )
      ..lineTo(
        paddingBox.topCenter.dx - b,
        paddingBox.topCenter.dy + labelBoxPadding.top,
      )
      ..lineTo(
        paddingBox.topCenter.dx - b,
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
      title != oldDelegate.title ||
      body != oldDelegate.body ||
      titleTextStyle != oldDelegate.titleTextStyle ||
      bodyTextStyle != oldDelegate.bodyTextStyle ||
      labelBoxPadding != oldDelegate.labelBoxPadding ||
      labelBoxDecoration != oldDelegate.labelBoxDecoration ||
      arrowHeight != oldDelegate.arrowHeight ||
      arrowPosition != oldDelegate.arrowPosition ||
      textAlign != oldDelegate.textAlign ||
      hasLabelBox != oldDelegate.hasLabelBox ||
      hasArrow != oldDelegate.hasArrow;
}
