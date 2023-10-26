//
//  ProgressRing.swift
//  ProgressRing
//
//  Created by Taichi Yuki on 2023/10/26.
//

import UIKit

final class ProgressRing: UIView {

  struct Attribute {
    let diameter: CGFloat
    let color: UIColor
    let thickness: CGFloat
    let animationDuration: TimeInterval?
  }

  private let progressLayer = CAShapeLayer()

  private var completedAnimation: ((Bool) -> Void)?

  private let attribute: Attribute

  init(attribute: Attribute) {
    self.attribute = attribute
    super.init(frame: .init(x: 0, y: 0, width: attribute.diameter, height: attribute.diameter))

    backgroundColor = .clear
    initLayers()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayers() {
    let circlePath = UIBezierPath(
      arcCenter: center,
      radius: attribute.diameter / 2,
      startAngle: CGFloat(-Double.pi / 2),
      endAngle: CGFloat(3 * Double.pi / 2),
      clockwise: true
    )

    progressLayer.path = circlePath.cgPath
    progressLayer.fillColor = UIColor.clear.cgColor
    progressLayer.lineCap = .round
    progressLayer.lineWidth = attribute.thickness
    progressLayer.strokeEnd = 0
    progressLayer.strokeColor = attribute.color.cgColor
    layer.addSublayer(progressLayer)
  }

  func setValue(
    _ value: Double,
    animationDuration: TimeInterval? = nil,
    animated: Bool = true,
    completion: ((Bool) -> Void)? = nil
  ) {
    assert(0 <= value || value <= 1)

    completedAnimation = completion

    if !animated {
      progressLayer.strokeEnd = value
      return
    }

    let animationKey = "progressAnimation"

    progressLayer.removeAnimation(forKey: animationKey)

    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.toValue = value
    animation.duration = attribute.animationDuration ?? animationDuration ?? 1.5
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    animation.timingFunction = .init(name: .easeOut)
    animation.delegate = self

    progressLayer.add(animation, forKey: animationKey)
  }
}

extension ProgressRing: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    completedAnimation?(flag)
  }
}
