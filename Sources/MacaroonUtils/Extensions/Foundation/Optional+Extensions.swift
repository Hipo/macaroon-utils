// Copyright © Hipolabs. All rights reserved.

import Foundation

extension Optional {
    public func unwrap<T>(
        _ transform: (Wrapped) -> T
    ) -> T? {
        return map(transform)
    }

    public func unwrap<T>(
        _ transform: (Wrapped) -> T?
    ) -> T? {
        return flatMap(transform)
    }

    public func unwrap<T>(
        _ transform: (Wrapped) -> T,
        or defaultValue: T
    ) -> T {
        return unwrap(transform) ?? defaultValue
    }

    public func unwrap<T>(
        _ transform: (Wrapped) -> T?,
        or defaultValue: T
    ) -> T {
        return unwrap(transform) ?? defaultValue
    }

    public func unwrap<T>(
        _ keyPath: KeyPath<Wrapped, T>
    ) -> T? {
        return unwrap { $0[keyPath: keyPath] }
    }

    public func unwrap<T>(
        _ keyPath: KeyPath<Wrapped, T?>
    ) -> T? {
        return unwrap { $0[keyPath: keyPath] }
    }

    public func unwrap<T>(
        _ keyPath: KeyPath<Wrapped, T>,
        or defaultValue: T
    ) -> T {
        return unwrap(keyPath) ?? defaultValue
    }

    public func unwrap<T>(
        _ keyPath: KeyPath<Wrapped, T?>,
        or defaultValue: T
    ) -> T {
        return unwrap(keyPath) ?? defaultValue
    }

    public func unwrap(
        where predicate: (Wrapped) -> Bool
    ) -> Wrapped? {
        return unwrap { predicate($0) ? $0 : nil }
    }
}

extension Optional where Wrapped == String {
    public func unwrapNonEmptyString() -> String? {
        return unwrap {
            !$0.isEmpty
        }
    }
}
