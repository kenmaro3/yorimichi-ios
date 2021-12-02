//
//  ListOnMapMiddleViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/11.
//

import UIKit
import SafariServices

 
protocol ListOnMapMiddleViewControllerDelegate: AnyObject{
    func ListOnMapMiddleViewControllerDidSelect(index: Int, viewModel: ListExploreResultCellType)
    func ListOnMapMiddleViewControllerDidDoubleTapYorimichi(_ cell: ListExploreResultYorimichiTableViewCell, didTapPostWith viewModel: YorimichiAnnotationViewModel)
    func ListOnMapMiddleViewControllerDidDoubleTapGoogle(_ cell: ListExploreResultGoogleTableViewCell, didTapPostWith viewModel: GoogleAnnotationViewModel)
    func ListOnMapMiddleViewControllerDidDoubleTapHP(_ cell: ListExploreResultHPTableViewCell, didTapPostWith viewModel: HPAnnotationViewModel)

}

class ListOnMapMiddleViewController: UIViewController {
    
    weak var delegate: ListOnMapMiddleViewControllerDelegate?
    
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
        print("update called with")
        print(viewModels)
        self.viewModels = viewModels
        tableView.reloadData()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemRed
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


extension ListOnMapMiddleViewController: UITableViewDelegate, UITableViewDataSource{
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
        delegate?.ListOnMapMiddleViewControllerDidSelect(index: indexPath.row, viewModel: viewModels[indexPath.row])
    }
}

extension ListOnMapMiddleViewController: ListExploreResultHPTableViewCellDelegate{
    func listExploreResultHPTableViewCell(_ cell: ListExploreResultHPTableViewCell, didTapPostWith viewModel: HPAnnotationViewModel) {
        delegate?.ListOnMapMiddleViewControllerDidDoubleTapHP(cell, didTapPostWith: viewModel)
    }
    
    func listExploreResultHPTableViewCellDidTapDetail(_ cell: ListExploreResultHPTableViewCell, didTapDetailWith viewModel: HPAnnotationViewModel) {
        let vc = SFSafariViewController(url: URL(string: cell.jumpUrl)!)
        present(vc, animated: true)
    }
}


extension ListOnMapMiddleViewController: ListExploreResultGoogleTableViewCellDelegate{
    func listExploreResultGoogleTableViewCell(_ cell: ListExploreResultGoogleTableViewCell, didTapPostWith viewModel: GoogleAnnotationViewModel) {
        delegate?.ListOnMapMiddleViewControllerDidDoubleTapGoogle(cell, didTapPostWith: viewModel)
    }
    
    
}

extension ListOnMapMiddleViewController: ListExploreResultYorimichiTableViewCellDelegate{
    func listExploreResultYorimichiTableViewCellDidTapYorimichiImageView(_ cell: ListExploreResultYorimichiTableViewCell, didTapWith viewModel: YorimichiAnnotationViewModel) {
        delegate?.ListOnMapMiddleViewControllerDidDoubleTapYorimichi(cell, didTapPostWith: viewModel)
    }
    
    func listExploreResultYorimichiTableViewCell(_ cell: ListExploreResultYorimichiTableViewCell, didTapPostWith viewModel: YorimichiAnnotationViewModel) {
        
    }
    
    func listExploreResultYorimichiTableViewCellDidTapDetail(_ cell: ListExploreResultYorimichiTableViewCell, didTapDetailWith viewModel: YorimichiAnnotationViewModel) {
        
        if viewModel.post.isVideo{
            // Need to get post from user post
            
            DatabaseManager.shared.getVideoPost(with: viewModel.post.id, from: viewModel.post.user.username,completion: {[weak self] post in
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
