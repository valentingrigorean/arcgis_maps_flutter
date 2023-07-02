//
//  TaskManager.swift
//  arcgis_maps_flutter
//
//  Created by Valentin Grigorean on 02.07.2023.
//

import Foundation

class TaskManager {
    private var tasks: [UUID: Task<Void, Error>] = [:]

    deinit {
        cancelAllTasks()
    }

    @discardableResult
    func createTask(operation: @escaping @Sendable () async throws -> Void) -> Task<Void, Error> {
        let taskId = UUID()
        let task = Task {
            do {
                try await operation()
            } catch {
                throw error
            }
        }

        let wrapperTask = Task {
            do {
                try await task.value
            } catch {
                throw error
            }
            tasks.removeValue(forKey: taskId)
        }

        tasks[taskId] = wrapperTask
        return wrapperTask
    }

    func cancelTask(withId id: UUID) {
        tasks[id]?.cancel()
        tasks.removeValue(forKey: id)
    }

    func cancelAllTasks() {
        for (_, task) in tasks {
            task.cancel()
        }
        tasks.removeAll()
    }
}
