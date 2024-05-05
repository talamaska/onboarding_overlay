## [3.2.2]

- fix: Fixing web painting where the hole on the overlay does not get drawn. [#37](https://github.com/talamaska/onboarding_overlay/issues/37)
  (Thanks to [andyskw](https://github.com/andyskw))

## [3.2.1]

- add: 'hide' method guard (Thanks to [hpstuff](https://github.com/hpstuff))
  with [#54](https://github.com/talamaska/onboarding_overlay/pull/51)
- add: method to check Overlay visibility from OverlayState (Thanks to
  [shaikhaman2000](https://github.com/shaikhaman2000)) with
  [#39](https://github.com/talamaska/onboarding_overlay/pull/39)
- add: 'stepPainterBuilder' so that the user can create custom look different
  than the default LabelPainter (Thanks to
  [hpstuff](https://github.com/hpstuff)) with
  [#52](https://github.com/talamaska/onboarding_overlay/pull/52)
- fix: deprecations maintenance

## [3.1.2]

- fix: Properly handle titleTextStyle and bodyTextStyle which where ignored,
  except for the color attribute. (Thanks to
  [kristofb](https://github.com/kristofb))

## [3.1.1]

- fix: lint issues
- change: update dependencies

## [3.1.0]

- fix: issues with scaled widgets from ResponsiveFramework package
  [#33](https://github.com/talamaska/onboarding_overlay/issues/33)
- fix: stepBuilder content could not be sized with a custom size
  [#31](https://github.com/talamaska/onboarding_overlay/issues/31)

## [3.0.0]

- add: demo add default theme textStyles
- add: onTapCallback which if set will ignore the internal next step method call
- add: a OverlayController (ChangeNotifier) attached to the OverlayState that
  provides the currentIndex, currentStep and isVisible -
  [#20](https://github.com/talamaska/onboarding_overlay/issues/20)
- add: possibility to build your own step layout with stepBuilder -
  [#21](https://github.com/talamaska/onboarding_overlay/issues/21)
- add: pulse animation on the focused widget (Thanks to the author
  [Gautier](https://github.com/g-apparence) of the
  [pal](https://pub.dev/packages/pal) package for the inspiration)
- add: globalOnboarding setting that force the use of rootOverlay
- add: debugBoundaries boolean to show red border around the max size of the
  label box
- add: ArrowPosition.autoVertical and ArrowPosition.autoVerticalCenter. This
  setting will automatically position the label box arrow, if enabled, above or
  below the label box, depending on its position relative to the widget of
  interest.
- fix: when empty list is passed to steps the onboarding should not start and
  not throw [#25](https://github.com/talamaska/onboarding_overlay/issues/25)
- fix: when an empty list of indexes is passed to showWithSteps the onboarding
  should not start and not throw
  [#25](https://github.com/talamaska/onboarding_overlay/issues/25)
- fix: HitTestBehavior.translucent
- fix: better calculation of the max size of the label box - issue
  [#26](https://github.com/talamaska/onboarding_overlay/issues/26)
- fix: positioning of the label box when the overlay is full screen and there is
  no focused widget.
- fix: regression label box not centered when no focus widget and overlay is not
  full screen.
- change: make label box use more space available
- change: **[Breaking Change]** rename title to titleText
- remove: **[Breaking Change]** ArrowPosition.centerLeft and
  ArrowPosition.centerRight
- add: docs

## [2.3.5]

- add: more docs around the titleTextStyle and bodyTextStyle
- fix: make sure that if a color is not set in the titleTextStyle and
  bodyTextStyle properties they will fallback to titleTextColor or bodyTextColor
  accordingly

## [2.3.4]

- fix: position of the overlay when no focus node is attached and the setting of
  the overlay is fullscreen: false - issue
  [#16](https://github.com/talamaska/onboarding_overlay/issues/16)
- fix: merging text styles was done incorrectly - issue
  [#14](https://github.com/talamaska/onboarding_overlay/issues/14)

## [2.3.3]

- fix: formatting

## [2.3.2]

- change: use aut_size_text library again because a stable null-safe version was
  published
- fix: remove a repeated text for debugging purposes reported in #14

## [2.3.1]

- update demo gif
- add: more clear docs
- add: more documentation in the readme
- add: expand the examples
- add: auto size text via AutoSizeText widget in which case if turned on will
  ignore maxLines
- add: hard limit maxLines for the title to be 2 lines
- add: hard limit maxLines for the body to be 5 lines
- add: overlayBehavior that accepts HitTestBehavior
- add: logic to forward pointer events to the widget of interest.
- change: text is rendered by RichText or AutoSizeText.rich not CustomPaint
- change: vertical position of the text is handled by a Column mainAxisAlignment
- change: not exposing constants anymore, nobody from outside needs them anyways
- fix: docs
- fix: docs for the arrowPosition
- fix: imports
- fix: multiplication of the bodyText
- fix: issue with change orientation (thanks to
  [IgorKhramtsov](https://github.com/IgorKhramtsov))
- fix: landscape positions and sizes
- fix: badge to include pre-release versions

## [2.2.1]

- add: some small optimizations
- add: more steps in the example app
- add: isTop property to the LabelPainter for better positioning of the text
- change: move some hard-coded numbers as constants
- change: text positioning algorithm
- change: make some props public
- change: separate some logic
- fix: some imports
- fix: typos

## [2.1.1]

- add: shield with the pub version
- fix: assert condition in the Onboarding widget when calling .of
- fix: update readme to demo the null-safety.
- fix: check for null in the example instead of '!'

## [2.1.0]

- add: handling arrows on the label box
- add: default arrow height
- add: exports for the LabelPainter and the ArrowPosition enum
- add: docs
- change: the label box styling it is now a custom painter
- change: use flutter_lints from now on
- change: replace Container with SizeBox where possible
- change: the position of the Label when the overlay is not full screen
- change: update example app to demo the label box arrows

## [2.0.1+1] - add visual demo (gif).

## [2.0.1] - formatting.

## [2.0.0] - Migrate to null safety.

- internal restructure

## [1.0.0] - Initial release.

- change: rename library
- change: use Overlay instead of Navigator to show the onboarding
- change: use the Onboarding as ancestor widget instead of method call onboard
- change: position the label title and bodyText with Positioned widget
- add: possibility to add rounded overlay
- add: possibility to add title and body and be able to style them
- add: possibility to change the overlay color
- add: possibility to listen to onChange and onEnd callbacks
- add: possibility to start from arbitrary initial index
- add: possibility to show the onboarding only with a partial set of the steps
- remove: control via stream
- remove: unfinished callbacks on steps
- remove: usage of Label painter

## [0.0.1] - Forked from [onboard_overlay](https://github.com/lucaslcode/onboard_overlay)
