# GTMotionInterchange
![Motion Interchange Banner](img/motion-interchange-banner.gif)

> A standard format for representing animation traits in Objective-C and Swift.

[![Build Status](https://travis-ci.org/material-motion/motion-interchange-objc.svg?branch=develop)](https://travis-ci.org/material-motion/motion-interchange-objc)
[![codecov](https://codecov.io/gh/material-motion/motion-interchange-objc/branch/develop/graph/badge.svg)](https://codecov.io/gh/material-motion/motion-interchange-objc)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MotionInterchange.svg)](https://cocoapods.org/pods/MotionInterchange)
[![Platform](https://img.shields.io/cocoapods/p/MotionInterchange.svg)](http://cocoadocs.org/docsets/MotionInterchange)

"Magic numbers" — those lonely, abandoned values without a home — are often one of the first things
targeted in code review for cleanup. And yet, numbers related to animations may go unnoticed and
left behind, scattered throughout a code base with little to no organizational diligence. These
forgotten metrics form the backbone of mobile interactions and are often the ones needing the most
care - so why are we ok leaving them scattered throughout a code base?

```objc
// Let's play "find the magic number": how many magic numbers are hidden in this code?
[UIView animateWithDuration:0.230
                      delay:0
                      options:UIViewAnimationOptionCurveEaseOut
                      animations:^{
                        myButton.position = updatedPosition;
                      }
                      completion:nil];
// Hint: the answer is not "one, the number 0.230".
```

The challenge with extracting animation magic numbers is that we often don't have a clear
definition of *what an animation is composed of*. An animation is not simply determined by its
duration, in the same way that a color is not simply determined by how red it is.

The traits of an animation — like the red, green, and blue components of a color — include the
following:

- Delay.
- Duration.
- Timing curve.
- Repetition.

Within this library you will find simple data types for storing and representing animation
traits so that the magic numbers that define your animations can find a place to call home.

Welcome home, lost numbers.

## Sibling library: Motion Animator

While it is possible to use the Motion Interchange as a standalone library, the Motion Animator
is designed to be the primary consumer of Motion Interchange data types. Consider using these
libraries together, with MotionAnimator as your primary dependency.

```objc
GTMAnimationTraits *animationTraits =
    [[GTMAnimationTraits alloc] initWithDuration:0.230
                              timingFunctionName:kCAMediaTimingFunctionEaseInEaseOut];

GTMMotionAnimator *animator = [[GTMMotionAnimator alloc] init];
[animator animateWithTraits:animationTraits animations:^{
  view.alpha = 0;
}];
```

To learn more, visit the MotionAnimator GitHub page:

https://github.com/liuxc123/GTMotionAnimator

## Installation

### Installation with CocoaPods

> CocoaPods is a dependency manager for Objective-C and Swift libraries. CocoaPods automates the
> process of using third-party libraries in your projects. See
> [the Getting Started guide](https://guides.cocoapods.org/using/getting-started.html) for more
> information. You can install it with the following command:
>
>     gem install cocoapods

Add `GTMotionInterchange` to your `Podfile`:

    pod 'GTMotionInterchange'

Then run the following command:

    pod install

### Usage

Import the framework:

    @import MotionInterchange;

You will now have access to all of the APIs.

## Example apps/unit tests

Check out a local copy of the repo to access the Catalog application by running the following
commands:

    git clone https://github.com/material-motion/motion-interchange-objc.git
    cd GTMotionInterchange
    pod install
    open GTMotionInterchange.xcworkspace

## Guides

1. [Animation traits](#animation-traits)
2. [Timing curves](#timing-curves)

### Animation traits

The primary data type you'll make use of is `GTMAnimationTraits`. This class can store all of
the necessary traits that make up an animation, including:

- Delay.
- Duration.
- Timing curve.
- Repetition.

In Objective-C, you initialize a simple ease in/out cubic bezier instance like so:

```objc
GTMAnimationTraits *traits = [[GTMAnimationTraits alloc] initWithDuration:0.5];
```

And in Swift:

```swift
let traits = GTMAnimationTraits(duration: 0.5)
```

There are many more ways to initialize animation traits. Read the
[header documentation](src/GTMAnimationTraits.h) to see all of the available initializers.

### Timing curves

A timing curve describes how quickly an animation progresses over time. Two types of timing
curves are supported by Core Animation, and therefore by the MotionInterchange:

- Cubic bezier
- Spring

**Cubic beziers** are represented by the CAMediaTimingFunction object. To define an
animation trait with a cubic bezier curve in Objective-C:

```objc
CAMediaTimingFunction *timingCurve =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
GTMAnimationTraits *traits =
    [[GTMAnimationTraits alloc] initWithDelay:0 duration:0.5 timingCurve:timingCurve];
```

And in Swift:

```swift
let timingCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
let traits = GTMAnimationTraits(delay: 0, duration: 0.5, timingCurve: timingCurve)
```

You can also use the UIViewAnimationCurve type to initialize a timing curve in Objective-C:

```objc
GTMAnimationTraits *traits =
    [[GTMAnimationTraits alloc] initWithDuration:0.5 animationCurve:UIViewAnimationCurveEaseIn];
```

And in Swift:

```swift
let traits = GTMAnimationTraits(duration: 0.5, animationCurve: .easeIn)
```

**Springs** are represented with the custom `GTMSpringTimingCurve` type. To define an
animation trait with a spring curve in Objective-C:

```objc
GTMSpringTimingCurve *timingCurve =
    [[GTMSpringTimingCurve alloc] initWithMass:1 tension:100 friction:10];
GTMAnimationTraits *traits =
    [[GTMAnimationTraits alloc] initWithDelay:0 duration:0.5 timingCurve:timingCurve];
```

And in Swift:

```swift
let timingCurve = GTMSpringTimingCurve(mass: 1, tension: 100, friction: 10)
let traits = GTMAnimationTraits(delay: 0, duration: 0.5, timingCurve: timingCurve)
```

Springs can also be initialized using UIKit's [damping ratio concept](https://developer.apple.com/documentation/uikit/uiview/1622594-animatewithduration). The `GTMSpringTimingCurveGenerator` type generates `GTMSpringTimingCurve` instances when needed. A spring timing curve generator can be stored as the `timingCurve` of an `GTMAnimationTraits` instance.

```objc
GTMSpringTimingCurveGenerator *timingCurve =
    [[GTMSpringTimingCurveGenerator alloc] initWithDuration:<#(NSTimeInterval)#> dampingRatio:<#(CGFloat)#>];
GTMAnimationTraits *traits =
    [[GTMAnimationTraits alloc] initWithDelay:0 duration:0.5 timingCurve:timingCurve];
```

And in Swift:

```swift
let timingCurve = GTMSpringTimingCurveGenerator(duration: 0.5, dampingRatio: 0.5)
let traits = GTMAnimationTraits(delay: 0, duration: 0.5, timingCurve: timingCurve)
```


## Author

liuxc123, lxc_work@126.com

## License

GTMotionInterchange is available under the MIT license. See the LICENSE file for more info.
