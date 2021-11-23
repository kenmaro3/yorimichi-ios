//
//  MapSettingsViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/08.
//

import UIKit

class MapSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var sourceTitle = ""
    private var genreTitle = ""
    private var methodTitle = ""
    
    private var methodsObserver: NSObjectProtocol?
    private var genreObserver: NSObjectProtocol?
    private var sourceObserver: NSObjectProtocol?

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "マップ検索設定"
        configureModels()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, target: self, action: #selector(didTapClose)
        
        )

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    private var sections: [SettingsSection] = []
    
    private func updateTitle(){
        if let currentSource = UserDefaults.standard.string(forKey: "source"){
            sourceTitle = "選択中: \(currentSource)"
        }
        else{
            sourceTitle = "選択中: 無し"
            
        }
        if let currentGenre = UserDefaults.standard.string(forKey: "genre"){
            genreTitle = "選択中: \(currentGenre)"
        }
        else{
            genreTitle = "選択中: 無し"
            
        }
        if let currentMethod = UserDefaults.standard.string(forKey: "methods"){
            methodTitle = "選択中: \(currentMethod)"
        }
        else{
            methodTitle = "選択中: 無し"
            
        }
    }
    
    private func configureModels(){
        updateTitle()
        sections.append(
            SettingsSection(title: "検索データベース", options: [
                SettingOption(title: "\(sourceTitle)", image: UIImage(), color: .label, handler: {[weak self] in
                    let vc = ListSourceViewController(type: .sources(sources: sourceList))
                    vc.delegate = self
                    self?.present(UINavigationController(rootViewController: vc), animated: true)
                })
                
            
            ])
        
        )
        
        sections.append(
            SettingsSection(title: "検索ジャンル", options: [
                SettingOption(title: "\(genreTitle)", image: UIImage(), color: .label, handler: {[weak self] in
//                    let vc = ListGenreViewController(type: .genres(genres: genreList))
//                    vc.delegate = self
                    let vc = SearchGenreViewController()
                    vc.delegate = self
                    self?.present(UINavigationController(rootViewController: vc), animated: true)
                })
                
            
            ])
        
        )
        
        sections.append(
            SettingsSection(title: "移動手段 設定", options: [
                SettingOption(title: "\(methodTitle)", image: UIImage(), color: .label, handler: {[weak self] in
                    let vc = ListMethodsViewController(type: .methods(methods: methodList))
                    vc.delegate = self
                    self?.present(UINavigationController(rootViewController: vc), animated: true)
                })
                
            
            ])
        
        )
    }

}

extension MapSettingsViewController{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.imageView?.image = model.image
        cell.imageView?.tintColor = model.color
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    
}

extension MapSettingsViewController{
    private func setupObserver(){
        methodsObserver = NotificationCenter.default.addObserver(forName: .didMethodsChanged, object: nil, queue: .main) { [weak self] _ in
//            guard let method = UserDefaults.standard.string(forKey: "methods") else {
//                return
//            }
            self?.configureModels()
            
//            self?.methodsLabel.text = method
//            self?.methodsLabel.sizeToFit()
//
//            if method == "Walk"{
//                let image = UIImage(systemName: "figure.walk", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 24))
//                self?.methodsButton.setImage(image, for: .normal)
//
//            } else if method == "Drive" {
//                let image = UIImage(systemName: "car", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 24))
//                self?.methodsButton.setImage(image, for: .normal)
//
//            }else{
//                return
//            }
            
                
            
        }
        
        
        genreObserver = NotificationCenter.default.addObserver(forName: .didGenreChanged, object: nil, queue: .main) { [weak self] _ in
//            guard let genre = UserDefaults.standard.string(forKey: "genre") else {
//                return
//            }
            self?.configureModels()
            
//            self?.genreLabel.font = UIFont.systemFont(ofSize: 10)
//            self?.genreLabel.text = genre
//            self?.genreLabel.sizeToFit()
//
        }
        
        sourceObserver = NotificationCenter.default.addObserver(forName: .didSourceChanged, object: nil, queue: .main) { [weak self] _ in
//            guard let source = UserDefaults.standard.string(forKey: "source") else {
//                return
//            }
            self?.configureModels()
//            self?.sourceLabel.font = UIFont.systemFont(ofSize: 10)
//            self?.sourceLabel.text = source
//            self?.sourceLabel.sizeToFit()
//
        }
        
    }
}

//extension MapSettingsViewController: ListGenreViewControllerDelegate{
//    func listGenreViewControllerDidSelected() {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    
//}

extension MapSettingsViewController: ListSourceViewControllerDelegate{
    func listSourceViewControllerDidSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension MapSettingsViewController: SearchGenreViewControllerDelegate{
    func searchGenreViewControllerDidSelected(code: String) {
        dismiss(animated: true, completion: nil)
        print("here called \(code)")
        UserDefaults.standard.setValue(genreCodeToDisplayString(x: code), forKey: "genre")
        NotificationCenter.default.post(name: .didGenreChanged, object: nil)
    }
    
    
}

extension MapSettingsViewController: ListMethodsViewControllerDelegate{
    func listMethodsViewControllerDidSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
