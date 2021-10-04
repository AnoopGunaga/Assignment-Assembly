//
//  DetailPageViewModel.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop on 02/10/21.
//

import Foundation

class DetailPageViewModel {
    private var pictures: RedditPicture
    var isFavorite: Bool {
        return FavoriteManager.shared.isFavorite(imageInfo: pictures)
    }
    
    init(image: RedditPicture) {
        pictures = image
    }
    
    var title: String {
        return pictures.pictureInfo?.title ?? ""
    }
    
    var author: String {
        return pictures.pictureInfo?.postedBy ?? ""
    }
    
    var timeStamp: String {
        return pictures.pictureInfo?.timestamp ?? ""
    }
    
    var contentCategory: String {
        return pictures.pictureInfo?.contentCategory ?? ""
    }
    
    var photoUrl: String {
        return pictures.pictureInfo?.photoUrl ?? ""
    }
    
    func addToFavorite() {
        FavoriteManager.shared.addToFavorites(picture: pictures)
    }
    
    func removeFromFavorites() {
        FavoriteManager.shared.removeFromFavrite(picture: pictures)
    }
}
