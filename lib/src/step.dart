import 'package:flutter/widgets.dart';

import 'label_painter.dart';

@immutable
class OnboardingStep {
  /// At least a [title] or a [bodyText] should be provided.
  ///
  /// [titleTextColor] has a default value of `Color(0xFFFFFFFF),
  /// if a [titleTextStyle] is provided with a color it takes a precendence
  /// over the [titleTextColor].
  ///
  /// [bodyTextColor] has a default value of `Color(0xFFFFFFFF),
  /// if a [bodyTextStyle] is provided with a color it takes a precendence
  /// over the [bodyTextColor].
  const OnboardingStep({
    this.key,
    required this.focusNode,
    required this.title,
    this.titleTextColor = const Color(0xFFFFFFFF),
    this.titleTextStyle,
    this.bodyText = '',
    this.bodyTextStyle,
    this.bodyTextColor = const Color(0xFFFFFFFF),
    this.textAlign = TextAlign.start,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    this.margin = const EdgeInsets.all(8.0),
    this.overlayColor = const Color(0xC4000000),
    this.overlayShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    this.hasLabelBox = false,
    this.labelBoxPadding = const EdgeInsets.all(8.0),
    this.labelBoxDecoration = const BoxDecoration(),
    this.hasArrow = false,
    this.fullscreen = true,
    this.delay = Duration.zero,
    this.arrowPosition = ArrowPosition.top,
    this.overlayBehavior = HitTestBehavior.opaque,
    this.showPulseAnimation = true,
    this.pulseInnerColor = const Color(0x0fffffff),
    this.pulseOuterColor = const Color(0x0fffffff),
  })  : assert(titleTextColor != null || titleTextStyle != null,
            'You should provide at least one of titleTextColor or titleTextStyle'),
        assert(bodyTextColor != null || bodyTextStyle != null,
            'You should provide at least one of bodyTextColor or bodyTextStyle'),
        assert(
            (hasArrow && hasLabelBox) ||
                (!hasArrow && !hasLabelBox) ||
                !hasArrow && hasLabelBox,
            'hasArrow $hasArrow cannot be true if hasLabelBox $hasLabelBox is false');

  final Key? key;

  /// is required
  final FocusNode focusNode;

  /// By default, the value used is `TextAlign.start`
  final TextAlign textAlign;

  /// By default, the value used is `Color(0xFFFFFFFF)`
  final Color? titleTextColor;

  final String title;

  /// By default, the value used is `ArrowPosition.top`
  final ArrowPosition arrowPosition;

  /// By default, the value is
  /// ```
  /// TextStyle titleTextStyle = Theme.of(context)
  ///   .textTheme
  ///   .heading5
  ///   .copyWith(color: step.titleTextColor)
  /// ```
  /// if a [titleTextStyle] is provided with a color it takes a precendence
  /// over the [titleTextColor].
  final TextStyle? titleTextStyle;

  final String bodyText;

  /// By default, the value used is `Color(0xFFFFFFFF)`
  final Color? bodyTextColor;

  /// By default, the value is
  /// ```
  /// TextStyle bodyTextStyle = Theme.of(context)
  ///   .textTheme
  ///   .bodyText1
  ///   .copyWith(color: step.bodyTextColor)
  /// ```
  /// if a [bodyTextStyle] is provided with a color it takes a precendence
  /// over the [bodyTextColor].
  final TextStyle? bodyTextStyle;

  /// By default, the value is BoxDecoration()
  final BoxDecoration labelBoxDecoration;

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

  /// This is the space around the `Widget` we want which we would clip a hole
  /// By default, the value is `EdgeInsets.all(8.0)`
  final EdgeInsets margin;

  /// By default the value is `EdgeInsets.zero`
  final EdgeInsets labelBoxPadding;

  /// By default, the value is
  /// ```
  /// Color(0x00000000),
  ///
  /// ```
  // final Color labelBoxColor;

  /// By default, the value is
  /// ```
  /// Radius.circular(5.0)
  ///
  /// ```
  // final Radius labelBoxRadius;

  /// By default, the value used is false
  final bool hasLabelBox;

