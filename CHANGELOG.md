## [2.3.1]
  - update demo gif
  - add: more clear docs
  - add: more documentation in the readme
  - add: expand the examples
  - add: auto size text via AutoSizeText widget in which case if turned on will ignore maxLines
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
  - fix: issue with change orientation (thanks to [IgorKhramtsov](https://github.com/IgorKhramtsov))
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
