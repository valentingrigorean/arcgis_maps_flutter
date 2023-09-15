//
//  TaskManager.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 02.07.2023.
//

import Foundation

class TaskManager {
    private var tasks: [String: Task<Void, Error>] = [:]

    deinit {
        cancelAllTasks()
    }

    @discardableResult
    func createTask(key: String? = nil, operation: @escaping @Sendable () async throws -> Void) -> Task<Void, Error> {
        let taskKey = key ?? UUID().uuidString
        let task = Task(priority: .userInitiated) {
            defer {
                tasks.removeValue(forKey: taskKey)
            }
            do {
                try await operation()
            } catch {
                if error is CancellationError {
                    print("Task \(taskKey) was cancelled")
                } else {
                    throw error
                }
            }
        }

        tasks[taskKey] = task
        return task
    }

    func cancelTask(withKey key: String) {
        tasks[key]?.cancel()
        tasks.removeValue(forKey: key)
    }

    func cancelAllTasks() {
        for (_, task) in tasks {
            task.cancel()
        }
        tasks.removeAll()
    }
}

