//
// Created by Valentin Grigorean on 03.07.2023.
//

import Foundation


extension Sequence {
    func asyncMap<T>(_ transform: @escaping (Element) async -> T) async -> [T] {
        await withTaskGroup(of: T.self) { group in
            var transformedElements = [T]()

            for element in self {
                group.addTask {
                    await transform(element)
                }
            }

            for await transformedElement in group {
                transformedElements.append(transformedElement)
            }

            return transformedElements
        }
    }
}