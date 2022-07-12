
import UIKit
import MapKit

protocol DirectSearchLocationViewControllerDelegate: AnyObject{
    func searchLocationViewControllerDidEnterDirectLocation(text: String?, location: Location)
}

class DirectSearchLocationViewController: UIViewController{
    
    weak var delegate: DirectSearchLocationViewControllerDelegate?
    
    private var setLocationFromMap: Location?
    
    
    
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
        textView.textColor = .label
        textView.placeholder = "名称を自分で手入力する"
        
        return textView
    }()
    
    private let pinButton: UIButton = {
        let button = UIButton()
        button.setTitle("マップ上にピン付けする", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 3.0
        return button
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "場所の検索"
        
        
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(field)
        field.delegate = self
        
        
        view.addSubview(pinButton)
        
        pinButton.addTarget(self, action: #selector(didTapPinButton), for: .touchUpInside)

    }
    
    @objc private func didTapPinButton(){
        let vc = MapToSetPinViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        tableView.frame = CGRect(x: 0, y: 200, width: view.width, height: 300)
        
        field.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 50, width: view.width-40, height: 50)
        
        pinButton.frame = CGRect(x: 20, y: field.bottom+50, width: view.width-40, height: 40)
    }
}

extension DirectSearchLocationViewController: MapToSetPinViewControllerDelegate{
    func mapToSetPinViewControllerDidDecide(location: CLLocationCoordinate2D) {
        setLocationFromMap = Location(lat: location.latitude, lng: location.longitude)
    }
}




extension DirectSearchLocationViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        field.resignFirstResponder()
        
        guard let setLocationFromMap = setLocationFromMap else{
            
            let alert = UIAlertController(title: "場所エラー", message: "場所がマップ上から選択されていません。場所は検索するか、手入力した場合は場所をマップ上から選択してください。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return true
            
        }
        delegate?.searchLocationViewControllerDidEnterDirectLocation(text: textField.text, location: setLocationFromMap)
        dismiss(animated: true, completion: nil)
        //navigationController?.popViewController(animated: true)
        return true
    }
}

