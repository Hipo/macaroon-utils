// Copyright © 2019 hipolabs. All rights reserved.

/// <src>
/// https://www.vadimbulavin.com/swift-atomic-properties-with-property-wrappers/

import Foundation

@propertyWrapper
public final class Atomic<Value> {
    public var wrappedValue: Value {
        get { queue.sync { value } }
        set { crash("Unavailable") }
    }
    public var projectedValue: Atomic<Value> {
        return self
    }

    private var value: Value

    private let queue: DispatchQueue

    public init(
        wrappedValue: Value,
        queue: DispatchQueue
    ) {
        self.value = wrappedValue
        self.queue = queue
    }

    public convenience init(
        wrappedValue: Value,
        identifier: String
    ) {
        let queueIdentifier = "\(Bundle.main.bundleIdentifier.someString).\(identifier)"
        let queue = DispatchQueue(label: queueIdentifier)
        self.init(wrappedValue: wrappedValue, queue: queue)
    }

    public func mutate(
        _ transform: (inout Value) -> Void
    ) {
        queue.sync { transform(&value) }
    }

    public func mutateValue(
        _ newValue: Value
    ) {
        mutate {
            $0 = newValue
        }
    }
}
