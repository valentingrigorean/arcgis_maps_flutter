//
// Created by Valentin Grigorean on 12.09.2021.
//

import Foundation

private let format = ISO8601DateFormatter()

extension Date {

    func toIso8601String() -> String {
        format.string(from: self)
    }

}

extension NSDate {

    func toIso8601String() -> String {
        format.string(from: self as Date)
    }
}