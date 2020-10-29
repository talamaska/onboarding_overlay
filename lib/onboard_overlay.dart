import 'dart:async';

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
  });
  final GlobalKey key;
  final String label;
  final ShapeBorder shape;
  final EdgeInsets margin;
  final bool tappable;
  final Stream<dynamic> proceed;
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
      index++;
      if (index >= widget.steps.length) {
        index--;
        Navigator.of(context).pop();
        return;
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
            hole: _hole?.evaluate(_animation)),
        foregroundPainter: LabelPainter(
          label: widget.steps[index].label,
          opacity: _animation.value,
          hole: _hole?.end,
          viewport: MediaQuery.of(context).size,
        ),
      ),
    );
  }
}

class HolePainter extends CustomPainter {
  HolePainter({this.shape, this.hole});

  final ShapeBorder shape;
  final Rect hole;

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
    final Path path =
        Path.combine(PathOperation.difference, canvasPath, holePath);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xaa000000)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(HolePainter oldDelegate) => hole != oldDelegate.hole;
}

class LabelPainter extends CustomPainter {
  LabelPainter({this.label, this.opacity, this.hole, this.viewport});

  final String label;
  final double opacity;
  final Rect hole;
  final Size viewport;

  @override
  void paint(Canvas canvas, Size size) {
    TextPainter p = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Color.fromRGBO(
            255,
            255,
            255,
            opacity,
          ),
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    p.layout(maxWidth: size.width * 0.8);
    final Offset o = Offset(
      size.width / 2 - p.size.width / 2,
      hole == null
          ? Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero))
              .center
              .dy
          : hole.center.dy <= viewport.height / 2
              ? hole.bottom + p.size.height * 1.5
              : hole.top - p.size.height * 1.5,
    );
    p.paint(canvas, o);
  }

  @override
  bool shouldRepaint(LabelPainter oldDelegate) =>
      opacity != oldDelegate.opacity;
}
