//
//  HeartAnimation.swift
//  CatPictures
//
//  Created by Alex Gordon on 01.12.17.
//  Copyright © 2017 Alex Gordon. All rights reserved.
//

import Foundation
import UIKit


struct HeartAnimation {
    
    public static func animate(favorite: Bool, on view: UIView) {
        if favorite {
            animate(image: #imageLiteral(resourceName: "broken-heart-icon"), on: view)
        } else {
            animate(image: #imageLiteral(resourceName: "heart-icon"), on: view)
        }
    }
    
    private static func animate(image: UIImage, on view: UIView) {
        let center = view.center
        let heartImageView = UIImageView(image: image)
        heartImageView.center = center
        
        view.addSubview(heartImageView)
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {
            heartImageView.alpha = 0.0
        }, completion: { _ in
            heartImageView.removeFromSuperview()
        })
    }
}
