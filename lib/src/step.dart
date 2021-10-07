import 'package:flutter/widgets.dart';

import 'label_painter.dart';

@immutable
class OnboardingStep {
  /// At least a [title] or a [bodyText] should be provided.
  ///
  /// At least a [titleTextColor] or a [titleTextStyle] should be provided.
  ///
  /// At least a [bodyTextColor] or a [bodyTextStyle] should be provided.
  const OnboardingStep({
    this.key,
    required this.focusNode,
    required this.title,
    this.titleTextStyle,
    this.titleTextColor = const Color(0xFFFFFFFF),
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

  /// By default, the value used is `Color(0xFFFFFFFF)`
  final Color? bodyTextColor;

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
  final TextStyle? titleTextStyle;

  final String bodyText;

  /// By default, the value is
  /// ```
  /// TextStyle bodyTextStyle = Theme.of(context)
  ///   .textTheme
  ///   .bodyText1
  ///   .copyWith(color: step.bodyTextColor)
  /// ```
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
  /// `HitTestBehavior.opaque` is going to block the Gesture on the widget
  ///
  /// `HitTestBehavior.translucent` is going trigger Gesture callbacks on the widget and on the overlay
  ///
  /// `HitTestBehavior.deferToChild` is going to trigger only the Gesture on the widget
  final HitTestBehavior overlayBehavior;

  OnboardingStep copyWith({
    FocusNode? focusNode,
    Color? titleTextColor,
    Color? bodyTextColor,
    String? title,
    TextStyle? titleTextStyle,
    String? bodyText,
    TextStyle? bodyTextStyle,
    ShapeBorder? shape,
    Color? overlayColor,
    ShapeBorder? overlayShape,
    EdgeInsets? margin,
    EdgeInsets? labelBoxPadding,
    bool? hasLabelBox,
    bool? hasArrow,
    TextAlign? textAlign,
    ArrowPosition? arrowPosition,
    bool? fullscreen,
    Duration? delay,
  }) {
    return OnboardingStep(
      focusNode: focusNode ?? this.focusNode,
      titleTextColor: titleTextColor ?? this.titleTextColor,
      bodyTextColor: bodyTextColor ?? this.bodyTextColor,
      title: title ?? this.title,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      bodyText: bodyText ?? this.bodyText,
      bodyTextStyle: bodyTextStyle ?? this.bodyTextStyle,
      textAlign: textAlign ?? this.textAlign,
      shape: shape ?? this.shape,
      overlayColor: overlayColor ?? this.overlayColor,
      overlayShape: overlayShape ?? this.overlayShape,
      margin: margin ?? this.margin,
      labelBoxPadding: labelBoxPadding ?? this.labelBoxPadding,
      hasLabelBox: hasLabelBox ?? this.hasLabelBox,
      hasArrow: hasArrow ?? this.hasArrow,
      arrowPosition: arrowPosition ?? this.arrowPosition,
      fullscreen: fullscreen ?? this.fullscreen,
      delay: delay ?? this.delay,
    );
  }

  @override
  String toString() {
    return '''OnboardingStep(
      key: $key, 
      focusNode: $focusNode, 
      arrowPosition: $arrowPosition, 
      title: $title, 
      titleTextColor: $titleTextColor, 
      titleTextStyle: $titleTextStyle, 
      bodyText: $bodyText, 
      bodyTextColor: $bodyTextColor, 
      bodyTextStyle: $bodyTextStyle, 
      textAlign: $textAlign, 
      labelBoxDecoration: $labelBoxDecoration, 
      labelBoxPadding: $labelBoxPadding, 
      overlayColor: $overlayColor, 
      overlayShape: $overlayShape, 
      margin: $margin, 
      hasArrow: $hasArrow, 
      hasLabelBox: $hasLabelBox, 
      fullscreen: $fullscreen, 
      shape: $shape, 
      delay: $delay
    )''';
  }
}
