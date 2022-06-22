// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Float {
    public var number: NSNumber {
        return NSNumber(value: self)
    }
    public var cgFloat: CGFloat {
        return CGFloat(self)
    }
}
