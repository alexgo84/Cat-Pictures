//
//  ImageCollectionViewCellConfigurator.swift
//  CatPictures
//
//  Created by Alex Gordon on 29.11.17.
//  Copyright © 2017 Alex Gordon. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

struct ImageCollectionViewCellConfigurator {
    let catPicture: CatPicture
    let favorite: Bool
    
    public func configure(cell: ImageCollectionViewCell) {
        let url = self.catPicture.url
        
        DispatchQueue.main.async {
            cell.imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: SDWebImageOptions.retryFailed) { (image, error, cacheType, imageURL) in
                if let error = error {
                    print("FAIL: downloading image: '\(error.localizedDescription)' for URL: \(url)")
                }
            }
        }
    }
}
