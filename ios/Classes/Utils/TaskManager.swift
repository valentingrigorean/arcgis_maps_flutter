//
//  TaskManager.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 02.07.2023.
//

import Foundation

class TaskManager {
    private var tasks: [String: Task<Void, Error>] = [:]
    private let lock = DispatchQueue(label: "TaskManager")

    private var isDisposed = false

    deinit {
        isDisposed = true
        cancelAllTasks()
    }

    @discardableResult
    func createTask(key: String? = nil, operation: @escaping @Sendable () async throws -> Void) -> Task<Void, Error> {
        let taskKey = key ?? UUID().uuidString
        let task = Task(priority: .userInitiated) {
            defer {
                lock.async {
                    if !self.isDisposed {
                        self.tasks.removeValue(forKey: taskKey)
                    }
                }
            }
            do {
                try await operation()
            } catch {
                if error is CancellationError {
                    print("Task \(taskKey) was cancelled")
                } else {
                    if !self.isDisposed {
                        print("Task \(taskKey) failed with error: \(error)")
                    } else {
                        throw error
                    }
                }
            }
        }

        lock.async {
            self.tasks[taskKey] = task
        }
        return task
    }

    func cancelTask(withKey key: String) {
        lock.async {
            self.tasks[key]?.cancel()
            self.tasks.removeValue(forKey: key)
        }
    }

    func cancelAllTasks() {
        lock.async {
            for (_, task) in self.tasks {
                task.cancel()
            }
            self.tasks.removeAll()
        }
    }
}

