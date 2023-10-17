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
        lock.sync {
            isDisposed = true
        }
        cancelAllTasks()
    }

    @discardableResult
    func createTask(key: String? = nil, operation: @escaping @Sendable () async throws -> Void) -> Task<Void, Error> {
        lock.sync {
            // Check disposed status
            guard !isDisposed else {
                // Handle or throw an error, e.g.:
                // throw CustomError("TaskManager is disposed")
                return Task<Void, Error> {
                    throw NSError(domain: "TaskManager", code: 1, userInfo: nil)
                }
            }

            let taskKey = key ?? UUID().uuidString
            let task = Task<Void, Error>(priority: .userInitiated) {
                do {
                    try await operation()
                } catch {
                    if !isDisposed {
                        if error is CancellationError {
                            print("Task \(taskKey) was cancelled")
                        } else {
                            print("Task \(taskKey) failed with error: \(error)")
                        }
                    }
                }
            }

            tasks[taskKey] = task

            return task
        }
    }

    func cancelTask(withKey key: String) {
        lock.sync {
            tasks[key]?.cancel()
            tasks.removeValue(forKey: key)
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

