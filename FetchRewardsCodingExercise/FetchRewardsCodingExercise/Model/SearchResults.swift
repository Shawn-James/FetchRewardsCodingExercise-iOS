// Copyright © 2021 Shawn James. All rights reserved.
// Created by Shawn James
// SearchResults.swift

// MARK: - Root

struct SearchResults: Codable {
    let events: [Event]
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
