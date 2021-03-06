//
//  ListViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import UIKit

class ListViewController: UIViewController{
    
    private let type: ListType
    private var viewModels: [ListUserTableViewCellViewModel] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ListUserTableViewCell.self, forCellReuseIdentifier: ListUserTableViewCell.identifier)
        return tableView
        
        
    }()
    
    enum ListType{
        case followers(user: User)
        case following(user: User)
        case likers(usernames: [String])
        
        var title: String {
            switch self{
            case .followers:
                return "フォロワー"
            case .following:
                return "フォロー中"
            case .likers:
                return "いいねをしたユーザー"
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
        view.addSubview(tableView)
        
        title = type.title
        tableView.delegate = self
        tableView.dataSource = self
        
        configureViewModels()
    }

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureViewModels(){
        switch type{
        case .followers(let targetUser):
            DatabaseManager.shared.followers(for: targetUser.username, completion: {[weak self] usernames in
                self?.viewModels = usernames.compactMap({
                    ListUserTableViewCellViewModel(imageUrl: nil, username: $0)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
            
        case .following(let targetUser):
            DatabaseManager.shared.following(for: targetUser.username, completion: {[weak self] usernames in
                self?.viewModels = usernames.compactMap({
                    ListUserTableViewCellViewModel(imageUrl: nil, username: $0)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
        case .likers(let usernames):
            viewModels = usernames.compactMap({
                ListUserTableViewCellViewModel(imageUrl: nil, username: $0)
            })
            
            tableView.reloadData()
            
            
        }
        
        
    }
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListUserTableViewCell.identifier, for: indexPath) as? ListUserTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:  true)
        let username = viewModels[indexPath.row].username
        DatabaseManager.shared.findUser(username: username, completion: {[weak self] user in
            if let user = user{
                DispatchQueue.main.async {
                    let vc = ProfileViewController(user: user)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
