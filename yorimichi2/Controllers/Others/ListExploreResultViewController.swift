//
//  ListExploreResultPresentationController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/31.
//

import UIKit
import SafariServices

 
protocol ListExploreResultViewControllerDelegate: AnyObject{
    func listExploreResultViewControllerDidSelect(index: Int, viewModel: ListExploreResultCellType)
    func listExploreResultViewControllerDidTapYorimichiButton(id: String, viewModel: ListExploreResultCellType)
}

class ListExploreResultViewController: UIViewController {
    
    weak var delegate: ListExploreResultViewControllerDelegate?
    
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
    
    init(viewModels: [ListExploreResultCellType]){
        self.viewModels = viewModels
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
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
        
        view.backgroundColor = .systemBackground
        
        tableView.frame = view.bounds
        tableView.frame = CGRect(x: 0, y: 30, width: view.width, height: view.height/2-40)
        
        
    }
//    @objc func didTapClose(){
//        dismiss(animated: true, completion: nil)
//    }
}


extension ListExploreResultViewController: UITableViewDelegate, UITableViewDataSource{
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
//            cell.delegate = self
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
        print("here")
        print(indexPath)
        
        delegate?.listExploreResultViewControllerDidSelect(index: indexPath.row, viewModel: viewModels[indexPath.row])
    }
}

extension ListExploreResultViewController: ListExploreResultHPTableViewCellDelegate{
    func listExploreResultHPTableViewCell(_ cell: ListExploreResultHPTableViewCell, didTapPostWith viewModel: HPAnnotationViewModel) {
        
    }
    
    func listExploreResultHPTableViewCellDidTapDetail(_ cell: ListExploreResultHPTableViewCell, didTapDetailWith viewModel: HPAnnotationViewModel) {
        let vc = SFSafariViewController(url: URL(string: cell.jumpUrl)!)
        present(vc, animated: true)
    }
}

extension ListExploreResultViewController: ListExploreResultYorimichiTableViewCellDelegate{
    func listExploreResultYorimichiTableViewCellDidTapYorimichiImageView(_ cell: ListExploreResultYorimichiTableViewCell, didTapWith viewModel: YorimichiAnnotationViewModel) {
        
    }
    
    func listExploreResultYorimichiTableViewCell(_ cell: ListExploreResultYorimichiTableViewCell, didTapPostWith viewModel: YorimichiAnnotationViewModel) {
        
    }
    
    func listExploreResultYorimichiTableViewCellDidTapDetail(_ cell: ListExploreResultYorimichiTableViewCell, didTapDetailWith viewModel: YorimichiAnnotationViewModel) {
        print("\n\n+++++++++++++++++++")
        print(viewModel.post)
//        let vc = YorimichiPostViewController(post: viewModel.post, genre: viewModel.post.genre)
//        vc.delegate = self
//        present(vc, animated: true)
//        DatabaseManager.shared.getPostFromYorimichi(with: viewModel.post, completion: { [weak self] post in
//            guard let post = post else{
//                return
//            }
//            let vc = PhotoPostViewController(model: post)
////            vc.delegate = self
//            self?.present(vc, animated: true)
//        })
        
        let vc = PhotoPostViewController(model: viewModel.post)
//            vc.delegate = self
        self.present(vc, animated: true)
        
    }
    
    
}

//extension ListExploreResultViewController: YorimichiPostViewControllerDelegate{
//    func yorimichiPostViewControllerDidTapYorimichiButton(id: String) {
////        dismiss(animated: true, completion: nil)
//        findViewModelById(id: id, completion: {index in
//            if index == -1{
//                return
//            }
//            let tmpCell = tableView.cellForRow(at: NSIndexPath(row: index, section: 0) as IndexPath) as? ListExploreResultYorimichiTableViewCell
//            tmpCell?.yorimichiOn()
//            delegate?.listExploreResultViewControllerDidTapYorimichiButton(id: id, viewModel: viewModels[index])
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

extension ListExploreResultViewController: UIViewControllerTransitioningDelegate{
    
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
