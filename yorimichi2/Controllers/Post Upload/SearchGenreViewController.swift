//
//  SearchGenreViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/10.
//

import UIKit
import SafariServices

struct GenreHeaderItem: Hashable {
    let title: String
    let symbols: [GenreInfo]
}

//let tmpImage = UIImage(named: code)!
//if let resizedImage = tmpImage.sd_resizedImage(with: CGSize(width: 32, height: 32), scaleMode: .aspectFill){
//    self.image = resizedImage
//
//} else{
//    self.image = UIImage()
//}

//protocol UICollectionViewListCellGenreDelegate: AnyObject{
//    func uICollectionViewListCellGenreDelegateDidSelected(code: String)
//}
//
//class UICollectionViewListCellGenre: UICollectionViewListCell{
//    weak var delegate: UICollectionViewListCellGenreDelegate?
//
//}


protocol SearchGenreViewControllerDelegate: AnyObject{
    func searchGenreViewControllerDidSelected(code: String)
    
}


class SearchGenreViewController: UIViewController {
    
    weak var delegate: SearchGenreViewControllerDelegate?
    
    
    private var modelObjects: [GenreHeaderItem] = [GenreHeaderItem]()
    
    private var isIncludeAll: Bool = false
    

    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<GenreHeaderItem, GenreInfo>!
    
    public func configure(isIncludeAll: Bool){
        self.isIncludeAll = isIncludeAll
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allSymbols = otherGenreList.map{
            return GenreInfo(code: $0, type: .other)
        }
        
        let foodSymbols = foodGenreList.map{
            return GenreInfo(code: $0, type: .food)
        }
        
        let spotSymbols = spotGenreList.map{
            return GenreInfo(code: $0, type: .spot)
        }
        
        let shopSymbols = shopGenreList.map{
            return GenreInfo(code: $0, type: .shop)
        }
        
        if(isIncludeAll){
            modelObjects = [
                GenreHeaderItem(title: "なんでも", symbols: allSymbols),
                GenreHeaderItem(title: "Food",symbols: foodSymbols),
                GenreHeaderItem(title: "Spot", symbols: spotSymbols),
                GenreHeaderItem(title: "Shop", symbols: shopSymbols)
            ]
        }else{
            modelObjects = [
                GenreHeaderItem(title: "Food",symbols: foodSymbols),
                GenreHeaderItem(title: "Spot", symbols: spotSymbols),
                GenreHeaderItem(title: "Shop", symbols: shopSymbols)
            ]
            
        }

        
        self.title = "ヨリミチジャンル"

        // MARK: Create list layout
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .supplementary
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)

        // MARK: Configure collection view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        collectionView.delegate = self
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
        let symbolCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, GenreInfo> {
            (cell, indexPath, symbolItem) in
            
            // Configure cell content
            var configuration = cell.defaultContentConfiguration()
            let tmpImage = UIImage(named: symbolItem.code) ?? UIImage()
            if let resizedImage = tmpImage.sd_resizedImage(with: CGSize(width: 32, height: 32), scaleMode: .aspectFill){
                configuration.image = resizedImage
            
            } else{
                configuration.image = UIImage()
            }
//            configuration.image = symbolItem.image
            configuration.text = symbolItem.getDisplayString
            cell.contentConfiguration = configuration
        }

        // MARK: Initialize data source
        dataSource = UICollectionViewDiffableDataSource<GenreHeaderItem, GenreInfo>(collectionView: collectionView) {
            (collectionView, indexPath, symbolItem) -> UICollectionViewCell? in
            
            // Dequeue symbol cell
            let cell = collectionView.dequeueConfiguredReusableCell(using: symbolCellRegistration,
                                                                    for: indexPath,
                                                                    item: symbolItem)
            cell.accessories = [.disclosureIndicator()]
            
            return cell
        }
        
        // MARK: Supplementary view registration
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {
            [unowned self] (headerView, elementKind, indexPath) in
            
            // Obtain header item using index path
            let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            // Configure header view content based on headerItem
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = headerItem.title
            
            // Customize header appearance to make it more eye-catching
            configuration.textProperties.font = .boldSystemFont(ofSize: 16)
            configuration.textProperties.color = .systemBlue
            configuration.directionalLayoutMargins = .init(top: 20.0, leading: 0.0, bottom: 10.0, trailing: 0.0)
            
            // Apply the configuration to header view
            headerView.contentConfiguration = configuration
        }
        

        
        // MARK: Define supplementary view provider
        dataSource.supplementaryViewProvider = { [unowned self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            
            // Dequeue header view
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: indexPath)
            

        }
        
        // MARK: Setup snapshot
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<GenreHeaderItem, GenreInfo>()

        // Create collection view section based on number of HeaderItem in modelObjects
        dataSourceSnapshot.appendSections(modelObjects)

        // Loop through each header item to append symbols to their respective section
        for headerItem in modelObjects {
            dataSourceSnapshot.appendItems(headerItem.symbols, toSection: headerItem)
        }

        dataSource.apply(dataSourceSnapshot, animatingDifferences: false)

    }
}

extension SearchGenreViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        // Retrieve the item identifier using index path.
        // The item identifier we get will be the selected data item
        // NOTE: Do not use dataItems[indexPath.item] (Apple recommends never using index paths as identifiers, as they’re not guaranteed to be stable as list items get inserted and removed.)
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        dismiss(animated: true, completion: nil)

        delegate?.searchGenreViewControllerDidSelected(code: selectedItem.code)
    }
}
