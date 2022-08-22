// Copyright © 2022 hipolabs. All rights reserved.

import Foundation

extension Numeric where Self: Comparable {
    public func clamped(_ bounds: ClosedRange<Self>) -> Self {
        return min(bounds.upperBound, max(bounds.lowerBound, self))
    }
}
