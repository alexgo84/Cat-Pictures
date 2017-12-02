//
//  RootTabBarViewController.swift
//  CatPictures
//
//  Created by Alex Gordon on 28.11.17.
//  Copyright © 2017 Alex Gordon. All rights reserved.
//

import UIKit

final class RootTabBarViewController: UITabBarController {

    private let serviceBus = ServiceBus()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - View Controllers References & config
    
    private lazy var randomCatsCollectionVC: ImageCollectionViewController = {
        guard let imageCellViewController = viewControllers?[0] as? ImageCollectionViewController  else {
            fatalError("Expected to get ImageCollectionViewController, instead got \(viewControllers?[0].debugDescription ?? "nil")")
        }
        
        imageCellViewController.favorites = false
        imageCellViewController.delegate = self
        imageCellViewController.itemsPerRow = 2
        return imageCellViewController
    }()
    
    private lazy var favoriteCatsCollectionVC: ImageCollectionViewController = {
        guard let imageCellViewController = viewControllers?[1] as? ImageCollectionViewController  else {
            fatalError("Expected to get ImageCollectionViewController, instead got \(viewControllers?[1].debugDescription ?? "nil")")
        }
        
        imageCellViewController.favorites = true
        imageCellViewController.delegate = self
        imageCellViewController.itemsPerRow = 1
        return imageCellViewController
    }()
    
    // MARK: - <UIViewController>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControlOnRandomCatsCollection()
        fetchRandomPicturesAsync()
        fetchFavoritePictures()
    }
}

private extension RootTabBarViewController {

    func configureRefreshControlOnRandomCatsCollection() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Reload")
        refreshControl.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        refreshControl.addTarget(self, action: #selector(reloadPictures), for: .valueChanged)
        randomCatsCollectionVC.collectionView?.addSubview(refreshControl)
        randomCatsCollectionVC.collectionView?.alwaysBounceVertical = true
    }
    
    @objc
    func reloadPictures() {
        fetchRandomPicturesAsync()
    }
    
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
            
            self.randomCatsCollectionVC.load(catPictures: pictures)
        }
    }
    
    func fetchFavoritePictures() {
        let favoriteCatPictures = serviceBus.favoritesStorage.getFavorites()
        favoriteCatsCollectionVC.load(catPictures: favoriteCatPictures)
    }
}

// MARK: -  <ImageCollectionViewControllerDelegate>

extension RootTabBarViewController: ImageCollectionViewControllerDelegate {
    
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
