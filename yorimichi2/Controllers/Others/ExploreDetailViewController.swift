//
//  ExploreDetailViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2022/02/01.
//

import UIKit

class ExploreDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var posts = [Post]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var model: Post
        model = self.posts[indexPath.row]
        let viewModel = PhotoCellViewModel(post: model)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as? PhotoTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel)
        //cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = posts[indexPath.row]
        let vc = PhotoPostViewController(model: model)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    init(posts: [Post]){
        super.init(nibName: nil, bundle: nil)
        self.posts = posts
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func setTitle(title: String){
        navigationItem.title = title
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.frame
        //tableView.contentInsetAdjustmentBehavior = .never
        //tableView.frame = CGRect(x: view.left, y: 30, width: view.width, height: view.height)
    }
    


}
