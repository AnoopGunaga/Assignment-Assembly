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
    

    func addToFavorites(imageInfo: RedditPics) {
        if !isFavorite(imageInfo: imageInfo) {
            var favorites: [RedditPics] = getFavorites() ?? []
            favorites.append(imageInfo)
            writeToFile(favorites: favorites)
        }
    }
    
    func removeFromFavrite(imageInfo: RedditPics) {
        var favorites: [RedditPics] = getFavorites() ?? []
        
        if let index = favorites.firstIndex(
            where: { $0.imageInfo?.imageId ==  imageInfo.imageInfo?.imageId }) {
            favorites.remove(at: index)
        }
        writeToFile(favorites: favorites)
    }
    
    func clearAllFavorites() {
        let favorites: [RedditPics] = []
        writeToFile(favorites: favorites)
    }
    
    func isFavorite(imageInfo: RedditPics) -> Bool {
        let favorites: [RedditPics] = getFavorites() ?? []
        let filteredObjs = favorites.filter({
            $0.imageInfo?.imageId == imageInfo.imageInfo?.imageId
        })
        return !filteredObjs.isEmpty
    }
        
    func getFavorites() -> [RedditPics]? {
        guard let url = fileUrl else { return nil }
        let path = url.appendingPathComponent(favoritesFileName)

        do {
            let jsonData = try Data(contentsOf: path)
            let redditPicsInfo = try JSONDecoder().decode([RedditPics].self, from: jsonData)
            return redditPicsInfo
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
        
    private func writeToFile(favorites: [RedditPics]) {
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
