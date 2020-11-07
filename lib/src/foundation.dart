import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const double kOverlayRatio = 0.65;
const double kLabelBoxWidthRatio = 0.55;
const double kLabelBoxHeightRatio = 0.45;

@immutable
class OnboardingStep {
  /// At least a [title] or a [bodyText] should be provided.
  ///
  /// At least a [titleTextColor] or a [titleTextStyle] should be provided.
  ///
  /// At least a [bodyTextColor] or a [bodyTextStyle] should be provided.
  const OnboardingStep({
    this.title,
    this.titleTextStyle,
    this.titleTextColor = const Color(0xFFFFFFFF),
    @required this.focusNode,
    this.bodyText,
    this.bodyTextStyle,
    this.bodyTextColor = const Color(0xFFFFFFFF),
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    this.margin = const EdgeInsets.all(8.0),
    this.overlayColor = const Color(0xC4000000),
    this.overlayShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    this.labelBoxDecoration = const BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      color: Color(0x00000000),
    ),
    this.labelBoxPadding = EdgeInsets.zero,
    this.hasLabelBox = false,
    this.hasArrow = false,
    this.fullscreen = true,
    this.delay = Duration.zero,
  })  : assert(titleTextColor != null || titleTextStyle != null),
        assert(bodyTextColor != null || bodyTextStyle != null),
        assert(title != null || bodyText != null),
        assert(focusNode != null);

  /// is required
  final FocusNode focusNode;

  /// By default, the value used is `Color(0xFFFFFFFF)`
  final Color titleTextColor;

  /// By default, the value used is `Color(0xFFFFFFFF)`
  final Color bodyTextColor;

  final String title;

  /// TextStyle localBodyTextStyle = Theme.of(context)
  ///   .textTheme
  ///   .heading5
  ///   .copyWith(color: step.titleTextColor)
  final TextStyle titleTextStyle;

  final String bodyText;

  /// TextStyle localBodyTextStyle = Theme.of(context)
  ///   .textTheme
  ///   .bodyText1
  ///   .copyWith(color: step.bodyTextColor)
  final TextStyle bodyTextStyle;

  /// By default, the value is
  /// ```
  /// RoundedRectangleBorder(
  ///   borderRadius: BorderRadius.all(Radius.circular(8.0)),
  /// )
  /// ````
  final ShapeBorder shape;

  /// By default, the value used is `Color(0xC4000000)`
  final Color overlayColor;

  /// By default, the value is
  /// ```
  /// RoundedRectangleBorder(
  ///   borderRadius: BorderRadius.all(Radius.circular(8.0)),
  /// )
  /// ```
  final ShapeBorder overlayShape;

  /// This is the space around the `Widget` we want which we would clip a whole
  /// By default, the value is `EdgeInsets.all(8.0)`
  final EdgeInsets margin;

  /// By default, the value is
  /// ```
  /// BoxDecoration(
  ///   shape: BoxShape.rectangle,
  ///   borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ///   color: Color(0x00000000),
  /// )
  /// ```
  final EdgeInsets labelBoxPadding;

  /// By default, the value used is false
  final BoxDecoration labelBoxDecoration;

  /// By default, the value used is false
  final bool hasLabelBox;

  /// By default, the value used is false
  final bool hasArrow;

  /// By default, the value used is true
  final bool fullscreen;

  /// By default, the value used is `Duration.zero`
  final Duration delay;

  OnboardingStep copyWith({
    FocusNode focusNode,
    Color titleTextColor,
    Color bodyTextColor,
    String title,
    TextStyle titleTextStyle,
    String bodyText,
    TextStyle bodyTextStyle,
    ShapeBorder shape,
    Color overlayColor,
    ShapeBorder overlayShape,
    EdgeInsets margin,
    EdgeInsets labelBoxPadding,
    BoxDecoration labelBoxDecoration,
    bool hasLabelBox,
    bool hasArrow,
    bool fullscreen,
    Duration delay,
  }) {
    return OnboardingStep(
      focusNode: focusNode ?? this.focusNode,
      titleTextColor: titleTextColor ?? this.titleTextColor,
      bodyTextColor: bodyTextColor ?? this.bodyTextColor,
      title: title ?? this.title,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      bodyText: bodyText ?? this.bodyText,
      bodyTextStyle: bodyTextStyle ?? this.bodyTextStyle,
      shape: shape ?? this.shape,
      overlayColor: overlayColor ?? this.overlayColor,
      overlayShape: overlayShape ?? this.overlayShape,
      margin: margin ?? this.margin,
      labelBoxPadding: labelBoxPadding ?? this.labelBoxPadding,
      labelBoxDecoration: labelBoxDecoration ?? this.labelBoxDecoration,
      hasLabelBox: hasLabelBox ?? this.hasLabelBox,
      hasArrow: hasArrow ?? this.hasArrow,
      fullscreen: fullscreen ?? this.fullscreen,
      delay: delay ?? this.delay,
    );
  }

  @override
  String toString() {
    return '''OnboardStep(
      focusNode: $focusNode,
      titleTextColor: $titleTextColor, 
      bodyTextColor: $bodyTextColor, 
      title: $title, 
      titleTextStyle: $titleTextStyle, 
      bodyText: $bodyText, 
      bodyTextStyle: $bodyTextStyle, 
      shape: $shape, 
      overlayColor: $overlayColor, 
      overlayShape: $overlayShape, 
      margin: $margin, 
      labelBoxPadding: $labelBoxPadding, 
      labelBoxDecoration: $labelBoxDecoration, 
      hasLabelBox: $hasLabelBox, 
      hasArrow: $hasArrow, 
      fullscreen: $fullscreen, 
      delay: $delay
    )''';
  }
}

