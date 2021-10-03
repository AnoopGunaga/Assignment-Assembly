//
//  RedditPicsModelTests.swift
//  RedditPicsBrowser-iOSTests
//
//  Created by Anoop on 03/10/21.
//

import XCTest
@testable import RedditPicsBrowser_iOS

class RedditPicsModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testTimeStamp() {
        let imageInfo = ImageInfo(created: 0.0)
        
        let publishedDate = Date(timeIntervalSince1970:0.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.applicationDateFormat
        let dateString = dateFormatter.string(from: publishedDate)
        
        let timeStamp = imageInfo.timestamp
        
        XCTAssertEqual(dateString, timeStamp)
    }
    
    func testTimeStampForInvalidInput() {
        let imageInfo = ImageInfo(created: 1630020346.0)
        
        let publishedDate = Date(timeIntervalSince1970:1630020346.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.applicationDateFormat
        let dateString = dateFormatter.string(from: publishedDate)
        
        let timeStamp = imageInfo.timestamp
        
        XCTAssertEqual(dateString, timeStamp)
    }
    
    func testContentCategory() {
        let imageInfo = ImageInfo(categories: ["photography"])
        let contentCategory = imageInfo.contentCategory
        
        XCTAssertEqual(contentCategory, "photography")
    }
    
    func testContentCategoryForInValidInput() {
        let imageInfo = ImageInfo(categories: nil)
        let contentCategory = imageInfo.contentCategory
        
        XCTAssertEqual(contentCategory, "")
    }
}
