//
//  BaseModel.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop on 01/10/21.
//

import Foundation
import RxSwift

class RedditPicsModel: Codable {
    let payload: Payload?
 
    private enum CodingKeys: String, CodingKey {
        case payload = "data"
    }
}

class Payload: Codable {
    let pictures: [RedditPicture]?
    
    private enum CodingKeys: String, CodingKey {
        case pictures = "children"
    }
}

class RedditPicture: Codable {
    let pictureInfo: PictutreInfo?
    
    private enum CodingKeys: String, CodingKey {
        case pictureInfo = "data"
    }
    
    init(imageInfo: PictutreInfo? = nil) {
        self.pictureInfo = imageInfo
    }
}

class PictutreInfo: Codable {
    let imageId: String?
    let thumbnail: String?
    let author: String?
    let title: String?
    let created: TimeInterval?
    let photoUrl: String?
    let categories: [String]?
    
    init (
        imageId: String? = nil,
        thumbnail: String? = nil,
        author: String? = nil,
        title: String? = nil,
        created: TimeInterval? = nil,
        photoUrl: String? = nil,
        categories: [String]? = nil) {
            
            self.imageId = imageId
            self.thumbnail = thumbnail
            self.author = author
            self.title = title
            self.created = created
            self.categories = categories
            self.photoUrl = photoUrl
        }
    
    var timestamp: String {
        let publishedDate = Date(timeIntervalSince1970: created ?? 0.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.applicationDateFormat
        let string = dateFormatter.string(from: publishedDate)
        return string
    }
    
    var contentCategory: String {
        if let categories = categories,
           !categories.isEmpty {
            return categories[0]
        }
        return ""
    }
    
    var postedBy: String {
        return "Posted by: " + (author ?? "")
    }
    
    private enum CodingKeys: String, CodingKey {
        case imageId = "id"
        case thumbnail = "thumbnail"
        case author = "author"
        case title = "title"
        case created = "created"
        case photoUrl = "url_overridden_by_dest"
        case categories = "content_categories"
    }
}
