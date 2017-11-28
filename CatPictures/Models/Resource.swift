//
//  Resource.swift
//  CatPictures
//
//  Created by Alex Gordon on 28.11.17.
//  Copyright © 2017 Alex Gordon. All rights reserved.
//

import Foundation

public typealias JSONDict = [String: AnyObject]
private let apiKey = "MjQ4NDk4"

enum JSONURL {
    
    case catPicture
    
    func urlToLocalStub() -> URL {
        switch self {
        case .catPicture:
            let localStubName = "cat_picture_stub"
            guard let url = Bundle.main.url(forResource: localStubName, withExtension: "json") else {
                fatalError("FAIL: couldn't find '\(localStubName)' JSON data on main bundle")
            }
            return url
        }
    }
    
    func urlToRemote(quantity: Int) -> URL {
        switch self {
        case .catPicture:
            return URL(string: "https://thecatapi.com/api/images/get?format=html&type=jpg&results_per_page=\(quantity)&apiKey=\(apiKey)")!
        }
    }
}

struct Resource<T> {
    let url: URL
    let parseFunction: (Data) throws -> [T]?
}

