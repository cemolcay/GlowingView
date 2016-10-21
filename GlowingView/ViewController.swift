//
//  ViewController.swift
//  GlowingView
//
//  Created by Cem Olcay on 21/10/2016.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var glowImageView: UIImageView?
  @IBOutlet weak var fillGlowImageView: UIImageView?

  override func viewDidLoad() {
    super.viewDidLoad()

    glowImageView?.startGlowing(
      color: .green,
      duration: 0.5)

    fillGlowImageView?.startGlowing(
      color: .red,
      toIntensity: 0.4,
      fill: true,
      duration: 0.8)
  }
}

