// Copyright © 2021 Shawn James. All rights reserved.
// Created by Shawn James
// SeatGeek.swift

import Foundation

class SeatGeek {

    enum SearchError: Error {
        case badURL
        case badRequest
        case badData
    }

    private let endpoint = URL(string: "https://api.seatgeek.com/2/events/")!
    private let clientId = String("zMTO1AzMz4CNyAzN4kDNxYTM8VDOzUzN1EjM".reversed())

    func getSearchResults(for searchTerm: String, completion: @escaping (Result<Events?, SearchError>) -> Void) {
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: false)
        let queryItems = [URLQueryItem(name: "q", value: searchTerm),
                          URLQueryItem(name: "client_id", value: clientId)]
        components?.queryItems = queryItems

        guard let url = components?.url else {
            completion(.failure(.badURL)); return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200, error == nil else {
                completion(.failure(.badRequest)); return
            }

            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let searchResults = try decoder.decode(SearchResults.self, from: data)
                    completion(.success(searchResults.events))
                } catch {
                    print(error)
                    completion(.failure(.badData))
                }
            }

        }.resume()
    }

}
