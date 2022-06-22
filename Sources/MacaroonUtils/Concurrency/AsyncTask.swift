// Copyright © 2022 hipolabs. All rights reserved.

import Foundation

open class AsyncTask {
    public private(set) var isCancelled: Bool

    private var workItem: DispatchWorkItem?

    private let block: ExecutionBlock
    private let cancellationBlock: CancellationBlock?

    public init(
        execution block: @escaping ExecutionBlock,
        cancellation cancellationBlock: CancellationBlock? = nil
    ) {
        self.block = block
        self.cancellationBlock = cancellationBlock
        self.isCancelled = false
    }

    open func resume() {
        isCancelled = false
    }

    open func cancel() {
        assertIfCancelled()

        isCancelled = true
        cancellationBlock?()
        workItem?.cancel()
    }
}

extension AsyncTask {
    public func map(
        qos: DispatchQoS,
        completion completionBlock: @escaping CompletionBlock
    ) -> DispatchWorkItem {
        assertIfCancelled()

        if workItem == nil {
            workItem = DispatchWorkItem(qos: qos) {
                [weak self] in
                guard let self = self else { return }

                self.block(completionBlock)
            }
        }

        return workItem!
    }
}

extension AsyncTask {
    private func assertIfCancelled() {
        assert(!isCancelled, "The task has already been cancelled!")
    }
}

extension AsyncTask {
    public typealias CompletionBlock = () -> Void
    public typealias CancellationBlock = () -> Void
    public typealias ExecutionBlock = (@escaping CompletionBlock) -> Void
}
