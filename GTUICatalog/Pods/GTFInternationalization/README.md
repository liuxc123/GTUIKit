# GTFInternationalization

[![CI Status](https://img.shields.io/travis/liuxc123/GTFInternationalization.svg?style=flat)](https://travis-ci.org/liuxc123/GTFInternationalization)
[![Version](https://img.shields.io/cocoapods/v/GTFInternationalization.svg?style=flat)](https://cocoapods.org/pods/GTFInternationalization)
[![License](https://img.shields.io/cocoapods/l/GTFInternationalization.svg?style=flat)](https://cocoapods.org/pods/GTFInternationalization)
[![Platform](https://img.shields.io/cocoapods/p/GTFInternationalization.svg?style=flat)](https://cocoapods.org/pods/GTFInternationalization)

## Right-to-Left calculations for CGRects and UIEdgeInsets

A UIView is positioned within its superview in terms of a frame (CGRect) consisting of an
origin and a size. When a device is set to a language that is written from Right-to-Left (RTL),
we often want to mirror the interface around the vertical axis. This library contains
functions to assist in modifying frames and edge insets for RTL.

``` obj-c
// To flip a subview's frame horizontally, pass in subview.frame and the width of its parent.
CGRect originalFrame = childView.frame;
CGRect flippedFrame = GTFRectFlippedHorizontally(originalFrame, CGRectGetWidth(self.bounds));
childView.frame = flippedFrame;
```

## Mirroring Images

A category on UIImage backports iOS 10's `[UIImage imageWithHorizontallyFlippedOrientation]` to
earlier versions of iOS.

``` obj-c
// To mirror on image, invoke gtf_imageWithHorizontallyFlippedOrientation.
UIImage *mirroredImage = [originalImage gtf_imageWithHorizontallyFlippedOrientation];
```

## Adding semantic context

A category on UIView backports iOS 9's `-[UIView semanticContentAttribute]` and iOS 10's
`-[UIView effectiveUserInterfaceLayoutDirection]` to earlier versions of iOS.

``` obj-c
// To set a semantic content attribute, set the gtf_semanticContentAttribute property.
lockedLTRView.gtf_semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;

// gtf_semanticContentAttribute is used to calculate the gtf_effectiveUserInterfaceLayoutDirection
if (customView.gtf_effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
  // Update customView's layout to be in RTL mode.
}
```

## Embedding Bidirection strings

A category on NSString offers a simple API to wrap strings in Unicode markers so that LTR
and RTL text can co-exist in the same string.

``` obj-c
// To embed an RTL string in an existing LTR string we should wrap it in Unicode directionality
// markers to  maintain preoper rendering.

// The name of a restaurant is in Arabic or Hebrew script, but the rest of string is in Latin.
NSString *wrappedRestaurantName =
    [restaurantName gtf_stringWithStereoReset:NSLocaleLanguageDirectionRightToLeft
                                      context:NSLocaleLanguageDirectionLeftToRight];

NSString *reservationString = [NSString stringWithFormat:@"%@ : %ld", wrappedRestaurantName, attendees];
```

## Usage

See Example for a detailed example of how to use the functionality provided by this library.

## Installation

GTFInternationalization is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GTFInternationalization'
```

## Author

liuxc123, lxc_work@126.com

## License

GTFInternationalization is available under the MIT license. See the LICENSE file for more info.


