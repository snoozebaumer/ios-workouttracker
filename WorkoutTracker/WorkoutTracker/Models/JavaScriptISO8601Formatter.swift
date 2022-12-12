//
//  JavaScriptISO8601Formatter.swift
//  WorkoutTracker
//
//  Created by Samuel Nussbaumer on 12.12.22.
//  From: https://bootstragram.com/blog/json-dates-swift/
//  Swift doesn't decode ISO8601 Date format correctly, that's where this extension
//  comes into play.
//

import Foundation

class JavaScriptISO8601DateFormatter {
    static let fractionalSecondsFormatter: ISO8601DateFormatter = {
        let res = ISO8601DateFormatter()
        // The default format options is .withInternetDateTime.
        // We need to add .withFractionalSeconds to parse dates with milliseconds.
        res.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return res
    }()

    static let defaultFormatter = ISO8601DateFormatter()

    static func decodedDate(_ decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateAsString = try container.decode(String.self)

        // See warning below.
        for formatter in [fractionalSecondsFormatter, defaultFormatter] {
            if let res = formatter.date(from: dateAsString) {
                return res
            }
        }

        throw DecodingError.dataCorrupted(DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "Expected date string to be JavaScript-ISO8601-formatted."
        ))
    }

    static func encodeDate(date: Date, encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(fractionalSecondsFormatter.string(from: date))
    }

    private init() {}
}

extension JSONDecoder.DateDecodingStrategy {
    static func javaScriptISO8601() -> JSONDecoder.DateDecodingStrategy {
        .custom(JavaScriptISO8601DateFormatter.decodedDate)
    }
}

extension JSONEncoder.DateEncodingStrategy {
    static func javaScriptISO8601() -> JSONEncoder.DateEncodingStrategy {
        .custom(JavaScriptISO8601DateFormatter.encodeDate)
    }
}
