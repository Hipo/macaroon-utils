// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension Int {
    public var number: NSNumber {
        return NSNumber(value: self)
    }
    public var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

extension Int {
    public var ordinalDescription: String {
        return NumberFormatter.ordinal.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Optional where Wrapped == Int {
    public var someInt: Int {
        return self ?? 0
    }
}
