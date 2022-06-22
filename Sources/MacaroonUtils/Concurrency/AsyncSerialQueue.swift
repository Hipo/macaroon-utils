// Copyright © 2022 hipolabs. All rights reserved.

import Foundation

open class AsyncSerialQueue {
    public var isExecuting: Bool {
        return _isExecuting.wrappedValue
    }
    public var isSuspended: Bool {
        return _isSuspended.wrappedValue
    }
    public var isCancelled: Bool {
        return _isCancelled.wrappedValue
    }

    public let name: String
    public let underlyingQueue: DispatchQueue

    private var _pendingTasks: Atomic<[AsyncTask]>
    private var _executingTask: Atomic<AsyncTask?>
    private var _isExecuting: Atomic<Bool>
    private var _isSuspended: Atomic<Bool>
    private var _isCancelled: Atomic<Bool>

    public init(
        name: String,
        underlyingQueue: DispatchQueue = .main
    ) {
        let updateQueue = DispatchQueue(label: name)

        self.name = name
        self.underlyingQueue = underlyingQueue
        self._pendingTasks = Atomic(wrappedValue: [], queue: updateQueue)
        self._executingTask = Atomic(wrappedValue: nil, queue: updateQueue)
        self._isExecuting = Atomic(wrappedValue: false, queue: updateQueue)
        self._isSuspended = Atomic(wrappedValue: false, queue: updateQueue)
        self._isCancelled = Atomic(wrappedValue: false, queue: updateQueue)
    }

    open func add(
        _ newTask: AsyncTask
    ) {
        enqueue(newTask)
        executeNextTask()
    }

    open func resume() {
        setCancelled(false)
        setSuspended(false)
        executeNextTask()
    }

    open func suspend() {
        setSuspended(true)
        cancelAllTasks()
    }

    open func cancel() {
        setCancelled(true)
        cancelAllTasks()
        dequeueAll()
    }
}

extension AsyncSerialQueue {
    private func enqueue(
        _ newTask: AsyncTask
    ) {
        _pendingTasks.mutate {
            $0.append(newTask)
        }
    }

    private func enqueueFirst(
        _ newTask: AsyncTask
    ) {
        _pendingTasks.mutate {
            $0.insert(
                newTask,
                at: 0
            )
        }
    }

    private func dequeue() -> AsyncTask? {
        guard let task = _pendingTasks.wrappedValue.first else {
            return nil
        }

        _pendingTasks.mutate {
            $0.removeFirst()
        }

        return task
    }

    private func dequeueAll() {
        _pendingTasks.mutate {
            $0.removeAll()
        }
    }
}

extension AsyncSerialQueue {
    private func executeNextTask() {
        if !canExecuteNextTask() {
            return
        }

        guard let task = dequeue() else {
            setExecutingTask(nil)
            return
        }

        setExecuting(true)
        setExecutingTask(task)

        let executableTask = task.map(qos: .userInteractive) {
            [weak self] in
            guard let self = self else { return }

            self.setExecuting(false)
            self.executeNextTask()
        }
        underlyingQueue.async(execute: executableTask)
    }

    private func canExecuteNextTask() -> Bool {
        return
            !isCancelled &&
            !isSuspended &&
            !isExecuting
    }

    private func cancelAllTasks() {
        let pendingTasks = _pendingTasks.wrappedValue
        pendingTasks.forEach { $0.cancel() }

        cancelExecutingTask()
    }

    private func cancelExecutingTask() {
        guard let task = _executingTask.wrappedValue else {
            return
        }

        task.cancel()

        setExecuting(false)
        setExecutingTask(nil)

        enqueueFirst(task)
    }
}

extension AsyncSerialQueue {
    private func setExecutingTask(
        _ task: AsyncTask?
    ) {
        _executingTask.mutateValue(task)
    }

    private func setExecuting(
        _ newValue: Bool
    ) {
        _isExecuting.mutateValue(newValue)
    }

    private func setSuspended(
        _ newValue: Bool
    ) {
        _isSuspended.mutateValue(newValue)
    }

    private func setCancelled(
        _ newValue: Bool
    ) {
        _isCancelled.mutateValue(newValue)
    }
}
