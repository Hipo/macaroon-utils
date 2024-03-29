// Copyright © Hipolabs. All rights reserved.

import Foundation

extension Array {
    public func firstIndex<T: Equatable>(
        matching equation: (KeyPath<Element, T>, Element?)
    ) -> Index? {
        return firstIndex { $0[keyPath: equation.0] == equation.1?[keyPath: equation.0] }
    }

    public func firstIndex<T: Equatable>(
        matching equation: (KeyPath<Element, T?>, Element?)
    ) -> Index? {
        return firstIndex { $0[keyPath: equation.0] == equation.1?[keyPath: equation.0] }
    }
}

extension Array {
    public subscript(
        safe index: Index?
    ) -> Element? {
        return
            index
                .unwrap { indices.contains($0) }
                .unwrap { self[$0] }
    }

    public func element(
        beforeElementAt i: Index
    ) -> Element? {
        return
            i > startIndex
                ? self[safe: index(before: i)]
                : nil
    }

    public func element(
        afterElementAt i: Index
    ) -> Element? {
        return
            lastIndex.unwrap {
                i > startIndex && i < $0
                    ? self[safe: index(after: i)]
                    : nil
            }
    }

    public func first<T>(
        _ keyPath: KeyPath<Element, T>,
        where predicate: (Element) -> Bool
    ) -> T? {
        let elem = first(where: predicate)
        return elem?[keyPath: keyPath]
    }

    public func first<T>(
        _ keyPath: KeyPath<Element, T?>,
        where predicate: (Element) -> Bool
    ) -> T? {
        let elem = first(where: predicate)
        return elem?[keyPath: keyPath]
    }

    public func first<T>(
        existing keyPath: KeyPath<Element, T?>
    ) -> T? {
        let elem = first { $0[keyPath: keyPath] != nil }
        return elem?[keyPath: keyPath]
    }

    public func first<T: Equatable>(
        matching equation: (KeyPath<Element, T>, T?)
    ) -> Element? {
        return first { $0[keyPath: equation.0] == equation.1 }
    }

    public func first<T: Equatable>(
        matching equation: (KeyPath<Element, T?>, T?)
    ) -> Element? {
        return first { $0[keyPath: equation.0] == equation.1 }
    }

    public func last<T>(
        existing keyPath: KeyPath<Element, T?>
    ) -> T? {
        let elem = last { $0[keyPath: keyPath] != nil }
        return elem?[keyPath: keyPath]
    }

    public func last<T: Equatable>(
        matching equation: (KeyPath<Element, T>, T?)
    ) -> Element? {
        return last { $0[keyPath: equation.0] == equation.1 }
    }

    public func last<T: Equatable>(
        matching equation: (KeyPath<Element, T?>, T?)
    ) -> Element? {
        return last { $0[keyPath: equation.0] == equation.1 }
    }

    public func uniqueElements<T: Hashable>(
        for keyPath: KeyPath<Element, T>
    ) -> [Element] {
        var observer: Set<T> = []
        return filter { observer.insert($0[keyPath: keyPath]).inserted }
    }

    public func nonNilElements<T>() -> [T] where Element == T? {
        return compactMap { $0 }
    }
}

extension Array {
    public mutating func remove(
        where predicate: (Element) -> Bool
    ) -> [Element] {
        var elements: [Element] = []
        var elementsToRemove: [Element] = []
        for elem in self {
            if predicate(elem) {
                elementsToRemove.append(elem)
            } else {
                elements.append(elem)
            }
        }

        self = elements

        return elementsToRemove
    }

    @discardableResult
    public mutating func removeFirst(
        where predicate: (Element) -> Bool
    ) -> Element? {
        guard let index = firstIndex(where: predicate) else {
            return nil
        }

        return remove(at: index)
    }

    @discardableResult
    public mutating func removeLast(
        where predicate: (Element) -> Bool
    ) -> Element? {
        guard let index = lastIndex(where: predicate) else {
            return nil
        }

        return remove(at: index)
    }
}

extension Array where Element: Equatable {
    public func element(
        before e: Element
    ) -> Element? {
        let index = firstIndex(of: e)
        return index.unwrap(element(beforeElementAt:))
    }

    public func element(
        after e: Element
    ) -> Element? {
        let index = firstIndex(of: e)
        return index.unwrap(element(afterElementAt:))
    }
}

extension Array where Element: Hashable {
    public func uniqueElements() -> [Element] {
        var observer: Set<Element> = []
        return filter { observer.insert($0).inserted }
    }
}

extension Array where Element == String? {
    public func compound(
        _ separator: String = " "
    ) -> String {
        return self
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: separator)
    }
}

extension Optional where Wrapped: Sequence {
    public func unwrapMap<T>(
        _ transform: (Wrapped.Element) -> T
    ) -> [T] {
        return unwrap(
            { $0.map(transform) },
            or: []
        )
    }
}

extension Optional where Wrapped: Collection & ExpressibleByArrayLiteral {
    public var someArray: [Wrapped.Element] {
        return (self as? [Wrapped.Element]) ?? []
    }
}
