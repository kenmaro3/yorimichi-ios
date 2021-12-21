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
    func searchLocationViewControllerDidEnterDirectLocation(text: String?)
}

class SearchLocationViewController: UIViewController, UISearchResultsUpdating{
    weak var delegate: SearchLocationViewControllerDelegate?
    
    private var searchCompleter = MKLocalSearchCompleter()
    
    
    private let searchVC = UISearchController(searchResultsController: SearchLocationResultsViewController())
    
    public let field: UITextField = {
        let textView = TextField()

        textView.layer.masksToBounds = true
        textView.font = .systemFont(ofSize: 14)
        textView.returnKeyType = .done
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.borderStyle = .none
        textView.keyboardType = .default
        textView.backgroundColor = .systemBackground
        textView.placeholder = "名称を自分で手入力する。(投稿には現在地が紐つきます。)"
        
        return textView
    }()
    
    
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
        
        view.addSubview(field)
        field.delegate = self


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        tableView.frame = CGRect(x: 0, y: 200, width: view.width, height: 300)
        field.frame = CGRect(x: 20, y: view.safeAreaInsets.bottom+100, width: view.width-40, height: 50)
        
    }
    

}

extension SearchLocationViewController: SearchUserResultsViewControllerDelegate{
    func searchUserResultsViewController(_ vc: SearchUserResultsViewController, didSelectResultsUser user: User) {
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

extension SearchLocationViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        field.resignFirstResponder()
        delegate?.searchLocationViewControllerDidEnterDirectLocation(text: textField.text)
        dismiss(animated: true, completion: nil)
        return true
    }
}

