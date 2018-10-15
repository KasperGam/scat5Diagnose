/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The file contains the code to automatically set up dependencies between mutually exclusive operations.
*/

import Foundation

/**
    `ExclusivityController` is a singleton to keep track of all the in-flight
    `Operation` instances that have declared themselves as requiring mutual exclusivity.
    We use a singleton because mutual exclusivity must be enforced across the entire
    app, regardless of the `OperationQueue` on which an `Operation` was executed.
*/
open class ExclusivityController {
    static let sharedExclusivityController = ExclusivityController()

    fileprivate let serialQueue = DispatchQueue(label: "Operations.ExclusivityController", attributes: [])
    fileprivate var operations: [String: [Operation]] = [:]

    fileprivate init() {
        /*
            A private initializer effectively prevents any other part of the app
            from accidentally creating an instance.
        */
    }

    /// Registers an operation as being mutually exclusive
    open func addOperation(_ operation: Operation, categories: [String]) {
        /*
            This needs to be a synchronous operation.
            If this were async, then we might not get around to adding dependencies
            until after the operation had already begun, which would be incorrect.
        */
        serialQueue.sync {
            for category in categories {
                self.noqueue_addOperation(operation, category: category)
            }
        }
    }

    /// Unregisters an operation from being mutually exclusive.
    open func removeOperation(_ operation: Operation, categories: [String]) {
        serialQueue.sync {
            for category in categories {
                self.noqueue_removeOperation(operation, category: category)
            }
        }
    }


    // MARK: Operation Management

    fileprivate func noqueue_addOperation(_ operation: Operation, category: String) {
        var operationsWithThisCategory = operations[category] ?? []

        if let last = operationsWithThisCategory.last {
            assert(last.dependencies.contains(operation) == false, "Deadlocked")
            operation.addDependency(last)
        }

        operationsWithThisCategory.append(operation)

        if operationsWithThisCategory.count >= 3, let first = operationsWithThisCategory.first {
            let ready = first.isReady
            let executing = first.isExecuting
            let hasNoDependencies = first.dependencies.count == 0
            let hasStalled = ready && !executing && hasNoDependencies

            if hasStalled {
                first.cancel()
            }
        }

        operations[category] = operationsWithThisCategory
    }

    fileprivate func noqueue_removeOperation(_ operation: Operation, category: String) {
        let matchingOperations = operations[category]

        guard var operationsWithThisCategory = matchingOperations else { return }

        if let index = operationsWithThisCategory.index(of: operation) {
            operationsWithThisCategory.remove(at: index)
            operations[category] = operationsWithThisCategory
        }
    }

}
