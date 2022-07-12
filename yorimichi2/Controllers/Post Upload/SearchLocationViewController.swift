import UIKit
import MapKit

protocol SearchLocationViewControllerDelegate: AnyObject{
    func searchLocationViewControllerDidSelected(title: String, subTitle: String, location: Location)
//    func searchLocationViewControllerDidEnterDirectLocation(text: String?, location: Location)
}

class SearchLocationViewController: UIViewController, UISearchResultsUpdating{
    weak var delegate: SearchLocationViewControllerDelegate?
    
    private var searchCompleter = MKLocalSearchCompleter()
    
    private var setLocationFromMap: Location?
    
    
    private let searchVC = UISearchController(searchResultsController: SearchLocationResultsViewController())
    
//    private let separateHeader: UILabel = {
//        let label = UILabel()
//        label.attributedText = NSAttributedString(string: "Text", attributes:
//            [.underlineStyle: NSUnderlineStyle.single.rawValue])
//        label.text = "検索せずに手入力する時は以下を入力してください"
//        label.font = .systemFont(ofSize: 16)
//        label.textColor = .systemGray
//
//        return label
//    }()
    
//    public let field: UITextField = {
//        let textView = TextField()
//
//        textView.layer.masksToBounds = true
//        textView.font = .systemFont(ofSize: 14)
//        textView.returnKeyType = .done
//        textView.autocorrectionType = .no
//        textView.autocapitalizationType = .none
//        textView.borderStyle = .none
//        textView.keyboardType = .default
//        textView.backgroundColor = .systemBackground
//        textView.textColor = .label
//        textView.placeholder = "名称を自分で手入力する"
//
//        return textView
//    }()
//
//    private let pinButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("マップ上にピン付けする", for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 14)
//        button.setTitleColor(.label, for: .normal)
//        button.layer.borderColor = UIColor.gray.cgColor
//        button.layer.borderWidth = 3.0
//        return button
//
//    }()
    
    
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
        
//        view.addSubview(field)
//        field.delegate = self
        
//        view.addSubview(separateHeader)
        
//        view.addSubview(pinButton)
        
//        pinButton.addTarget(self, action: #selector(didTapPinButton), for: .touchUpInside)
//
    }
    
//    @objc private func didTapPinButton(){
//        let vc = MapToSetPinViewController()
//        vc.delegate = self
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        tableView.frame = CGRect(x: 0, y: 200, width: view.width, height: 300)
        
//        separateHeader.sizeToFit()
//        separateHeader.frame = CGRect(x: 20, y: view.safeAreaInsets.bottom+200, width: separateHeader.width, height: separateHeader.height)
//        field.frame = CGRect(x: 20, y: separateHeader.bottom + 50, width: view.width-40, height: 50)
//
//        pinButton.frame = CGRect(x: 20, y: field.bottom+50, width: view.width-40, height: 40)
    }
}

extension SearchLocationViewController: MapToSetPinViewControllerDelegate{
    func mapToSetPinViewControllerDidDecide(location: CLLocationCoordinate2D) {
        setLocationFromMap = Location(lat: location.latitude, lng: location.longitude)
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

//extension SearchLocationViewController: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        return true
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
//        field.resignFirstResponder()
//
//        guard let setLocationFromMap = setLocationFromMap else{
//
//            let alert = UIAlertController(title: "場所エラー", message: "場所がマップ上から選択されていません。場所は検索するか、手入力した場合は場所をマップ上から選択してください。", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            self.present(alert, animated: true)
//            return true
//
//        }
//        delegate?.searchLocationViewControllerDidEnterDirectLocation(text: textField.text, location: setLocationFromMap)
//        dismiss(animated: true, completion: nil)
//        //navigationController?.popViewController(animated: true)
//        return true
//    }
//}
//
