// Copyright © 2021 Shawn James. All rights reserved.
// Created by Shawn James
// SearchResults.swift

import Foundation

// MARK: - Root
struct SearchResults: Codable {
    var events: [Event]
}

// MARK: - Event
typealias Events = [Event]

struct Event: Codable {
    let id: Int
    let venue: Venue
    let performers: [Performer]
    let datetimeLocal: String
    let timeTbd: Bool
    let visibleUntilUtc: String
    let dateTbd: Bool
    let title: String
}

// MARK: - Performer
struct Performer: Codable {
    let image: String?
}

// MARK: - Venue
struct Venue: Codable {
    let displayLocation: String
}

extension String {
    func displayDateString(dateTBD: Bool, timeTBD: Bool) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        if let eventDate = formatter.date(from: self) {
            switch (dateTBD, timeTBD) {
            case (false, false):
                formatter.dateFormat = "EEEE, MMMM d, yyyy, h:mm a"
                return formatter.string(from: eventDate)
            case (false, true):
                formatter.dateFormat = "EEEE, MMMM d, yyyy"
                return formatter.string(from: eventDate)
            default:
                return "TBD"
            }
        } else {
            return "Check website for date & time"
        }
    }

}
