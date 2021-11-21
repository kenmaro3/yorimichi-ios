//
//  SettingsViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import SafariServices
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return tableView
    }()
    
    private var sections: [SettingsSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        
        configureModels()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        
        createTableFooter()
    }
    
    
    private func configureModels(){
        sections.append(
            SettingsSection(title: "Local Storage Settings", options: [
                SettingOption(title: "Save Photo", image: UIImage(), color: .label, handler: {
                    
                }),
                
                SettingOption(title: "Save Video", image: UIImage(), color: .label, handler: {
                    
                })
            
            ])
        
        )
        sections.append(
            
            SettingsSection(title: "App", options: [
                SettingOption(title: "Rate App", image: UIImage(systemName: "star"), color: .systemOrange) {
                    guard let url = URL(string: "https://yorimichi-project.webflow.io/") else {
                        return
                    }
                    DispatchQueue.main.async {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                },
                SettingOption(title: "Share App", image: UIImage(systemName: "square.and.arrow.up"), color: .systemBlue) { [weak self] in
                    guard let url = URL(string: "https://yorimichi-project.webflow.io/") else {
                        return
                    }
                    DispatchQueue.main.async {
                        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
                        self?.present(vc, animated: true)
                    }
                    
                    
                },
            ]
                           ))
        
        sections.append(SettingsSection(title: "Information", options: [
            SettingOption(title: "Terms of Service", image: UIImage(systemName: "doc"), color: .systemPink) { [weak self] in
                DispatchQueue.main.async {
                    guard let url = URL(string: "https://yorimichi-project.webflow.io/image-license-info") else{
                        return
                    }
                    let vc = SFSafariViewController(url: url)
                    self?.present(vc, animated: true, completion: nil)
                }
                
            },
            SettingOption(title: "Privacy Policy", image: UIImage(systemName: "hand.raised"), color: .systemGreen) { [weak self] in
                DispatchQueue.main.async {
                    guard let url = URL(string: "https://yorimichi-privacy-policy.webflow.io/") else{
                        return
                    }
                    let vc = SFSafariViewController(url: url)
                    self?.present(vc, animated: true, completion: nil)
                }
                
            },
            
            SettingOption(title: "Get Help", image: UIImage(systemName: "questionmark.circle"), color: .systemPurple) { [weak self] in
                DispatchQueue.main.async {
                    guard let url = URL(string: "https://yorimichi-project.webflow.io/") else{
                        return
                    }
                    let vc = SFSafariViewController(url: url)
                    self?.present(vc, animated: true, completion: nil)
                }
                
            },
        ]))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    // Table
    
    private func createTableFooter(){
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        footer.clipsToBounds = true
        
        let button = UIButton(frame: footer.bounds)
        footer.addSubview(button)
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        
        tableView.tableFooterView = footer
    }
    
    @objc private func didTapSignOut(){
        let actionSheet = UIAlertController(
            title: "Sign Out",
            message: "Are you sure?",
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            AuthManager.shared.signOut{ success in
                if success{
                    DispatchQueue.main.async {
                        let vc = SignInViewController()
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true)
                    }
                }
            }
        }))
        present(actionSheet, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        print("\n\n==========")
        print("\(model.title)")
        if model.title == "Save Photo"{
            print("called here")
            let isOn = UserDefaults.standard.bool(forKey: "save_photo")
            let viewModel = SwitchCellViewModel(title: model.title, isOn: isOn, type: .photo)
            print(viewModel)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
            
        }
        else if model.title == "Save Video"{
            let isOn = UserDefaults.standard.bool(forKey: "save_video")
            let viewModel = SwitchCellViewModel(title: model.title, isOn: isOn, type: .video)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = model.title
            cell.imageView?.image = model.image
            cell.imageView?.tintColor = model.color
            cell.accessoryType = .disclosureIndicator
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
}

extension SettingsViewController: SwitchTableViewCellDelegate{
    func switchTableViewCell(_ cell: SwitchTableViewCell, didupdateSwitchTo isOn: Bool) {
        if cell.type == .photo{
            UserDefaults.standard.setValue(isOn, forKey: "save_photo")
        }
        else if cell.type == .video{
            UserDefaults.standard.setValue(isOn, forKey: "save_video")
        }
    }
    
    
}