  /// By default, the value used is false
  final bool hasArrow;

  /// By default, the value used is true
  final bool fullscreen;

  /// By default, the value used is `Duration.zero`
  final Duration delay;

  /// By default, the value used is `HitTestBehavior.opaque`
  ///
  /// `HitTestBehavior.opaque` blocks the onTap on the widget and will trigger the onTap only on the overlay
  ///
  /// `HitTestBehavior.translucent` triggers onTap callbacks on the widget and on the overlay
  ///
  /// `HitTestBehavior.deferToChild` triggers only the onTap on the widget
  final HitTestBehavior overlayBehavior;

  /// By default, the value used is false
  ///
  /// Enables a pulsing animation around a widget in focus
  final bool showPulseAnimation;

  /// By default, the value used is white
  final Color pulseInnerColor;

  /// By default, the value used is white
  final Color pulseOuterColor;

  OnboardingStep copyWith({
    Key? key,
    FocusNode? focusNode,
    TextAlign? textAlign,
    Color? titleTextColor,
    String? title,
    ArrowPosition? arrowPosition,
    TextStyle? titleTextStyle,
    String? bodyText,
    Color? bodyTextColor,
    TextStyle? bodyTextStyle,
    BoxDecoration? labelBoxDecoration,
    ShapeBorder? shape,
    Color? overlayColor,
    ShapeBorder? overlayShape,
    EdgeInsets? margin,
    EdgeInsets? labelBoxPadding,
    bool? hasLabelBox,
    bool? hasArrow,
    bool? fullscreen,
    Duration? delay,
    HitTestBehavior? overlayBehavior,
    bool? showPulseAnimation,
    Color? pulseInnerColor,
    Color? pulseOuterColor,
  }) {
    return OnboardingStep(
      key: key ?? this.key,
      focusNode: focusNode ?? this.focusNode,
      textAlign: textAlign ?? this.textAlign,
      titleTextColor: titleTextColor ?? this.titleTextColor,
      title: title ?? this.title,
      arrowPosition: arrowPosition ?? this.arrowPosition,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      bodyText: bodyText ?? this.bodyText,
      bodyTextColor: bodyTextColor ?? this.bodyTextColor,
      bodyTextStyle: bodyTextStyle ?? this.bodyTextStyle,
      labelBoxDecoration: labelBoxDecoration ?? this.labelBoxDecoration,
      shape: shape ?? this.shape,
      overlayColor: overlayColor ?? this.overlayColor,
      overlayShape: overlayShape ?? this.overlayShape,
      margin: margin ?? this.margin,
      labelBoxPadding: labelBoxPadding ?? this.labelBoxPadding,
      hasLabelBox: hasLabelBox ?? this.hasLabelBox,
      hasArrow: hasArrow ?? this.hasArrow,
      fullscreen: fullscreen ?? this.fullscreen,
      delay: delay ?? this.delay,
      overlayBehavior: overlayBehavior ?? this.overlayBehavior,
      showPulseAnimation: showPulseAnimation ?? this.showPulseAnimation,
      pulseInnerColor: pulseInnerColor ?? this.pulseInnerColor,
      pulseOuterColor: pulseOuterColor ?? this.pulseOuterColor,
    );
  }

  @override
  String toString() {
    return 'OnboardingStep(key: $key, focusNode: $focusNode, textAlign: $textAlign, titleTextColor: $titleTextColor, title: $title, arrowPosition: $arrowPosition, titleTextStyle: $titleTextStyle, bodyText: $bodyText, bodyTextColor: $bodyTextColor, bodyTextStyle: $bodyTextStyle, labelBoxDecoration: $labelBoxDecoration, shape: $shape, overlayColor: $overlayColor, overlayShape: $overlayShape, margin: $margin, labelBoxPadding: $labelBoxPadding, hasLabelBox: $hasLabelBox, hasArrow: $hasArrow, fullscreen: $fullscreen, delay: $delay, overlayBehavior: $overlayBehavior, showPulseAnimation: $showPulseAnimation, pulseInnerColor: $pulseInnerColor, pulseOuterColor: $pulseOuterColor)';
  }
}
