//
//  DetailPageViewModel.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop on 02/10/21.
//

import Foundation

class DetailPageViewModel {
    private var pictures: RedditPics
    var isFavorite: Bool {
        return FavoriteManager.shared.isFavorite(imageInfo: pictures)
    }
    
    init(image: RedditPics,
         isFavorite: Bool) {
        pictures = image
    }
    
    var title: String {
        return pictures.imageInfo?.title ?? ""
    }
    
    var author: String {
        return pictures.imageInfo?.author ?? ""
    }
    
    var timeStamp: String {
        return pictures.imageInfo?.timestamp ?? ""
    }
    
    var contentCategory: String {
        return pictures.imageInfo?.contentCategory ?? ""
    }
    
    var photoUrl: String {
        return pictures.imageInfo?.photoUrl ?? ""
    }
    
    func addToFavorite() {
        FavoriteManager.shared.addToFavorites(imageInfo: pictures)
    }
    
    func removeFromFavorites() {
        FavoriteManager.shared.removeFromFavrite(imageInfo: pictures)
    }
}
