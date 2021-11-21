//
//  CustomEditViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/10.
//

import UIKit

enum Section {
    case main
}

enum ListItem: Hashable {
    case header(HeaderItem)
    case symbol(SFSymbolItem)
}

struct HeaderItem: Hashable {
    let title: String
    let symbols: [SFSymbolItem]
}

struct HeaderItem2: Hashable {
    let title: String
    let symbols: [SFSymbolItem2]
}

struct SFSymbolItem: Hashable {
    let name: String
    let image: UIImage
    
    init(name: String) {
        self.name = name
        self.image = UIImage(systemName: name)!
    }
}

struct SFSymbolItem2: Hashable {
    let name: String
    let image: UIImage
    
    init(name: String) {
        self.name = name
        self.image = UIImage(systemName: name)!
    }
}

class CustomEditViewController: UIViewController {
    // MARK: - Types

    let modelObject1 = HeaderItem(title: "Devices", symbols: [
        SFSymbolItem(name: "iphone.homebutton"),
        SFSymbolItem(name: "pc"),
        SFSymbolItem(name: "headphones"),
    ])
    
    let modelObject2 = HeaderItem(title: "Weather", symbols: [
            SFSymbolItem(name: "sun.min"),
            SFSymbolItem(name: "sunset.fill"),
        ])
    
    let modelObject3 = HeaderItem2(title: "Nature", symbols: [
            SFSymbolItem2(name: "drop.fill"),
            SFSymbolItem2(name: "flame"),
            SFSymbolItem2(name: "bolt.circle.fill"),
            SFSymbolItem2(name: "tortoise.fill"),
        ])

    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<HeaderItem, SFSymbolItem>!
    var dataSource2: UICollectionViewDiffableDataSource<HeaderItem2, SFSymbolItem2>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Declarative Header & Footer"

        // MARK: Create list layout
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .supplementary
//        layoutConfig.footerMode = .supplementary
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)

        // MARK: Configure collection view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        view.addSubview(collectionView)

        // Make collection view take up the entire view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])

        // MARK: Cell registration
        let symbolCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SFSymbolItem> {
            (cell, indexPath, symbolItem) in
            
            // Configure cell content
            var configuration = cell.defaultContentConfiguration()
            configuration.image = symbolItem.image
            configuration.text = symbolItem.name
            cell.contentConfiguration = configuration
        }
        let symbolCellRegistration2 = UICollectionView.CellRegistration<UICollectionViewListCell, SFSymbolItem2> {
            (cell, indexPath, symbolItem) in
            
            // Configure cell content
            var configuration = cell.defaultContentConfiguration()
            configuration.image = symbolItem.image
            configuration.text = symbolItem.name
            cell.contentConfiguration = configuration
        }

        // MARK: Initialize data source
        dataSource = UICollectionViewDiffableDataSource<HeaderItem, SFSymbolItem>(collectionView: collectionView) {
            (collectionView, indexPath, symbolItem) -> UICollectionViewCell? in
            
            // Dequeue symbol cell
            let cell = collectionView.dequeueConfiguredReusableCell(using: symbolCellRegistration,
                                                                    for: indexPath,
                                                                    item: symbolItem)
            return cell
        }
        dataSource2 = UICollectionViewDiffableDataSource<HeaderItem2, SFSymbolItem2>(collectionView: collectionView) {
            (collectionView, indexPath, symbolItem) -> UICollectionViewCell? in
            
            // Dequeue symbol cell
            let cell = collectionView.dequeueConfiguredReusableCell(using: symbolCellRegistration2,
                                                                    for: indexPath,
                                                                    item: symbolItem)
            return cell
        }
//        
//        // MARK: Supplementary view registration
//        let headerRegistration = UICollectionView.SupplementaryRegistration
//        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {
//            [unowned self] (headerView, elementKind, indexPath) in
//            
//            // Obtain header item using index path
//            let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
//            
//            // Configure header view content based on headerItem
//            var configuration = headerView.defaultContentConfiguration()
//            configuration.text = headerItem.title
//            
//            // Customize header appearance to make it more eye-catching
//            configuration.textProperties.font = .boldSystemFont(ofSize: 16)
//            configuration.textProperties.color = .systemBlue
//            configuration.directionalLayoutMargins = .init(top: 20.0, leading: 0.0, bottom: 10.0, trailing: 0.0)
//            
//            // Apply the configuration to header view
//            headerView.contentConfiguration = configuration
//        }
//        
//        // MARK: Define supplementary view provider
//        dataSource.supplementaryViewProvider = { [unowned self]
//            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
//            
//            // Dequeue header view
//            return self.collectionView.dequeueConfiguredReusableSupplementary(
//                using: headerRegistration, for: indexPath)
//
//        }
        
        // MARK: Setup snapshot
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<HeaderItem, SFSymbolItem>()
        var dataSourceSnapshot2 = NSDiffableDataSourceSnapshot<HeaderItem2, SFSymbolItem2>()

        // Create collection view section based on number of HeaderItem in modelObjects
        dataSourceSnapshot.appendSections([modelObject1])
        dataSourceSnapshot.appendItems(modelObject1.symbols, toSection: modelObject1)
        dataSourceSnapshot.appendSections([modelObject2])
        dataSourceSnapshot.appendItems(modelObject2.symbols, toSection: modelObject2)
        dataSourceSnapshot2.appendSections([modelObject3])
        dataSourceSnapshot2.appendItems(modelObject3.symbols, toSection: modelObject3)


        dataSource.apply(dataSourceSnapshot, animatingDifferences: false)
        dataSource2.apply(dataSourceSnapshot2, animatingDifferences: false)

    }
}
