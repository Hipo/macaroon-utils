// Copyright © Hipolabs. All rights reserved.

import Foundation

public func crash(
    _ error: Error
) -> Never {
    fatalError(error.localizedDescription)
}

/// <mark>
/// GCD
public func asyncMain(
    execute: @escaping () -> Void
) {
    DispatchQueue
        .main
        .async(execute: execute)
}

public func asyncMain(
    workItem: DispatchWorkItem
) {
    DispatchQueue
        .main
        .async(execute: workItem)
}

public func asyncMain<T: AnyObject>(
    _ instance: T,
    execute: @escaping (T) -> Void
) {
    asyncMain {
        [weak instance] in

        guard let strongInstance = instance else {
            return
        }

        execute(strongInstance)
    }
}

public func asyncMain(
    afterDuration d: TimeInterval,
    execute: @escaping () -> Void
) {
    /// <note>
    /// It is more efficien for calling without deadline if duration is zero.
    if d > 0 {
        DispatchQueue
            .main
            .asyncAfter(
                deadline: DispatchTime.now() + d,
                execute: execute
            )
    } else {
        DispatchQueue
            .main
            .async(execute: execute)
    }
}

public func asyncMain(
    afterDuration d: TimeInterval,
    workItem: DispatchWorkItem
) {
    /// <note>
    /// It is more efficien for calling without deadline if duration is zero.
    if d > 0 {
        DispatchQueue
            .main
            .asyncAfter(
                deadline: DispatchTime.now() + d,
                execute: workItem
            )
    } else {
        DispatchQueue
            .main
            .async(execute: workItem)
    }
}

public func asyncMain<T: AnyObject>(
    _ instance: T,
    afterDuration d: TimeInterval,
    execute: @escaping (T) -> Void
) {
    asyncMain(afterDuration: d) {
        [weak instance] in

        guard let strongInstance = instance else {
            return
        }

        execute(strongInstance)
    }
}

public func asyncBackground(
    qos: DispatchQoS.QoSClass = .background,
    execute: @escaping () -> Void
) {
    DispatchQueue
        .global(qos: qos)
        .async(execute: execute)
}

public func asyncBackground<T: AnyObject>(
    _ instance: T,
    qos: DispatchQoS.QoSClass = .background,
    execute: @escaping (T) -> Void
) {
    asyncBackground(qos: qos) {
        [weak instance] in

        guard let strongInstance = instance else {
            return
        }

        execute(strongInstance)
    }
}

/// <mark>
///Debug
public func debug(
    _ execute: () -> Void
) {
    #if DEBUG
    execute()
    #endif
}

public func release(
    _ execute: () -> Void
) {
    #if !DEBUG
    execute()
    #endif
}
