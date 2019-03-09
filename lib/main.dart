import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Home(),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<OnboardStep> steps;
  StreamController proceed;
  int _counter = 0;

  void initState() {
    super.initState();
    proceed = StreamController();
    steps = [
      OnboardStep(key: GlobalKey(), label: "Tap anywhere to continue"),
      OnboardStep(
        key: GlobalKey(),
        label: "Tap only here to increment & continue",
        shape: CircleBorder(),
        tappable: false,
        proceed: proceed.stream,
      ),
      OnboardStep(key: GlobalKey(), label: "Easy to customise"),
      OnboardStep(key: GlobalKey(), label: "Add steps for any widget"),
    ];
    WidgetsBinding.instance
      .addPostFrameCallback((_) => onboard(steps, context));
  }

  @override
  void dispose() {
    proceed.close();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    proceed.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(key: steps[3].key),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
              key: steps[0].key,
            ),
            Text(
              '$_counter',
              key: steps[2].key,
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: steps[1].key,
        onPressed: _incrementCounter,
        child: Icon(Icons.add),
      ),
    );
  }
}

@immutable
class OnboardStep {
  final GlobalKey key;
  final String label;
  final ShapeBorder shape;
  final EdgeInsets margin;
  final bool tappable;
  final Stream proceed;
  OnboardStep({
    @required this.key,
    @required this.label,
    this.shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    this.margin: const EdgeInsets.all(8.0),
    this.tappable: true,
    this.proceed,
  });
}

void onboard(List<OnboardStep> steps, BuildContext context) {
  OverlayState overlay = Overlay.of(context);
  List<OverlayEntry> overlays = [];
  List.generate(steps.length, (i) => i).forEach((i) {
    RenderBox box = steps[i].key.currentContext.findRenderObject();
    Offset offset = box.localToGlobal(Offset.zero);
    overlays.add(
      OverlayEntry(
        builder: (context) => GestureDetector(
          behavior: steps[i].tappable
            ? HitTestBehavior.opaque
            : HitTestBehavior.deferToChild,
          onTap: steps[i].tappable
            ? () => _proceed(i+1, steps, overlays, overlay)
            : null,
          child: OnboardOverlay(
            step: steps[i],
            hole: offset & box.size,
          ),
        ),
      ),
    );
  });
  _proceed(0, steps, overlays, overlay);
}

void _proceed(int i, List<OnboardStep> steps, List<OverlayEntry> overlays, OverlayState overlay) {
  if (i != 0) overlays.removeAt(0).remove();
  if (overlays.isNotEmpty) {
    overlay.insert(overlays[0]);
    StreamSubscription subscription;
    subscription = steps[i].proceed?.listen((_) {
      subscription.cancel();
      _proceed(i + 1, steps, overlays, overlay);
    });
  }
}

class OnboardOverlay extends StatelessWidget {
  final OnboardStep step;
  final Rect hole;
  OnboardOverlay({this.step, Rect hole})
      : this.hole = step.margin.inflateRect(hole);

  @override
  Widget build(BuildContext context) => CustomPaint(
      child: Container(),
      painter: HolePainter(shape: step.shape, hole: hole),
      foregroundPainter: LabelPainter(
        label: step.label,
        hole: hole,
        viewport: MediaQuery.of(context).size,
      ),
  );
}

class HolePainter extends CustomPainter {
  final ShapeBorder shape;
  final Rect hole;
  HolePainter({this.shape, this.hole});

  @override
  bool hitTest(Offset position) {
    return !hole.contains(position);
  }

  @override
  void paint(Canvas canvas, Size canvasSize) {
    Path canvasPath = Path()
      ..lineTo(canvasSize.width, 0)
      ..lineTo(canvasSize.width, canvasSize.height)
      ..lineTo(0, canvasSize.height)
      ..close();
    Path holePath = shape.getOuterPath(hole);
    Path path = Path.combine(PathOperation.difference, canvasPath, holePath);
    canvas.drawPath(
      path,
      Paint()
        ..color = Color(0xaa000000)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class LabelPainter extends CustomPainter {
  final String label;
  final Rect hole;
  final Size viewport;
  LabelPainter({this.label, this.hole, this.viewport});

  @override
  void paint(Canvas canvas, Size size) {
    TextPainter p = TextPainter(
      text: TextSpan(text: label),
      textDirection: TextDirection.ltr,
    );
    p.layout(maxWidth: size.width * 0.8);
    Offset o = Offset(
      size.width/2  - p.size.width/2,
      hole.center.dy <= viewport.height/2
        ? hole.bottom + p.size.height * 1.5
        : hole.top - p.size.height * 1.5,
    );
    p.paint(canvas, o);
  }

  @override
  bool shouldRepaint(_) => false;
}
