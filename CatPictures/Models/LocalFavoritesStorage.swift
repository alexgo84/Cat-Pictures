//
//  LocalFavoritesStorage.swift
//  CatPictures
//
//  Created by Alex Gordon on 28.11.17.
//  Copyright © 2017 Alex Gordon. All rights reserved.
//

import Foundation

struct LocalFavoritesStorage {
    
    private let kFavorites = "kFavoriteCatPicturesIDs"
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    public func add(url: URL) {
        let urlString = url.absoluteString
        
        guard var favorites = userDefaults.array(forKey: kFavorites) as? [String] else {
            userDefaults.set([urlString], forKey: kFavorites)
            return
        }
        
        let alreadyFavorite = favorites.contains { existingURLString in
            return existingURLString == urlString
        }
        
        guard alreadyFavorite == false else {
            return
        }
        
        favorites.append(urlString)
        userDefaults.setValue(favorites, forKey: kFavorites)
    }
    
    public func remove(url: URL) {
        let urlString = url.absoluteString

        guard var favorites = userDefaults.array(forKey: kFavorites) as? [String] else {
            return
        }
        
        guard let index = favorites.index(where: {$0 == urlString}) else {
            return
        }
        
        favorites.remove(at: index)
        userDefaults.setValue(favorites, forKey: kFavorites)
    }
    
    public func getFavorites() -> [CatPicture] {
        
        guard let favorites = userDefaults.array(forKey: kFavorites) as? [String] else {
            return []
        }

        let favoriteURLs = favorites.flatMap { URL(string: $0) }
        return favoriteURLs.flatMap { CatPicture(url: $0) }
    }
    
    public func isFavorite(url: URL) -> Bool {
        let urlString = url.absoluteString

        guard let favorites = userDefaults.array(forKey: kFavorites) as? [String] else {
            return false
        }
        
        if let _ = favorites.index(where: {$0 == urlString}) {
            return true
        } else {
            return false
        }
    }
}

