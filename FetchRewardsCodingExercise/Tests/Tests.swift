// Copyright © 2021 Shawn James. All rights reserved.
// Created by Shawn James
// Tests.swift

@testable import FetchRewardsCodingExercise
import XCTest

class FetchRewardsCodingExerciseTests: XCTestCase {

    private let seatGeek = SeatGeek()

    func testEventSearching() {
        let expectation = XCTestExpectation(description: "Wait for async response")

        seatGeek.getSearchResults(for: "Raiders") { result in
            switch result {
            case let .success(searchResults):
                XCTAssertNotNil(searchResults)
            case let .failure(searchError):
                XCTFail("\(searchError)")
            }

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)

    }

    func testImageDownloading() {
        let imageView = UIImageView()
        let imageURL = "seatgeek.com/images/performers-landscape/utah-state-aggies-football-8d43f7/5668/huge.jpgwith"

        imageView.loadImage(with: imageURL)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            XCTAssertNotNil(imageView.image)
        }

    }

}
