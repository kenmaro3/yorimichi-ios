//
//  ListMethodsViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/30.
//

import UIKit

protocol ListMethodsViewControllerDelegate: AnyObject{
    func listMethodsViewControllerDidSelected()
}


class ListMethodsViewController: UIViewController {
    
    weak var delegate: ListMethodsViewControllerDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let type: ListType
    private var sections: [MethodsSection] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
        
        
    }()
    
    enum ListType{
        case methods(methods: [String])
        
        var title: String {
            switch self{
            case .methods:
                return "Transportation Methods"
            }
        }
    }
    
    init(type: ListType){
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(label)
        view.addSubview(tableView)
        
        if let currentMethod = UserDefaults.standard.string(forKey: "methods"){
            label.text = "現在選択中の移動手段: \(currentMethod)"
  
        } else{
            label.text = "移動手段を選択してください。"
            
        }
        
        title = type.title
        tableView.delegate = self
        tableView.dataSource = self
        
        configureModels()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: (view.width-label.width)/2, y: view.safeAreaInsets.bottom+40, width: label.width, height: label.height)
        //label.center = view.center
        tableView.frame = CGRect(x: 0, y: label.bottom + 20, width: view.width, height: view.height)
    }

    func resizeImage(image: UIImage) -> UIImage{
        guard let resizedImage = image.sd_resizedImage(with: CGSize(width: 128, height: 128), scaleMode: .aspectFill) else{
            return UIImage()
        }
        
        return resizedImage
    }
    
    
    private func configureModels(){
        
        var options: [MethodsOption] = []
        var optionWalk: MethodsOption = MethodsOption(
            title: "Walk",
            image: UIImage(systemName: "figure.walk")!
        )
        var optionDrive: MethodsOption = MethodsOption(
            title: "Drive",
            image: UIImage(systemName: "car")!
        )
        
        options.append(optionWalk)
        options.append(optionDrive)
        
        
        sections.append(
            MethodsSection(title: "デフォルトオプション", options: options)
        
        )

    }
    
    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }

}


extension ListMethodsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.imageView?.image = model.image
        cell.imageView?.layer.cornerRadius

        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:  true)
        UserDefaults.standard.setValue(methodCodeToString(x: methodList[indexPath.row]), forKey: "methods")
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: .didMethodsChanged, object: nil)
        delegate?.listMethodsViewControllerDidSelected()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
