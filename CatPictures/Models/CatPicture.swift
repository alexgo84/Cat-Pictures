//
//  CatPicture.swift
//  CatPictures
//
//  Created by Alex Gordon on 28.11.17.
//  Copyright © 2017 Alex Gordon. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup

struct CatPicture: Identifiable, Equatable {
    
    let url: URL
    
    static func cellIdentifier() -> String {
        return "CatPictureCell"
    }
    
    static func ==(lhs: CatPicture, rhs: CatPicture) -> Bool {
        return lhs.url == rhs.url
    }
}

extension CatPicture {
    static func webResource(quantity: Int) -> Resource<CatPicture> {
        return Resource<CatPicture>(url: JSONURL.catPicture.urlToRemote(quantity: quantity)) { data in
            
            guard let htmlString = String(data: data, encoding: .utf8) else {
                print("FAIL: Data doesn't contain valid string")
                return nil
            }
            
            let elements: Elements!
            do {
                let document = try SwiftSoup.parse(htmlString)
                elements = try document.select("img")
            } catch {
                print("FAIL: parsing HTML response with error: \(error.localizedDescription)")
                return nil
            }

            var catPictures: [CatPicture] = []
            for element: Element in elements {
                do {
                    let src = try element.attr("src")
                    if let url = URL(string: src) {
                        catPictures.append(CatPicture(url: url))
                    }
                } catch {
                    print("FAIL: skipping cat picture because getting 'src' from Element failed with error: \(error.localizedDescription)")
                    continue
                }
            }
            
            return catPictures
        }
    }
}
