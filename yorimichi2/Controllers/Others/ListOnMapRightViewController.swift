//
//  ListOnMapRightViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/11.
//

import UIKit
import SafariServices

 
protocol ListOnMapRightViewControllerDelegate: AnyObject{
    func ListOnMapRightViewControllerDidSelect(index: Int, viewModel: ListYorimichiLikesCellType)

}

class ListOnMapRightViewController: UIViewController {
    
    weak var delegate: ListOnMapRightViewControllerDelegate?
    
//    private var models: [ListExploreResultCellType] = []
    
    public let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isHidden = false
        tableView.register(ListExploreResultYorimichiTableViewCell.self, forCellReuseIdentifier: ListExploreResultYorimichiTableViewCell.identifier)
        tableView.register(ListExploreResultHPTableViewCell.self, forCellReuseIdentifier: ListExploreResultHPTableViewCell.identifier)
        tableView.register(ListYorimichiLikesTableViewCell.self, forCellReuseIdentifier: ListYorimichiLikesTableViewCell.identifier)
        
        return tableView
    }()
    
    private var viewModels: [ListYorimichiLikesCellType] = []
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    public func update(with viewModels: [ListYorimichiLikesCellType]){
        self.viewModels = viewModels
        tableView.reloadData()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        //view.backgroundColor = .systemGreen
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        tableView.frame = view.bounds
        //tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height/5*4-40)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        
    }
//    @objc func didTapClose(){
//        dismiss(animated: true, completion: nil)
//    }
}


extension ListOnMapRightViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModels[indexPath.row]
        switch cellType{
        case .yorimichiDB(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListYorimichiLikesTableViewCell.identifier, for: indexPath) as? ListYorimichiLikesTableViewCell else {
                fatalError()
            }

            cell.configure(with: viewModel)
            cell.delegate = self
            return cell

        }

    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.separatorInset = UIEdgeInsets(top: 30, left: 30, bottom: 0, right: 30)
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.ListOnMapRightViewControllerDidSelect(index: indexPath.row, viewModel: viewModels[indexPath.row])
    }
}


extension ListOnMapRightViewController: ListYorimichiLikesTableViewCellDelegate{
    func ListYorimichiLikesTableViewCellDidTapDetail(_ cell: ListYorimichiLikesTableViewCell, didTapDetailWith viewModel: LikesAnnotationViewModel) {
        if viewModel.post.isVideo{
            // Need to get post from user post
            
            DatabaseManager.shared.getVideoPost(with: viewModel.post.id, from: viewModel.post.user.username, completion: {[weak self] post in
                if let post = post{
                    DispatchQueue.main.async {
                        let vc = VideoPostViewController(model: post)
                        self?.present(vc, animated: true)
                        
                    }
                    
                }
                else{
                    AlertManager.shared.presentError(title: "ヨリミチ投稿検索エラー", message: "この投稿はユーザがすでに削除しています。", completion: { alert in
                        DispatchQueue.main.async {
                            self?.present(alert, animated: true)
                        }
                        
                    })
                }
                
            })

        }
        else{
            
            DatabaseManager.shared.getPost(with: viewModel.post.id, from: viewModel.post.user.username, completion: {[weak self] post in
                if let post = post{
                    DispatchQueue.main.async {
                        let vc = PhotoPostViewController(model: post)
                        self?.present(vc, animated: true)
                    }
                    
                }
                else{
                    AlertManager.shared.presentError(title: "ヨリミチ投稿検索エラー", message: "この投稿はユーザがすでに削除しています。", completion: { alert in
                        DispatchQueue.main.async {
                            self?.present(alert, animated: true)
                        }
                        
                    })
                }
                
            })


        }

        
    }
    
    
    
    
}

//extension ListOnMapRightViewController: ListExploreResultYorimichiTableViewCellDelegate{
//    func listExploreResultYorimichiTableViewCellDidTapYorimichiImageView(_ cell: ListExploreResultYorimichiTableViewCell, didTapWith viewModel: YorimichiAnnotationViewModel) {
//        delegate?.ListOnMapRightViewControllerDidDoubleTapYorimichi(cell, didTapPostWith: viewModel)
//    }
//    
//    func listExploreResultYorimichiTableViewCell(_ cell: ListExploreResultYorimichiTableViewCell, didTapPostWith viewModel: YorimichiAnnotationViewModel) {
//        
//    }
//    
//    func listExploreResultYorimichiTableViewCellDidTapDetail(_ cell: ListExploreResultYorimichiTableViewCell, didTapDetailWith viewModel: YorimichiAnnotationViewModel) {
//        
//        if viewModel.post.isVideo{
//            guard let username = UserDefaults.standard.string(forKey: "username") else {
//                return
//            }
//            DatabaseManager.shared.getVideoPost(with: viewModel.post.id, from: username, completion: { post in
//                guard let post = post else {
//                    return
//                }
//                let vc = VideoPostViewController(model: post)
//                //            vc.delegate = self
//                self.present(vc, animated: true)
//                
//                
//            })
//
//        }
//        else{
//            let vc = PhotoPostViewController(model: viewModel.post)
//            //            vc.delegate = self
//            self.present(vc, animated: true)
//
//        }
//
//        
//    }
//    
//    
//}
