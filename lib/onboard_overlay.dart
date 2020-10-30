import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@immutable
class OnboardStep {
  const OnboardStep({
    @required this.key,
    this.label = '',
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    this.margin = const EdgeInsets.all(8.0),
    this.tappable = true,
    this.proceed,
    this.callback,
    this.overlayColor = const Color(0xaa000000),
    this.textColor = const Color(0xFFFFFFFF),
    this.textStyle,
    this.labelBoxRadius = 10.0,
    this.labelBoxColor = const Color(0xFF0A76F1),
    this.hasLabelBox = false,
    this.hasArrow = false,
  });

  final GlobalKey key;
  final String label;
  final ShapeBorder shape;
  final EdgeInsets margin;
  final bool tappable;
  final Stream<dynamic> proceed;
  final Function callback;
  final Color textColor;
  final Color overlayColor;
  final TextStyle textStyle;
  final double labelBoxRadius;
  final Color labelBoxColor;
  final bool hasLabelBox;
  final bool hasArrow;
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
        OnboardWidget(steps: steps),
      ),
    );
  }

  @override
  bool get opaque => false;
}

class OnboardWidget extends StatefulWidget {
  const OnboardWidget({this.steps});
  final List<OnboardStep> steps;

  @override
  _OnboardWidgetState createState() => _OnboardWidgetState();
}

class _OnboardWidgetState extends State<OnboardWidget>
    with SingleTickerProviderStateMixin {
  int index = 0;
  RectTween _hole;
  ColorTween _colorTween;
  AnimationController _controller;
  Animation<double> _animation;
  bool _lastScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
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

  void _proceed({bool init = false}) async {
    if (init) {
      index = 0;
    } else {
      await _controller.reverse();
      if (index + 1 >= widget.steps.length && _lastScreen == false) {
        _lastScreen = true;
        Navigator.of(context).pop();
        return;
      } else if (_lastScreen == false) {
        index++;
        if (widget.steps[index].callback != null) {
          widget.steps[index].callback();
        }
      }
    }

    final RenderBox box = widget.steps[index].key?.currentContext
        ?.findRenderObject() as RenderBox;
    final Offset offset = box?.localToGlobal(Offset.zero);
    final Rect widgetRect = box != null ? offset & box.size : null;
    _hole = widgetRect != null
        ? RectTween(
            begin: Rect.zero.shift(widgetRect.center),
            end: widget.steps[index].margin.inflateRect(widgetRect),
          )
        : null;
    _colorTween = ColorTween(
      begin: index > 0
          ? widget.steps[index - 1].overlayColor
          : widget.steps[index].overlayColor,
      end: widget.steps[index].overlayColor,
    );
    _animation = CurvedAnimation(curve: Curves.ease, parent: _controller);
    StreamSubscription<dynamic> subscription;
    subscription = widget.steps[index].proceed?.listen((dynamic _) {
      subscription.cancel();
      _proceed();
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.steps[index].tappable
          ? HitTestBehavior.opaque
          : HitTestBehavior.deferToChild,
      onTap: widget.steps[index].tappable ? _proceed : null,
      child: CustomPaint(
        child: Container(),
        painter: HolePainter(
          shape: widget.steps[index].shape,
          hole: _hole?.evaluate(_animation),
          overlayColor: _colorTween?.evaluate(_animation),
        ),
        foregroundPainter: LabelPainter(
          label: widget.steps[index].label,
          color: widget.steps[index].textColor,
          style: widget.steps[index].textStyle,
          labelBoxColor: widget.steps[index].labelBoxColor,
          labelBoxRadius: widget.steps[index].labelBoxRadius,
          hasArrow: widget.steps[index].hasArrow,
          hasLabelBox: widget.steps[index].hasLabelBox,
          opacity: _animation.value,
          hole: _hole?.end,
          viewport: MediaQuery.of(context).size,
        ),
      ),
    );
  }
}

class HolePainter extends CustomPainter {
  HolePainter({
    this.shape,
    this.hole,
    this.overlayColor = const Color(0xaa000000),
  });

  final ShapeBorder shape;
  final Rect hole;
  final Color overlayColor;

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
    final Path path = Path.combine(
      PathOperation.difference,
      canvasPath,
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
  bool shouldRepaint(HolePainter oldDelegate) => hole != oldDelegate.hole;
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

  @override
  void paint(Canvas canvas, Size size) {
    final TextPainter p = TextPainter(
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

    p.layout(maxWidth: size.width * 0.8);

    final Offset offset = Offset(
      size.width / 2 - p.size.width / 2,
      hole == null
          ? Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero))
              .center
              .dy
          : hole.center.dy <= viewport.height / 2
              ? hole.bottom + p.size.height * (hasLabelBox ? 2.5 : 1.5)
              : hole.top - p.size.height * (hasLabelBox ? 2.5 : 1.5),
    );

    final Paint labelBoxPaint = Paint()
      ..color = labelBoxColor
      ..style = PaintingStyle.fill;

    final Path triangleTop = Path()
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

    final Path triangleBottom = Path()
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

    if (hasLabelBox) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            offset.dx - p.size.height / 2,
            offset.dy - p.size.height / 2,
            p.size.width + p.size.height,
            p.size.height + p.size.height,
          ),
          Radius.circular(labelBoxRadius),
        ),
        labelBoxPaint,
      );
      debugPrint('hasArrow $hasArrow');
      if (hole != null && hasArrow) {
        if (hole.center.dy <= viewport.height / 2) {
          canvas.drawPath(triangleTop, labelBoxPaint);
        } else {
          canvas.drawPath(triangleBottom, labelBoxPaint);
        }
      }
    }

    p.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(LabelPainter oldDelegate) =>
      opacity != oldDelegate.opacity;
}
