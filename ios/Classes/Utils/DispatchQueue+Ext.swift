//
// Created by Valentin Grigorean on 19.01.2023.
//

import Foundation

extension DispatchQueue {
    func dispatchMainIfNeeded(execute work: @escaping @convention(block) () -> Void) {
        guard self === DispatchQueue.main && Thread.isMainThread else {
            DispatchQueue.main.async(execute: work)
            return
        }
        work()
    }
}