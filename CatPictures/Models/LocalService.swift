//
//  LocalService.swift
//  CatPictures
//
//  Created by Alex Gordon on 28.11.17.
//  Copyright © 2017 Alex Gordon. All rights reserved.
//

import Foundation

final class LocalService {
    func load<A>(resource: Resource<A>, completion: @escaping ([A]?, Error?) -> ()) {
        do {
            let data = try Data(contentsOf: resource.url)
            let parsedData = try resource.parseFunction(data)
            completion(parsedData, nil)
        } catch {
            completion(nil, error)
        }
    }
}
