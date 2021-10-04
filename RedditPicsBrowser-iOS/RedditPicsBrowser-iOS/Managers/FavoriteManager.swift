//
//  FavoriteManager.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop on 02/10/21.
//

import Foundation

class FavoriteManager {
    private let favoritesDirectoryPath = "RedditPicsBrowser/Favorites"
    private let favoritesFileName = "allfavorites"
    static var shared = FavoriteManager()
    private init() {}
    

    func addToFavorites(picture: RedditPicture) {
        if !isFavorite(imageInfo: picture) {
            var favorites: [RedditPicture] = getFavorites() ?? []
            favorites.append(picture)
            writeToFile(favorites: favorites)
        }
    }
    
    func removeFromFavrite(picture: RedditPicture) {
        var favorites: [RedditPicture] = getFavorites() ?? []
        
        if let index = favorites.firstIndex(
            where: { $0.pictureInfo?.imageId ==  picture.pictureInfo?.imageId }) {
            favorites.remove(at: index)
        }
        writeToFile(favorites: favorites)
    }
    
    func clearAllFavorites() {
        let favorites: [RedditPicture] = []
        writeToFile(favorites: favorites)
    }
    
    func isFavorite(imageInfo: RedditPicture) -> Bool {
        let favorites: [RedditPicture] = getFavorites() ?? []
        let filteredObjs = favorites.filter({
            $0.pictureInfo?.imageId == imageInfo.pictureInfo?.imageId
        })
        return !filteredObjs.isEmpty
    }
        
    func getFavorites() -> [RedditPicture]? {
        guard let url = fileUrl else { return nil }
        let path = url.appendingPathComponent(favoritesFileName)

        do {
            let jsonData = try Data(contentsOf: path)
            let redditPicsInfo = try JSONDecoder().decode([RedditPicture].self, from: jsonData)
            return redditPicsInfo
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
        
    private func writeToFile(favorites: [RedditPicture]) {
        guard let url = fileUrl else { return }
        let path = url.appendingPathComponent(favoritesFileName)
        
        do {
            let favData = try JSONEncoder().encode(favorites)
            try favData.write(to: path)
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    private var fileUrl: URL? {
        let fileManager = FileManager.default
        do {
            let fileURL = try fileManager.url(
                for: .documentDirectory,
                   in: .userDomainMask,
                   appropriateFor: nil,
                   create: true).appendingPathComponent(favoritesDirectoryPath)
            
            if !fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.createDirectory(
                    at: fileURL,
                    withIntermediateDirectories: true,
                    attributes: nil)
            }
            return fileURL
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        return nil
    }

}
