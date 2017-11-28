//
//  ServiceBus.swift
//  CatPictures
//
//  Created by Alex Gordon on 28.11.17.
//  Copyright © 2017 Alex Gordon. All rights reserved.
//

import Foundation

struct ServiceBus {
    let apiClient: APIClient
    let favoritesStorage: LocalFavoritesStorage
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.apiClient = APIClient()
        self.favoritesStorage = LocalFavoritesStorage(userDefaults: userDefaults)
    }
}
