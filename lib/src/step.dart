import 'package:flutter/widgets.dart';

@immutable
class OnboardingStep {
  /// At least a [title] or a [bodyText] should be provided.
  ///
  /// At least a [titleTextColor] or a [titleTextStyle] should be provided.
  ///
  /// At least a [bodyTextColor] or a [bodyTextStyle] should be provided.
  const OnboardingStep({
    required this.focusNode,
    this.title,
    this.titleTextStyle,
    this.titleTextColor = const Color(0xFFFFFFFF),
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
        assert(title != null || bodyText != null);

  /// is required
  final FocusNode focusNode;

  /// By default, the value used is `Color(0xFFFFFFFF)`
  final Color? titleTextColor;

  /// By default, the value used is `Color(0xFFFFFFFF)`
  final Color? bodyTextColor;

  final String? title;

  /// By default, the value is
  /// ```
  /// TextStyle titleTextStyle = Theme.of(context)
  ///   .textTheme
  ///   .heading5
  ///   .copyWith(color: step.titleTextColor)
  /// ```
  final TextStyle? titleTextStyle;

  final String? bodyText;

  /// By default, the value is
  /// ```
  /// TextStyle bodyTextStyle = Theme.of(context)
  ///   .textTheme
  ///   .bodyText1
  ///   .copyWith(color: step.bodyTextColor)
  /// ```
  final TextStyle? bodyTextStyle;

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

  /// By default the value is `EdgeInsets.zero`
  final EdgeInsets labelBoxPadding;

  /// By default, the value is
  /// ```
  /// BoxDecoration(
  ///   shape: BoxShape.rectangle,
  ///   borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ///   color: Color(0x00000000),
  /// )
  /// ```
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
    BoxDecoration? labelBoxDecoration,
    bool? hasLabelBox,
    bool? hasArrow,
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
