//
// Created by Valentin Grigorean on 25.07.2022.
//

import Foundation

protocol NativeHandler {
    var messageSink: NativeMessageSink? { get set }
    
    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool
}


class BaseNativeHandler<T>: NSObject,NativeHandler {
    private var tasks: [Int: Task<Void, Error>] = [:]
    private var taskIdCounter = 0
    
    let nativeHandler: T
    
    init(nativeHandler: T) {
        self.nativeHandler = nativeHandler
    }
    
    deinit {
        messageSink = nil
        cancelAllTasks()
    }
    
    var messageSink: NativeMessageSink?
    
    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) -> Bool {
        false
    }
    
    func sendMessage(method: String, arguments: Any?) {
        print("BaseNativeHandler.sendMessage: \(method)")
        messageSink?.send(method: method, arguments: arguments)
    }
    
    @discardableResult
    func createTask(operation: @escaping @Sendable () async throws -> Void) -> Task<Void, Error> {
        let taskId = taskIdCounter
        let task = Task {
            do {
                try await operation()
            } catch {
                throw error
            }
        }
        tasks[taskId] = task
        taskIdCounter += 1
        return task
    }
    
    
    private func cancelAllTasks() {
        for (_, task) in tasks {
            task.cancel()
        }
        tasks.removeAll()
    }
}

protocol NativeObject {
    var objectId: String { get }
    
    var messageSink: NativeMessageSink { get }
    
    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult)
}

public class NativeObjectMessageSink: NativeMessageSink {
    private let objectId: String
    
    private let messageSink: NativeMessageSink
    
    init(objectId: String, messageSink: NativeMessageSink) {
        self.objectId = objectId
        self.messageSink = messageSink
    }
    
    public func send(method: String, arguments: Any?) {
        messageSink.send(method: "messageNativeObject", arguments: [
            "objectId": objectId,
            "method": method,
            "arguments": arguments
        ])
    }
}


class BaseNativeObject<T>: NativeMessageSink, NativeObject {
    private var nativeObjectMessageSink: NativeObjectMessageSink
    private var tasks: [Int: Task<Void, Error>] = [:]
    private var taskIdCounter = 0
    
    private var isDisposed: Bool = false
    private let nativeHandlers: [NativeHandler]
    
    let objectId: String
    
    let nativeObject: T
    
    var messageSink: NativeMessageSink
    
    init(objectId: String, nativeObject: T, nativeHandlers: [NativeHandler], messageSink: NativeMessageSink) {
        self.objectId = objectId
        self.nativeObject = nativeObject
        self.nativeHandlers = nativeHandlers
        self.messageSink = messageSink
        nativeObjectMessageSink = NativeObjectMessageSink(objectId: objectId, messageSink: messageSink)
        
        for var handler in nativeHandlers {
            handler.messageSink = self
        }
    }
    
    deinit {
        isDisposed = true
        cancelAllTasks()
    }
    
    var storage: NativeObjectStorage {
        get {
            NativeObjectStorage.shared
        }
    }
    
    func send(method: String, arguments: Any?) {
        if (isDisposed) {
            return
        }
        nativeObjectMessageSink.send(method: method, arguments: arguments)
    }
    
    func onMethodCall(method: String, arguments: Any?, result: @escaping FlutterResult) {
        for handler in nativeHandlers {
            if handler.onMethodCall(method: method, arguments: arguments, result: result) {
                return
            }
        }
        result(FlutterMethodNotImplemented)
    }

    @discardableResult
    func createTask(operation: @escaping @Sendable () async throws -> Void) -> Task<Void, Error> {
        let taskId = taskIdCounter
        let task = Task<Void, Error> {
            do {
                try await operation()
            } catch {
                throw error
            }
        }
        tasks[taskId] = task
        taskIdCounter += 1
        return task
    }

    
    private func cancelAllTasks() {
        for (_, task) in tasks {
            task.cancel()
        }
        tasks.removeAll()
    }
}
