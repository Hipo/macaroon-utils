// Copyright © Hipolabs. All rights reserved.

import Foundation

extension Result {
    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    public var isFailure: Bool {
        switch self {
        case .success: return false
        case .failure: return true
        }
    }
}
