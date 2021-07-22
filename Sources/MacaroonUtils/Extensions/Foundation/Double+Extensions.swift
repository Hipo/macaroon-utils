// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Double {
    public var number: NSNumber {
        return NSNumber(value: self)
    }
    public var cgFloat: CGFloat {
        return CGFloat(self)
    }
}
