//
//  ListSourceViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/31.
//

import UIKit

protocol ListSourceViewControllerDelegate: AnyObject{
    //func listSourceViewControllerDidTapClose()
    func listSourceViewControllerDidSelected()
}

class ListSourceViewController: UIViewController {
    
    weak var delegate: ListSourceViewControllerDelegate?
    
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let type: ListType
    private var sections: [SourceSection] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
        
        
    }()
    
    enum ListType{
        case sources(sources: [String])
        
        var title: String {
            switch self{
            case .sources:
                return "Information Sources"
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
        
        if let currentSource = UserDefaults.standard.string(forKey: "source"){
            label.text = "現在選択中の情報源: \(currentSource)"
  
        } else{
            label.text = "ヨリミチを検索する情報源を選択してください。"
            
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
        
        var options: [SourceOption] = []
        var optionYorimichiDB: SourceOption = SourceOption(
            title: "Yorimichi Database",
            image: UIImage()
        )
        var optionHP: SourceOption = SourceOption(
            title: "Hot Pepper",
            image: UIImage()
        )
        var optionGoogle: SourceOption = SourceOption(
            title: "Google",
            image: UIImage()
        )
        
        options.append(optionYorimichiDB)
        options.append(optionHP)
        options.append(optionGoogle)
        
        
        sections.append(
            SourceSection(title: "デフォルトオプション", options: options)
        
        )

    }
    
    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }

}


extension ListSourceViewController: UITableViewDelegate, UITableViewDataSource{
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
        UserDefaults.standard.setValue(sourceCodeToString(x: sourceList[indexPath.row]), forKey: "source")
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: .didSourceChanged, object: nil)
        
        delegate?.listSourceViewControllerDidSelected()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
