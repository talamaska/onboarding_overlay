import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onboard_overlay/src/foundation.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({
    Key key,
    this.initialIndex = 0,
    this.onChanged,
    this.onEnd,
    this.steps,
    this.child,
  }) : super(key: key);

  final int initialIndex;
  final ValueChanged<int> onChanged;
  final VoidCallback onEnd;
  final List<OnboardStep> steps;
  final Widget child;

  @override
  OnboardingState createState() => OnboardingState();
}

class OnboardingState extends State<Onboarding> {
  OverlayEntry _overlayEntry;

  void show() {
    _overlayEntry = _createOverlayEntry(widget.initialIndex);
    Overlay.of(context).insert(_overlayEntry);
  }

  void hide() {
    widget.onEnd();
    _overlayEntry.remove();
  }

  void showFromIndex(int index) {
    _overlayEntry = _createOverlayEntry(index);
    Overlay.of(context).insert(_overlayEntry);
  }

  OverlayEntry _createOverlayEntry(int index) {
    return OverlayEntry(
        opaque: false,
        builder: (BuildContext context) {
          return Navigator(
            initialRoute: '/onboarding',
            onGenerateRoute: (RouteSettings settings) {
              return OnboardingRoute(
                builder: (BuildContext context) {
                  return OnboardWidget(
                    initialIndex: index ?? widget.initialIndex,
                    steps: widget.steps,
                    onChanged: (int index) {
                      debugPrint('+++++++++++++ index $index');
                    },
                    onEnd: () {
                      debugPrint('end');
                      // hide();
                    },
                  );
                },
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class OnboardingRoute extends PageRoute<dynamic> {
  OnboardingRoute({
    @required this.builder,
  });
  final WidgetBuilder builder;

  @override
  Color get barrierColor => const Color(0x00000000);

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