class OnboardingStepper extends StatefulWidget {
  const OnboardingStepper({
    Key key,
    this.initialIndex = 0,
    @required this.steps,
    this.duration = const Duration(milliseconds: 350),
    this.onChanged,
    this.onEnd,
    this.stepIndexes = const <int>[],
  }) : super(key: key);

  /// is reqired
  final List<OnboardingStep> steps;

  /// By default, vali is 0
  final int initialIndex;

  /// By default stepIndexes os an empty array
  final List<int> stepIndexes;

  ///  `onChanged` is called everytime when the previous step has faded out,
  ///
  /// before the next step is shown with a value of the step index on which the user was
  final ValueChanged<int> onChanged;

  /// `onEnd` is called when there are no more steps to transition to
  final ValueChanged<int> onEnd;

  /// By default, the value is `Duration(milliseconds: 350)`
  final Duration duration;

  @override
  _OnboardingStepperState createState() => _OnboardingStepperState();
}

class _OnboardingStepperState extends State<OnboardingStepper>
    with SingleTickerProviderStateMixin {
  int _index;
  RectTween _hole;
  Offset _holeOffset;
  ColorTween _overlayColorTween;
  AnimationController _controller;
  Animation<double> _animation;
  Rect _widgetRect;
  List<int> _stepIndexes;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex ?? 0;
    _stepIndexes = List<int>.from(widget.stepIndexes) ?? <int>[];
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = const AlwaysStoppedAnimation<double>(0.0);
    _controller.addListener(() => setState(() {}));

    _hole = RectTween(
      begin: Rect.zero,
      end: Rect.zero,
    );
    _overlayColorTween = ColorTween(
      begin: const Color(0x00000000),
      end: const Color(0x00000000),
    );

    _proceed(init: true, fromIndex: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _prepare(OnboardingStep step) {
    final RenderBox box =
        step.focusNode?.context?.findRenderObject() as RenderBox;

    _holeOffset = box?.localToGlobal(Offset.zero);
    _widgetRect = box != null ? _holeOffset & box.size : null;
    _hole = _widgetRect != null
        ? RectTween(
            begin: Rect.zero.shift(_widgetRect.center),
            end: step.margin.inflateRect(_widgetRect),
          )
        : null;
    _overlayColorTween = ColorTween(
      begin: step.overlayColor.withOpacity(_animation.value),
      end: step.overlayColor,
    );

    _animation = CurvedAnimation(curve: Curves.ease, parent: _controller);

    _controller.forward(from: 0.0);
  }

  Future<void> _proceed({bool init = false, int fromIndex = 0}) async {
    if (widget.stepIndexes.isEmpty) {
      if (init) {
        _index = fromIndex != 0 ? fromIndex : 0;
      } else {
        await _controller.reverse();
        if (widget.onChanged != null) {
          widget.onChanged(_index);
        }
        if (_index < widget.steps.length - 1) {
          _index++;
        } else {
          widget.onEnd(_index);
          return;
        }
      }

      final OnboardingStep step = widget.steps[_index];
      if (_index > 0) {
        await Future<void>.delayed(step.delay);
      }
      if (_index < widget.steps.length && _index >= 0) {
        _prepare(step);
      }

      step.focusNode.requestFocus();
    } else {
      assert(() {
        if (widget.stepIndexes.contains(widget.initialIndex)) {
          final List<DiagnosticsNode> information = <DiagnosticsNode>[
            ErrorSummary('stepIndexes should contain initialIndex'),
          ];

          throw FlutterError.fromParts(information);
        }
        return true;
      }());
      if (init) {
        _index = widget.initialIndex ?? widget.stepIndexes.first;
        _stepIndexes.removeAt(0);
      } else {
        await _controller.reverse();
        if (widget.onChanged != null) {
          widget.onChanged(_index);
        }
        if (_stepIndexes.isEmpty) {
          widget.onEnd(_index);
          return;
        }
        if (_stepIndexes.isNotEmpty) {
          _index = _stepIndexes.first;
          _stepIndexes.removeAt(0);
        }
      }

      // debugPrint('stepIndexes ${widget.stepIndexes} $_stepIndexes $_index');

      final OnboardingStep step = widget.steps[_index];
      if (!init) {
        await Future<void>.delayed(step.delay);
      }

      if (widget.stepIndexes.indexWhere((int el) => el == _index) != -1) {
        _prepare(step);
      }
      step.focusNode.requestFocus();
    }
  }

  double _getHorizontalPosition(OnboardingStep step, Size size) {
    final double boxWidth =
        step.fullscreen ? size.width * 0.8 : size.width * 0.55;
    if (_widgetRect != null) {
      // final Rect holeRect = step.margin.inflateRect(_widgetRect);
      if (step.fullscreen) {
        return (size.width - boxWidth) / 2;
      } else {
        if (_widgetRect.center.dx > size.width / 2) {
          return _widgetRect.right - boxWidth - 6;
        } else if (_widgetRect.center.dx == size.width / 2) {
          return _widgetRect.center.dx - boxWidth / 2;
        } else {
          return _widgetRect.left + 10;
        }
      }
    } else {
      return size.width / 2 - boxWidth / 2;
    }
  }

  double _getVerticalPosition(OnboardingStep step, Size size) {
    final double boxHeight = size.width * 0.45;
    if (_widgetRect != null) {
      final Rect holeRect = step.margin.inflateRect(_widgetRect);
      if (step.fullscreen) {
        if (holeRect.center.dy > size.height / 2) {
          return holeRect.top - boxHeight - step.margin.bottom * 2;
        } else {
          return holeRect.bottom + step.margin.bottom * 2;
        }
      } else {
        if (_widgetRect.center.dy > size.height / 2) {
          return _widgetRect.top - boxHeight;
        } else {
          return _widgetRect.bottom + step.margin.bottom;
        }
      }
    } else {
      return size.height / 2 - boxHeight / 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final OnboardingStep step = widget.steps[_index];
    final double boxWidth =
        step.fullscreen ? size.width * 0.8 : size.width * 0.55;
    final double boxHeight = size.width * 0.45;

    final TextStyle localTitleTextStyle = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: step.titleTextColor);
    final TextStyle localBodyTextStyle = Theme.of(context)
        .textTheme
        .bodyText1
        .copyWith(color: step.bodyTextColor);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _proceed,
      child: Stack(
        children: [
          CustomPaint(
            child: Container(),
            painter: HolePainter(
              fullscreen: step.fullscreen,
              shape: step.shape,
              overlayShape: step.overlayShape,
              center: _holeOffset,
              hole: _hole?.evaluate(_animation),
              animation: _animation.value,
              overlayColor: _overlayColorTween?.evaluate(_animation),
            ),
          ),
          Positioned(
            left: _getHorizontalPosition(step, size),
            top: _getVerticalPosition(step, size),
            child: FadeTransition(
              opacity: _animation,
              child: Container(
                width: boxWidth,
                height: boxHeight,
                padding: step.hasLabelBox ? step.labelBoxPadding : null,
                decoration: step.hasLabelBox ? step.labelBoxDecoration : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (step.title != null)
                      Text(
                        step.title,
                        style: step.titleTextStyle ?? localTitleTextStyle,
                        textAlign: TextAlign.left,
                      ),
                    const SizedBox(
                      height: 8.0,
                      width: double.infinity,
                    ),
                    if (step.bodyText != null)
                      Text(
                        step.bodyText,
                        style: step.bodyTextStyle ?? localBodyTextStyle,
                      ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HolePainter extends CustomPainter {
  HolePainter({
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

  /// By default, value is `Color(0xaa000000)`
  final Color overlayColor;
  final Offset center;

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
    final Rect overlayRect =
        EdgeInsets.all(size.width * kOverlayRatio * animation).inflateRect(
      hole ??
          Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: 0.0,
          ),
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
        ..color = overlayColor
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(HolePainter oldDelegate) =>
      hole != oldDelegate.hole ||
      animation != oldDelegate.animation ||
      overlayColor != oldDelegate.overlayColor;
}

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

  final String label;
  final double opacity;
  final Rect hole;
  final Size viewport;
  final Color color;
  final TextStyle style;
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
                      hole.width +
                      (size.width - hole.right)) /
                  2 -
              textPainter.size.width / 2,
      hole == null
          ? Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero))
              .center
              .dy
          : hole.center.dy <= viewport.height / 2
              ? hole.bottom +
                  textPainter.size.height +
                  (hasLabelBox ? margin.bottom * 3 : margin.bottom * 2)
              : hole.top -
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
        size: size,
        offset: offset,
        textPainter: textPainter,
        labelBoxPaint: labelBoxPaint,
        triangleTop: triangleTop,
        triangleBottom: triangleBottom,
      );
    }

    textPainter.paint(canvas, offset);
  }

  TextPainter _createTextPainter(Color color, double opacity, TextStyle style) {
    return TextPainter(
      text: TextSpan(
        text: label,
        style: style ??
            TextStyle(
              color: color.withOpacity(opacity),
            ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
  }

  void _drawLabelBox({
    Canvas canvas,
    Size size,
    Offset offset,
    TextPainter textPainter,
    Paint labelBoxPaint,
    Path triangleTop,
    Path triangleBottom,
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
      if (hole.center.dy <= viewport.height / 2) {
        canvas.drawPath(triangleTop, labelBoxPaint);
      } else {
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
