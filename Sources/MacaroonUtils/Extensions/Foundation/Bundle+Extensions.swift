// Copyright © Hipolabs. All rights reserved.

import Foundation

extension Bundle {
    public subscript<T>(infoIdentifier: String) -> T? {
        return infoDictionary?[infoIdentifier] as? T
    }
}
