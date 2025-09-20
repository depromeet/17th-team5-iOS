//
//  BaseNavigationController.swift
//  Core
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import UIKit

public class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
