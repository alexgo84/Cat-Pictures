//
//  DataSource.swift
//  CatPictures
//
//  Created by Alex Gordon on 28.11.17.
//  Copyright © 2017 Alex Gordon. All rights reserved.
//

import Foundation
import UIKit

public protocol Identifiable {
    static func cellIdentifier() -> String
}

struct Section <T: Identifiable> where T: Equatable {
    public let title: String?
    public var cellData: [T]
    
    init(title: String?, cellData: [T]) {
        self.title = title
        self.cellData = cellData
    }
    
    public func sectionByAdding(item: T) -> Section<T> {
        let newCellData = cellData + [item]
        return Section<T>(title: title, cellData: newCellData)
    }
    
    public func sectionByRemoving(item: T) -> Section<T> {
        let newCellData = cellData.filter() { $0 != item }
        return Section<T>(title: title, cellData: newCellData)
    }
}


class DataSource<T: Identifiable>: NSObject, UICollectionViewDataSource where T: Equatable  {

    var favorite: Bool = false
    
    public var sections: [Section<T>] {
        didSet {
            if sections.count == 0 {
                fatalError("Cannot set less than one section")
            }
        }
    }
    
    override init() {
        self.sections = [Section<T>(title: nil, cellData: [])] // we should have at least one section
        super.init()
    }
    
    public func clearData() {
        sections = [Section<T>(title: nil, cellData: [])]
    }
    
    //MARK: - <UICollectionViewDataSource>
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cellData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let genericCell = collectionView.dequeueReusableCell(withReuseIdentifier: T.cellIdentifier(), for: indexPath)
        let cellData: T = sections[indexPath.section].cellData[indexPath.row]
        
        switch T.cellIdentifier() {
        case CatPicture.cellIdentifier():
            guard
                let catPicture = cellData as? CatPicture,
                let cell = genericCell as? ImageCollectionViewCell
            else {
                fatalError("Invalid data type '\(cellData)' or cell '\(genericCell)' provided for data source \(T.cellIdentifier())")
            }
            
            ImageCollectionViewCellConfigurator(catPicture: catPicture, favorite: favorite).configure(cell: cell)
            
        default:
            fatalError("Unknown identifier '\(T.cellIdentifier())'")
        }
        
        return genericCell
    }
    
    public func item(at indexPath: IndexPath) -> T {
        let section = sections[indexPath.section]
        let item = section.cellData[indexPath.row]
        return item
    }
    
    public func add(item: T, to collectionView: UICollectionView) {
        let indexPath = IndexPath(item: sections[0].cellData.count, section: 0)
        sections = [sections[0].sectionByAdding(item: item)]
        collectionView.insertItems(at: [indexPath])
    }
    
    public func remove(item: T, from collectionView: UICollectionView) {
        guard let itemIndex = sections[0].cellData.index(of: item) else {
            assertionFailure("Trying to remove an item but it cannot be found")
            return
        }
        
        sections = [sections[0].sectionByRemoving(item: item)]
        let indexPath = IndexPath(item: itemIndex, section: 0)
        collectionView.deleteItems(at: [indexPath])
    }
}

