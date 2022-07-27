// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UINavigationController {
    public var navigationBarHeight: CGFloat {
        return isNavigationBarHidden ? 0 : navigationBar.bounds.height
    }
}

extension UINavigationController {
    public func isRoot(
        _ viewController: UIViewController
    ) -> Bool {
        return viewControllers.first == viewController
    }
}
