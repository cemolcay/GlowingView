//
//  GlowingView.swift
//  GlowingView
//
//  Created by Cem Olcay on 21/10/2016.
//  Copyright © 2016 Prototapp. All rights reserved.
//
//  Code heavily refactored from
//  https://github.com/thesecretlab/UIView-Glow
//

import UIKit

private var GlowLayerAssociatedObjectKey = "GlowLayerAssociatedObjectKey"

public extension UIView {

  private var glowLayer: CALayer? {
    get {
      return objc_getAssociatedObject(self, &GlowLayerAssociatedObjectKey) as? CALayer
    } set {
      objc_setAssociatedObject(self, &GlowLayerAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }


  /// Starts glowing view with options.
  ///
  /// - parameter color:         Glow color.
  /// - parameter fromIntensity: Glow start intensity.
  /// - parameter toIntensity:   Glow end intensity.
  /// - parameter fill:          If true, glows inside the view as well. If not, only glows outer border.
  /// - parameter position:      Sets position of glow over view. Defaults center.
  /// - parameter duration:      Duration of one pulse of glow.
  /// - parameter shouldRepeat:  If true, repeats until stop. If not, pulses just once.
  public func startGlowing(
    color: UIColor = .white,
    fromIntensity: CGFloat = 0,
    toIntensity: CGFloat = 1,
    fill: Bool = false,
    position: CGPoint? = nil,
    duration: TimeInterval = 1,
    repeat shouldRepeat: Bool = true) {

    // If we're already glowing, don't bother
    guard glowLayer == nil
      else { return }

    glowLayer = CALayer()
    guard let glowLayer = glowLayer
      else { return }

    // The glow image is taken from the current view's appearance.
    // As a side effect, if the view's content, size or shape changes,
    // the glow won't update.
    var image: UIImage?

    UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
    if let context = UIGraphicsGetCurrentContext() {
      layer.render(in: context)
      if fill {
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        color.setFill()
        path.fill(with: .sourceAtop, alpha: 1.0)
      }
      image = UIGraphicsGetImageFromCurrentImageContext()
    }
    UIGraphicsEndImageContext()

    // Setup glowLayer
    glowLayer.frame = CGRect(origin: position ?? bounds.origin, size: frame.size)
    glowLayer.contents = image?.cgImage
    glowLayer.opacity = 0
    glowLayer.shadowColor = color.cgColor
    glowLayer.shadowOffset = CGSize.zero
    glowLayer.shadowRadius = 10
    glowLayer.shadowOpacity = 1
    glowLayer.rasterizationScale = UIScreen.main.scale
    glowLayer.shouldRasterize = true
    layer.addSublayer(glowLayer)

    // Create an animation that slowly fades the glow view in and out forever.
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = fromIntensity
    animation.toValue = toIntensity
    animation.repeatCount = shouldRepeat ? .infinity : 0
    animation.duration = duration
    animation.autoreverses = true
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    glowLayer.add(animation, forKey: "glowViewPulseAnimation")

    // Stop glowing after duration if not repeats
    if !shouldRepeat {
      let delay = duration * Double(Int64(NSEC_PER_SEC))
      DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + delay,
        execute: { [weak self] in
          self?.stopGlowing()
        })
    }
  }

  /// Stop glowing by removing the glowing view from the superview
  /// and removing the association between it and this object.
  public func stopGlowing() {
    glowLayer?.removeFromSuperlayer()
    glowLayer = nil
  }
}
