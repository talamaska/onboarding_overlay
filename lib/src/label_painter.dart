import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart' as vm;

import 'constants.dart';

enum ArrowPosition { centerLeft, centerRight, topCenter, bottomCenter }

const Color transparentColor = Color(0x00000000);

class LabelPainter extends CustomPainter {
  LabelPainter({
    this.opacity = 1,
    this.hasArrow = false,
    this.hasLabelBox = false,
    this.arrowPosition = ArrowPosition.topCenter,
    this.arrowHeight = kArrowHeight,
    this.isTop = false,
    this.labelBoxPadding = const EdgeInsets.all(8.0),
    this.labelBoxDecoration = const BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      color: transparentColor,
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

  /// By default, the value is false
  final bool hasLabelBox;

  /// By default, the value is false. The arrow will not be displayed if the hasLabelBox is false.
  /// the background color and the border will be read from the the labelBoxDecoration
  final bool hasArrow;

  /// By default, the value is 1.
  /// This property is used for fading animation of the texts and the label box
  final double opacity;

  /// Label box vertical positioning relative to the widget of interest
  final bool isTop;

  @override
  void paint(Canvas canvas, Size size) {
    Rect paragraphRect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

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
      Path labelBoxPath = _decoration.getClipPath(
        paragraphRect,
        TextDirection.ltr,
      );

      if (hasArrow) {
        Path arrowPath = Path();
        final double equilateralRad = vm.radians(60);
        final double a = arrowHeight;
        final double c = a / math.sin(equilateralRad);
        final double b = math.cos(equilateralRad) * c;

        switch (arrowPosition) {
          case ArrowPosition.bottomCenter:
            arrowPath = drawBottomCenterArrow(paragraphRect, a, b);
            break;
          case ArrowPosition.topCenter:
            arrowPath = drawTopCenterArrow(paragraphRect, a, b);
            break;
          case ArrowPosition.centerLeft:
            arrowPath = drawCenterLeftArrow(paragraphRect, a, b);
            break;
          case ArrowPosition.centerRight:
            arrowPath = drawCenterRightArrow(paragraphRect, a, b);
            break;
          default:
        }

        labelBoxPath =
            Path.combine(PathOperation.union, labelBoxPath, arrowPath);
      }

      canvas.drawPath(labelBoxPath, paintBorder);
      canvas.drawPath(labelBoxPath, paintBody);
    }
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

  @override
  bool shouldRepaint(LabelPainter oldDelegate) =>
      opacity != oldDelegate.opacity ||
      labelBoxPadding != oldDelegate.labelBoxPadding ||
      labelBoxDecoration != oldDelegate.labelBoxDecoration ||
      arrowHeight != oldDelegate.arrowHeight ||
      arrowPosition != oldDelegate.arrowPosition ||
      hasLabelBox != oldDelegate.hasLabelBox ||
      hasArrow != oldDelegate.hasArrow ||
      isTop != oldDelegate.isTop;
}
