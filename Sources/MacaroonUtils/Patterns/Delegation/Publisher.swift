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
where Observer == WeakObservation.Observer {
    associatedtype WeakObservation: WeakObservable

    var observations: [ObjectIdentifier: WeakObservation] { get set }
}

extension WeakPublisher {
    public func add(
        _ observer: WeakObservation.Observer
    ) {
        let id = generateIdentifier(observer)
        observations[id] = WeakObservation(observer)
    }

    public func remove(
        _ observer: WeakObservation.Observer
    ) {
        let id = generateIdentifier(observer)
        observations[id] = nil
    }

    public func notifyObservers(
        _ block: (WeakObservation.Observer) -> Void
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
        _ observer: WeakObservation.Observer
    ) -> ObjectIdentifier {
        return ObjectIdentifier(observer as AnyObject)
    }
}

public protocol WeakObservable {
    associatedtype Observer

    /// <warning>
    /// Must be a weak variable to prevent retain cycle.
    var observer: Observer? { get }

    init(
        _ observer: Observer
    )
}
