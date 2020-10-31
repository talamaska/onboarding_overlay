import 'package:flutter/widgets.dart';

const double kOverlayRatio = 0.65;

@immutable
class OnboardStep {
  const OnboardStep({
    @required this.key,
    this.label = '',
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    this.overlayShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    this.margin = const EdgeInsets.all(8.0),
    // this.tappable = true,
    // this.proceed,
    // this.callback,
    this.overlayColor = const Color(0xaa000000),
    this.textColor = const Color(0xFFFFFFFF),
    this.textStyle,
    this.labelBoxRadius = 10.0,
    this.labelBoxColor = const Color(0xFF0A76F1),
    this.hasLabelBox = false,
    this.hasArrow = false,
    this.fullscreen = true,
  });

  final GlobalKey key;
  final String label;
  final ShapeBorder shape;
  final ShapeBorder overlayShape;
  final EdgeInsets margin;
  // final bool tappable;
  // final Stream<dynamic> proceed;
  // final Function callback;
  final Color textColor;
  final Color overlayColor;
  final TextStyle textStyle;
  final double labelBoxRadius;
  final Color labelBoxColor;
  final bool hasLabelBox;
  final bool hasArrow;
  final bool fullscreen;
}

void onboard(List<OnboardStep> steps, BuildContext context) {
  Navigator.of(context).push<dynamic>(
    OnboardRoute(
      steps: steps,
    ),
  );
}

class OnboardRoute extends TransitionRoute<dynamic> {
  OnboardRoute({@required this.steps});
  final List<OnboardStep> steps;

  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Iterable<OverlayEntry> createOverlayEntries() sync* {
    yield OverlayEntry(
      builder: (BuildContext context) => buildTransitions(
        context,
        animation,
        secondaryAnimation,
        OnboardWidget(
          steps: steps,
          onEnd: () {},
        ),
      ),
    );
  }

  @override
  bool get opaque => false;
}

class OnboardWidget extends StatefulWidget {
  const OnboardWidget({
    this.initialIndex,
    this.steps,
    this.onChanged,
    @required this.onEnd,
  });
  final List<OnboardStep> steps;
  final ValueChanged<int> onChanged;
  final VoidCallback onEnd;
  final int initialIndex;

  @override
  _OnboardWidgetState createState() => _OnboardWidgetState();
}

class _OnboardWidgetState extends State<OnboardWidget>
    with SingleTickerProviderStateMixin {
  int index;
  RectTween _hole;
  Offset _holeOffset;
  ColorTween _colorTween;
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex ?? 0;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _hole = RectTween(begin: Rect.zero, end: Rect.zero);

    _animation = const AlwaysStoppedAnimation<double>(0.0);
    _controller.addListener(() => setState(() {}));

    _proceed(init: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _proceed({bool init = false}) async {
    if (init) {
      index = 0;
    } else {
      await _controller.reverse();
      index++;

      if (index >= widget.steps.length) {
        index--;
        widget.onEnd();
        return;
      }
      if (widget.onChanged != null) {
        widget.onChanged(index);
      }
    }
    if (index < widget.steps.length && index >= 0) {
      final RenderBox box = widget.steps[index].key?.currentContext
          ?.findRenderObject() as RenderBox;

      _holeOffset = box?.localToGlobal(Offset.zero);

      final Rect widgetRect = box != null ? _holeOffset & box.size : null;
      _hole = widgetRect != null
          ? RectTween(
              begin: Rect.zero.shift(widgetRect.center),
              end: widget.steps[index].margin.inflateRect(widgetRect),
            )
          : null;

      final Color color = widget.steps[index].overlayColor;

      _colorTween = ColorTween(
        begin: color.withOpacity(_animation.value),
        end: color,
      );
      _animation = CurvedAnimation(curve: Curves.ease, parent: _controller);

      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _proceed,
      child: CustomPaint(
        child: Container(),
        painter: HolePainter(
          fullscreen: widget.steps[index].fullscreen,
          shape: widget.steps[index].shape,
          overlayShape: widget.steps[index].overlayShape,
          center: _holeOffset,
          hole: _hole?.evaluate(_animation),
          animation: _animation.value,
          overlayColor: _colorTween?.evaluate(_animation),
        ),
        foregroundPainter: LabelPainter(
          label: widget.steps[index].label,
          color: widget.steps[index].textColor,
          style: widget.steps[index].textStyle,
          margin: widget.steps[index].margin,
          labelBoxColor: widget.steps[index].labelBoxColor,
          labelBoxRadius: widget.steps[index].labelBoxRadius,
          hasArrow: widget.steps[index].hasArrow,
          hasLabelBox: widget.steps[index].hasLabelBox,
          opacity: _animation.value,
          hole: _hole?.end,
          viewport: MediaQuery.of(context).size,
          fullscreen: widget.steps[index].fullscreen,
        ),
      ),
    );
  }
}

class HolePainter extends CustomPainter {
  HolePainter({
    this.shape,
    this.overlayShape,
    this.hole,
    this.center,
    this.animation,
    this.fullscreen,
    this.overlayColor = const Color(0xaa000000),
  });

  final ShapeBorder shape;
  final ShapeBorder overlayShape;
  final Rect hole;
  final double animation;
  final Color overlayColor;
  final Offset center;
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
