//
//  SearchLocationViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/09.
//

import UIKit
import MapKit

protocol SearchLocationViewControllerDelegate: AnyObject{
    func searchLocationViewControllerDidSelected(title: String, subTitle: String, location: Location)
}

class SearchLocationViewController: UIViewController, UISearchResultsUpdating{
    weak var delegate: SearchLocationViewControllerDelegate?
    
    private var searchCompleter = MKLocalSearchCompleter()
    
    
    private let searchVC = UISearchController(searchResultsController: SearchLocationResultsViewController())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(tableView)
//        (searchVC.searchResultsController as? SearchLocationResultsViewController)?.delegate = self
        
        searchVC.searchBar.placeholder = "場所の検索 ..."
        navigationItem.title = "場所の検索"
        navigationItem.searchController = searchVC
        searchVC.searchResultsUpdater = self
        
        
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsOnly
        
        view.backgroundColor = .systemBackground


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        tableView.frame = CGRect(x: 0, y: 200, width: view.width, height: 300)
    }
    

}

extension SearchLocationViewController: SearchResultsViewControllerDelegate{
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectResultsUser user: User) {
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// when user hit the keyboard key
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchLocationResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }
        
        searchCompleter.queryFragment = query
        
//        DatabaseManager.shared.findUsers(with: query){ results in
//            resultsVC.update(with: results)
//        }
    }
    
}

extension SearchLocationViewController: MKLocalSearchCompleterDelegate {
    
    // 正常に検索結果が更新されたとき
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        print(completer.results)
        guard let resultsVC = searchVC
                .searchResultsController as? SearchLocationResultsViewController else {
            return
        }
        print(completer.results)
        resultsVC.delegate = self
        resultsVC.update(with: completer.results)
        
    }
    
    // 検索が失敗したとき
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // エラー処理
    }
}

extension SearchLocationViewController: SearchLocationResultsViewControllerDelegate{
    func searchResultsViewControllerDidSelected(title: String, subTitle: String, location: Location) {
        delegate?.searchLocationViewControllerDidSelected(title: title, subTitle: subTitle, location: location)
        dismiss(animated: true, completion: nil)
    }
    
    
}

