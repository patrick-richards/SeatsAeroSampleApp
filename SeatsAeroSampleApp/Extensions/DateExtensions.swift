//
//  DateExtensions.swift
//  Sero
//
//  Created on 13/6/2024.
//

import Foundation

extension Date.FormatStyle {
    func withoutTimeZone() -> Date.FormatStyle {
        var copy = self
        copy.timeZone = TimeZone(secondsFromGMT: 0)!
        return copy
    }
}
