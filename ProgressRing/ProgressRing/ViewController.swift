//
//  ViewController.swift
//  ProgressRing
//
//  Created by Taichi Yuki on 2023/10/26.
//

import UIKit

class ViewController: UIViewController {

  let progressRing = ProgressRing(attribute: .init(diameter: 150, color: .magenta, thickness: 20, animationDuration: 1.5))

  override func viewDidLoad() {
    super.viewDidLoad()

    progressRing.center = view.center
    view.addSubview(progressRing)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      self.progressRing.setValue(0.7, animated: true) { finished in
        print("testing___", finished)
      }
    }
  }
}
