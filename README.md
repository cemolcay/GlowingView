GlowingView
===

A UIView extension adds customisable glow effect based on CALayer shadows.

Demo
----

![alt tag]()

#### Try

``` sh
pod try GlowingView
```

Requirements
----

* Xcode 8+
* Swift 3+
* iOS 10+

Install
----

``` ruby
use_frameworks!
pod 'GlowingView'
```

Usage
----

Call `startGlowing` function with optional paramaters to fit your glowing needs.  
Call `stopGlowing` function to stop glowing effect.
  
GlowingView adds a private glowing layer top of the target view with CALayer shadows and CABasicAnimation animations.


#### Start Glow Signature

```
  public func startGlowing(
    color: UIColor = .white,
    fromIntensity: CGFloat = 0,
    toIntensity: CGFloat = 1,
    fill: Bool = false,
    position: CGPoint? = nil,
    duration: TimeInterval = 1,
    repeat shouldRepeat: Bool = true)
```

#### Demo usage

```
glowImageView?.startGlowing(
  color: .green,
  duration: 0.5)

fillGlowImageView?.startGlowing(
  color: .red,
  toIntensity: 0.4,
  fill: true,
  duration: 0.8)
```
