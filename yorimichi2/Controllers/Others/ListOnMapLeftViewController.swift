//
//  ListOnMapLeftViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/11.
//

import UIKit
import SafariServices

 
protocol ListOnMapLeftViewControllerDelegate: AnyObject{
    func listOnMapLeftViewControllerDidSelect(index: Int, viewModel: ListExploreResultCellType)
    func listOnMapLeftViewControllerDidTapYorimichiButton(id: String, viewModel: ListExploreResultCellType)
    func listOnMapLeftViewControllerDidHPDoubleTapped(_ cell: ListExploreResultHPTableViewCell, didTapPostWith viewModel: HPAnnotationViewModel)
    func listOnMapLeftViewControllerDidGoogleDoubleTapped(_ cell: ListExploreResultGoogleTableViewCell, didTapPostWith viewModel: GoogleAnnotationViewModel)
}

class ListOnMapLeftViewController: UIViewController {
    
    weak var delegate: ListOnMapLeftViewControllerDelegate?
    
//    private var models: [ListExploreResultCellType] = []
    
    public let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isHidden = false
        tableView.register(ListExploreResultYorimichiTableViewCell.self, forCellReuseIdentifier: ListExploreResultYorimichiTableViewCell.identifier)
        tableView.register(ListExploreResultGoogleTableViewCell.self, forCellReuseIdentifier: ListExploreResultGoogleTableViewCell.identifier)
        tableView.register(ListExploreResultHPTableViewCell.self, forCellReuseIdentifier: ListExploreResultHPTableViewCell.identifier)
//        tableView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0)
        
        return tableView
    }()
    
    private var viewModels: [ListExploreResultCellType] = []
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    public func update(with viewModels: [ListExploreResultCellType]){
        self.viewModels = viewModels
        tableView.reloadData()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            barButtonSystemItem: .close,
//            target: self,
//            action: #selector(didTapClose)
//        )
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


extension ListOnMapLeftViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModels[indexPath.row]
        switch cellType{
        case .yorimichiDB(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListExploreResultYorimichiTableViewCell.identifier, for: indexPath) as? ListExploreResultYorimichiTableViewCell else {
                fatalError()
            }

//            cell.accessoryType = .disclosureIndicator
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        

            
//            cell.accessoryType = .disclosureIndicator
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell

            
        case .hp(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListExploreResultHPTableViewCell.identifier, for: indexPath) as? ListExploreResultHPTableViewCell else {
                fatalError()
            }
            
//            cell.accessoryType = .disclosureIndicator
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
        delegate?.listOnMapLeftViewControllerDidSelect(index: indexPath.row, viewModel: viewModels[indexPath.row])
    }
}

extension ListOnMapLeftViewController: ListExploreResultHPTableViewCellDelegate{
    func listExploreResultHPTableViewCell(_ cell: ListExploreResultHPTableViewCell, didTapPostWith viewModel: HPAnnotationViewModel) {
        delegate?.listOnMapLeftViewControllerDidHPDoubleTapped(cell, didTapPostWith: viewModel)
        
    }
    
    func listExploreResultHPTableViewCellDidTapDetail(_ cell: ListExploreResultHPTableViewCell, didTapDetailWith viewModel: HPAnnotationViewModel) {
        let vc = SFSafariViewController(url: URL(string: cell.jumpUrl)!)
        present(vc, animated: true)
    }
}

extension ListOnMapLeftViewController: ListExploreResultGoogleTableViewCellDelegate{
    func listExploreResultGoogleTableViewCell(_ cell: ListExploreResultGoogleTableViewCell, didTapPostWith viewModel: GoogleAnnotationViewModel) {
        delegate?.listOnMapLeftViewControllerDidGoogleDoubleTapped(cell, didTapPostWith: viewModel)
    }
    
    
}

extension ListOnMapLeftViewController: ListExploreResultYorimichiTableViewCellDelegate{
    func listExploreResultYorimichiTableViewCellDidTapYorimichiImageView(_ cell: ListExploreResultYorimichiTableViewCell, didTapWith viewModel: YorimichiAnnotationViewModel) {
        
    }
    
    func listExploreResultYorimichiTableViewCell(_ cell: ListExploreResultYorimichiTableViewCell, didTapPostWith viewModel: YorimichiAnnotationViewModel) {
        
    }
    
    func listExploreResultYorimichiTableViewCellDidTapDetail(_ cell: ListExploreResultYorimichiTableViewCell, didTapDetailWith viewModel: YorimichiAnnotationViewModel) {
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
                    
//                    DatabaseManager.shared.deleteYorimichiPost(post: viewModel.post, completion: { res in
//                        if !res {
//
//                        }
//                        else{
//
//                        }
//
//                    })
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

//extension ListOnMapLeftViewController: YorimichiPostViewControllerDelegate{
//    func yorimichiPostViewControllerDidTapYorimichiButton(id: String) {
////        dismiss(animated: true, completion: nil)
//        findViewModelById(id: id, completion: {index in
//            if index == -1{
//                return
//            }
//            let tmpCell = tableView.cellForRow(at: NSIndexPath(row: index, section: 0) as IndexPath) as? ListExploreResultYorimichiTableViewCell
//            tmpCell?.yorimichiOn()
//            delegate?.listOnMapLeftViewControllerDidTapYorimichiButton(id: id, viewModel: viewModels[index])
//        })
//
//    }
//
//    private func findViewModelById(id: String, completion: (Int)->Void){
//        for (i, el) in zip(viewModels.indices, viewModels){
//            switch el{
//            case .yorimichiDB(let model):
//                if id == model.post.id{
//                    completion(i)
//                }
//            case .google(let model):
//                if id == model.shop.id{
//                    completion(i)
//                }
//            case .hp(let model):
//                if id == model.shop.id{
//                    completion(i)
//                }
//
//            }
//        }
//        completion(-1)
//    }
//}

extension ListOnMapLeftViewController: UIViewControllerTransitioningDelegate{
    
//    func tableView(
//        _ tableView: UITableView,
//        commit editingStyle: UITableViewCell.EditingStyle,
//        forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            viewModels.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.reloadData()
//            delegate?.listExploreResultViewControllerDidDelete(index: indexPath.row, viewModel: viewModels[indexPath.row])
//        }
//    }
}
