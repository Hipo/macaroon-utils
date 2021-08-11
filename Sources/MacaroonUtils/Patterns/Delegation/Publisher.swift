// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol Publisher: AnyObject {
    associatedtype Observer

    func add(
        _ observer: Observer
    )
    func remove(
        _ observer: Observer
    )
    func notifyObservers(
        _ block: (Observer) -> Void
    )
    func invalidateObservers()
}

public protocol WeakPublisher: Publisher
where Observer: AnyObject {
    var observations: [ObjectIdentifier: WeakObservation<Observer>] { get set }
}

extension WeakPublisher {
    public func add(
        _ observer: Observer
    ) {
        let id = generateIdentifier(observer)
        observations[id] = WeakObservation(observer)
    }

    public func remove(
        _ observer: Observer
    ) {
        let id = generateIdentifier(observer)
        observations[id] = nil
    }

    public func notifyObservers(
        _ block: (Observer) -> Void
    ) {
        observations.forEach {
            if let anObserver = $0.value.observer {
                block(anObserver)
            } else {
                observations[$0.key] = nil
            }
        }
    }

    public func invalidateObservers() {
        observations.removeAll()
    }
}

extension WeakPublisher {
    private func generateIdentifier(
        _ observer: Observer
    ) -> ObjectIdentifier {
        return ObjectIdentifier(observer)
    }
}

public final class WeakObservation<Observer: AnyObject> {
    public private(set) weak var observer: Observer?

    public init(
        _ observer: Observer
    ) {
        self.observer = observer
    }
}
