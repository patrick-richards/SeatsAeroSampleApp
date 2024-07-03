//
//  ExploreTests.swift
//  SeatsAeroSampleAppTests
//
//  Created on 19/6/2024.
//

import XCTest

final class ExploreTests: XCTestCase {
    private var explore: Explore!

    override func setUpWithError() throws {
        explore = Explore(source: .velocity)
    }

    override func tearDownWithError() throws {
        explore = nil
    }

    func testSettingStartDateInThePast() throws {
        // set start date to yesterday
        explore.startDate = Date().addingTimeInterval(-60 * 60 * 24)
        let isSameDay = Calendar.current.isDate(Date(), inSameDayAs: explore.startDate)
        XCTAssert(isSameDay == true, "Start date should not be in the past")
    }

    func testSettingEndDateBeforeStartDate() throws {
        // set start date to today, end date to yesterday
        // end day should update accordingly
        explore.startDate = Date()
        explore.endDate = Date().addingTimeInterval(-60 * 60 * 24)
        XCTAssert(explore.startDate < explore.endDate, "Start date should always be before end date")
    }
    
    func testSettingStartDateAfterEndDate() throws {
        // set start date 7 days into the future, start date to one day after that
        // start date should be updated accordingly
        explore.endDate = Date().addingTimeInterval(60 * 60 * 24 * 5)
        explore.startDate = explore.endDate.addingTimeInterval(60 * 60 * 24)

        XCTAssert(explore.startDate < explore.endDate, "Start date should always be before end date")
    }

}
