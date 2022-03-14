//
// Created by Valentin Grigorean on 12.09.2021.
//

import Foundation

private let format :ISO8601DateFormatter = {
    let dateFormat = ISO8601DateFormatter()
    dateFormat.formatOptions = [.withInternetDateTime,.withFractionalSeconds]
    return dateFormat
}()

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

extension String {
    func toDateFromIso8601() -> Date? {
        format.date(from: self)
    }
}