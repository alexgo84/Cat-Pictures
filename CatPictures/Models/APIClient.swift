//
//  APIClient.swift
//  CatPictures
//
//  Created by Alex Gordon on 28.11.17.
//  Copyright © 2017 Alex Gordon. All rights reserved.
//

import Foundation

class APIClient {
    
    private let webService: WebService = WebService()
    private let localService: LocalService = LocalService()
    
    func getRandomCatPictures(quantity: Int = 100, completion: @escaping ([CatPicture]?, Error?) -> ()) {
        webService.load(resource: CatPicture.webResource(quantity: quantity)) { catPictures, error in
            completion(catPictures, error)
        }
    }
}

