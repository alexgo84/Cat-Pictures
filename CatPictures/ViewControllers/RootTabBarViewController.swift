//
//  RootTabBarViewController.swift
//  CatPictures
//
//  Created by Alex Gordon on 28.11.17.
//  Copyright © 2017 Alex Gordon. All rights reserved.
//

import UIKit

final class RootTabBarViewController: UITabBarController, ImageCollectionViewControllerDelegate {

    let serviceBus = ServiceBus()
    
    let refreshControl = UIRefreshControl()
    
    // MARK: - View Controllers References
    
    var randomCatsCollectionVC: ImageCollectionViewController!
    var favoriteCatsCollectionVC: ImageCollectionViewController!
    
    // MARK: - <UITabBarController>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomCatsCollectionVC = viewControllers![0] as! ImageCollectionViewController
        favoriteCatsCollectionVC = viewControllers![1] as! ImageCollectionViewController
        
        randomCatsCollectionVC.favorites = false
        favoriteCatsCollectionVC.favorites = true
        
        randomCatsCollectionVC.delegate = self
        favoriteCatsCollectionVC.delegate = self
        
        randomCatsCollectionVC.itemsPerRow = 2
        favoriteCatsCollectionVC.itemsPerRow = 1
        
        fetchRandomPicturesAsync()
        fetchFavoritePictures()
        
        // Add pull to reload controls ONLY to the random pictures collection view.
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Reload")
        refreshControl.addTarget(self, action: #selector(fetchRandomPicturesAsync), for: .valueChanged)
        randomCatsCollectionVC.collectionView!.addSubview(refreshControl)
    }
}

private extension RootTabBarViewController {

    @objc
    func fetchRandomPicturesAsync() {
        APIClient().getRandomCatPictures { (pictures, error) in
            
            DispatchQueue.main.async { self.refreshControl.endRefreshing() }
            
            guard error == nil else {
                self.presentAlert(errorMessage: ErrorMessage.custom(error: error!))
                return
            }
            
            guard let pictures = pictures else {
                assertionFailure("Unknown error. Got no picture but received no error! Please investigate.")
                self.presentAlert(errorMessage: ErrorMessage.unknownError())
                return
            }
            
            if let randomCatsCollectionVC = self.randomCatsCollectionVC {
                randomCatsCollectionVC.load(catPictures: pictures)
            }
        }
    }
    
    func fetchFavoritePictures() {
        if let favoriteCatsCollectionVC = favoriteCatsCollectionVC {
            let favoriteCatPictures = serviceBus.favoritesStorage.getFavorites()
            favoriteCatsCollectionVC.load(catPictures: favoriteCatPictures)
        }
    }
}

// MARK: -  <ImageCollectionViewControllerDelegate>

extension RootTabBarViewController {
    
    func toggle(favorite: Bool, catPicture: CatPicture) {
        if favorite {
            removeFromFavorites(catPicture: catPicture)
        } else {
            addToFavorites(catPicture: catPicture)
        }
    }
    
    private func removeFromFavorites(catPicture: CatPicture) {
        serviceBus.favoritesStorage.remove(url: catPicture.url)
        favoriteCatsCollectionVC.remove(catPicture: catPicture)
    }
    
    private func addToFavorites(catPicture: CatPicture) {
        serviceBus.favoritesStorage.add(url: catPicture.url)
        favoriteCatsCollectionVC.add(catPicture: catPicture)
    }
}

// MARK: - Error handling

private extension RootTabBarViewController {
    func presentAlert(errorMessage: ErrorMessage) {
        errorMessage.show(on: self, canCancel: true, recoveryActionTitle: "Try Again") {
            self.fetchRandomPicturesAsync()
        }
    }
}
