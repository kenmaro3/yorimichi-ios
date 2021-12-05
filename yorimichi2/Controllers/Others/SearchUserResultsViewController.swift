//
//  SearchResultsViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import UIKit

protocol SearchUserResultsViewControllerDelegate: AnyObject{
    func searchUserResultsViewController(_ vc: SearchUserResultsViewController, didSelectResultsUser user: User)
}

class SearchUserResultsViewController: UIViewController {
    private var users = [User]()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
        
    }()
    
    
    public weak var delegate: SearchUserResultsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        

    }
    
    public func update(with results: [User]){
        self.users = results
        tableView.reloadData()
        tableView.isHidden = users.isEmpty
        
        
    }
}

extension SearchUserResultsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchUserResultsViewController(self, didSelectResultsUser: users[indexPath.row])
    }
    
}
