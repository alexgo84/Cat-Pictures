//
//  ImageCollectionViewController.swift
//  CatPictures
//
//  Created by Alex Gordon on 29.11.17.
//  Copyright © 2017 Alex Gordon. All rights reserved.
//

import Foundation
import UIKit

protocol ImageCollectionViewControllerDelegate: class {
    func toggle(favorite: Bool, catPicture: CatPicture)
}

class ImageCollectionViewController: UICollectionViewController {
    
    private let dataSource = DataSource<CatPicture>()
    
    public var favorites: Bool = false
    weak public var delegate: ImageCollectionViewControllerDelegate?
    
    fileprivate let paddingSize: CGFloat = 20.0
    public var itemsPerRow: CGFloat = 2
    
    // MARK: - <UIViewController>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil),
                                 forCellWithReuseIdentifier: CatPicture.cellIdentifier())
        collectionView?.dataSource = dataSource
        collectionView?.delegate = self
        configureLayout()

        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.proccessDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.numberOfTouchesRequired = 1
        collectionView?.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    // MARK: - Public methods
    
    public func load(catPictures: [CatPicture]) {
        dataSource.sections = [Section<CatPicture>(title: nil, cellData: catPictures)]
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadSections(IndexSet(integer: 0))
        }
    }
    
    public func add(catPicture: CatPicture) {
        if let collectionView = collectionView {
            dataSource.add(item: catPicture, to: collectionView)
        }
    }
    
    public func remove(catPicture: CatPicture) {
        if let collectionView = collectionView {
            dataSource.remove(item: catPicture, from: collectionView)
        }
    }
}

// MARK: - Private helpers

private extension ImageCollectionViewController {
    @objc
    private func proccessDoubleTap(sender: UITapGestureRecognizer) {
        
        let point = sender.location(in: collectionView)
        
        guard
            sender.state == .ended,
            let collectionView = collectionView,
            let indexPath = collectionView.indexPathForItem(at: point),
            let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell,
            cell.imageView.image != #imageLiteral(resourceName: "placeholder") // make sure the image is not the placeholder (image didn't load)
            else {
                return
        }
        
        let catPicture = dataSource.item(at: indexPath)
        delegate?.toggle(favorite: favorites, catPicture: catPicture)
        HeartAnimation.animate(favorite: favorites, on: cell.imageView)
    }
}

// MARK: - <UICollectionViewDelegateFlowLayout>

extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func configureLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .vertical
        collectionView?.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableLength = collectionView.bounds.width
        let totalPaddingSpace = paddingSize * (itemsPerRow + 1)
        let totalAvailableWidth = availableLength - totalPaddingSpace
        let widthPerItem = totalAvailableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: paddingSize, left: paddingSize, bottom: paddingSize, right: paddingSize)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return paddingSize
    }
}
