//
//  FavoriteManagerTests.swift
//  RedditPicsBrowser-iOSTests
//
//  Created by Anoop on 03/10/21.
//

import XCTest

@testable import RedditPicsBrowser_iOS

class FavoriteManagerTests: XCTestCase {

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

    func testAddToFavorites() {
        FavoriteManager.shared.clearAllFavorites()
        let redditPics = RedditPicture(imageInfo: PictutreInfo(imageId: "1234", thumbnail: "", author: "", title: "new title", created: 1234567, photoUrl: "", categories: nil))
        FavoriteManager.shared.addToFavorites(picture: redditPics)
        
        let favorites = FavoriteManager.shared.getFavorites()
        XCTAssertEqual(favorites?.count, 1)
    }
    
    func testAddToFavoritesDuplicates() {
        FavoriteManager.shared.clearAllFavorites()
        let redditPics1 = RedditPicture(imageInfo: PictutreInfo(imageId: "1234", thumbnail: "", author: "", title: "new title", created: 1234567, photoUrl: "", categories: nil))
        let redditPics2 = RedditPicture(imageInfo: PictutreInfo(imageId: "1234", thumbnail: "", author: "", title: "new title 2", created: 987654, photoUrl: "", categories: nil))
        FavoriteManager.shared.addToFavorites(picture: redditPics1)
        FavoriteManager.shared.addToFavorites(picture: redditPics2)
        
        let favorites = FavoriteManager.shared.getFavorites()
        XCTAssertEqual(favorites?.count, 1)
    }
    
    func testGetFavorites() {
        FavoriteManager.shared.clearAllFavorites()
        let redditPics1 = RedditPicture(imageInfo: PictutreInfo(imageId: "1234", thumbnail: "", author: "", title: "new title", created: 1234567, photoUrl: "", categories: nil))
        let redditPics2 = RedditPicture(imageInfo: PictutreInfo(imageId: "2345", thumbnail: "", author: "", title: "new title 2", created: 987654, photoUrl: "", categories: nil))
        FavoriteManager.shared.addToFavorites(picture: redditPics1)
        FavoriteManager.shared.addToFavorites(picture: redditPics2)
        
        let favorites = FavoriteManager.shared.getFavorites()
        XCTAssertEqual(favorites?.count, 2)
    }
    
    func testRemoveFromFavorites() {
        FavoriteManager.shared.clearAllFavorites()
        let redditPics = RedditPicture(imageInfo: PictutreInfo(imageId: "1234", thumbnail: "", author: "", title: "new title", created: 1234567, photoUrl: "", categories: nil))
        FavoriteManager.shared.addToFavorites(picture: redditPics)
        
        var favorites = FavoriteManager.shared.getFavorites()
        XCTAssertEqual(favorites?.count, 1, "Favorite not added")
        
        FavoriteManager.shared.removeFromFavrite(picture: redditPics)
        favorites = FavoriteManager.shared.getFavorites()
        XCTAssertEqual(favorites?.count, 0, "Favorite not deleted")
    }
    
    func testRemoveNonExistingItemFromFavorites() {
        FavoriteManager.shared.clearAllFavorites()
        let redditPics1 = RedditPicture(imageInfo: PictutreInfo(imageId: "1234", thumbnail: "", author: "", title: "new title", created: 1234567, photoUrl: "", categories: nil))
        let redditPics2 = RedditPicture(imageInfo: PictutreInfo(imageId: "6789", thumbnail: "", author: "", title: "new title", created: 1234567, photoUrl: "", categories: nil))

        FavoriteManager.shared.addToFavorites(picture: redditPics1)
        
        let favorites = FavoriteManager.shared.getFavorites()
        XCTAssertEqual(favorites?.count, 1, "Favorite not added")
        
        FavoriteManager.shared.removeFromFavrite(picture: redditPics2)
        XCTAssertEqual(favorites?.count, 1, "Favorite not deleted")
    }
    
    func testClearAllFavorites() {
        FavoriteManager.shared.clearAllFavorites()
        let redditPics1 = RedditPicture(imageInfo: PictutreInfo(imageId: "1234", thumbnail: "", author: "", title: "new title", created: 1234567, photoUrl: "", categories: nil))
        let redditPics2 = RedditPicture(imageInfo: PictutreInfo(imageId: "6789", thumbnail: "", author: "", title: "new title", created: 1234567, photoUrl: "", categories: nil))

        FavoriteManager.shared.addToFavorites(picture: redditPics1)
        FavoriteManager.shared.addToFavorites(picture: redditPics2)

        FavoriteManager.shared.clearAllFavorites()
        let favorites = FavoriteManager.shared.getFavorites()
        XCTAssertEqual(favorites?.count, 0, "Favorite not cleared")
    }
    
    func testisFavoritePositiveCase() {
        FavoriteManager.shared.clearAllFavorites()
        let redditPics1 = RedditPicture(imageInfo: PictutreInfo(imageId: "1234", thumbnail: "", author: "", title: "new title", created: 1234567, photoUrl: "", categories: nil))

        FavoriteManager.shared.addToFavorites(picture: redditPics1)

        let isFavorite = FavoriteManager.shared.isFavorite(imageInfo: redditPics1)
        XCTAssertTrue(isFavorite)
    }
    
    func testisFavoriteNegativeCase() {
        FavoriteManager.shared.clearAllFavorites()
        let redditPics1 = RedditPicture(imageInfo: PictutreInfo(imageId: "1234", thumbnail: "", author: "", title: "new title", created: 1234567, photoUrl: "", categories: nil))

        let isFavorite = FavoriteManager.shared.isFavorite(imageInfo: redditPics1)
        XCTAssertFalse(isFavorite)
    }
}
