//
//  CommentsViewController.swift
//  tiktok
//
//  Created by Kentaro Mihara on 2021/11/03.
//

import UIKit

protocol CommentsViewControllerDeleagate: AnyObject{
    func commentsViewControllerDidTapCloseForComments(with viewController: CommentsViewController)
    func commentsViewControllerDidTapComment(with viewController: CommentsViewController, withText text: String)
}

class CommentsViewController: UIViewController {
    weak var delegate: CommentsViewControllerDeleagate?
    
    private var comments = [PostComment]()

    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        
        return tableView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
        
    }()
    
    private var commentBarView = CommentBarView()
    private let commentBarViewHeight: CGFloat = 70

    
    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    
    private let viewModel: CommentsViewModel
    
    init(viewModel: CommentsViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let closeButtonSize: CGFloat = 12
        closeButton.frame = CGRect(x: view.width-35, y: 10, width: closeButtonSize, height: closeButtonSize)
        tableView.frame = CGRect(x: 0, y: closeButton.bottom, width: view.width, height: view.height-closeButton.bottom-commentBarViewHeight)
//        commentBarView.frame = CGRect(x: 0, y: tableView.bottom, width: view.width, height: commentBarViewHeight)
        commentBarView.frame = CGRect(
            x: 0,
            y: view.height-view.safeAreaInsets.bottom-commentBarViewHeight,
            width: view.width,
            height: commentBarViewHeight
        )
        
        print("\n\nhere")
        print(commentBarView.frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        view.backgroundColor = .white
        fetchPostComment()
        
        view.addSubview(closeButton)
        view.addSubview(tableView)
        view.addSubview(commentBarView)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        commentBarView.delegate = self
        
        observeKeyBoardChange()
        
//        fetchPostComment()
    }
    
    @objc private func didTapClose(){
        delegate?.commentsViewControllerDidTapCloseForComments(with: self)
    }
    
    private func observeKeyBoardChange(){
        observer = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main,
            using: {notification in
                guard let userInfo = notification.userInfo,
                      let height = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else{
                          return
                      }
                UIView.animate(withDuration: 0.2){
                    self.commentBarView.frame = CGRect(
                        x: 0,
                        y: self.view.height-60-height,
                        width: self.view.width,
                        height: self.commentBarViewHeight
                    )
                    
                }
            })
        
        hideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main,
            using: {notification in
                guard let userInfo = notification.userInfo,
                      let height = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else{
                          return
                      }
                UIView.animate(withDuration: 0.2){

                    self.commentBarView.frame = CGRect(
                        x: 0,
                        y: self.view.height-self.view.safeAreaInsets.bottom-self.commentBarViewHeight,
                        width: self.view.width,
                        height: self.commentBarViewHeight
                    )
                    
                }
            })
    }
    
    
    private func fetchPostComment(){
        
        switch viewModel.type{
        case .photo(let viewModel):
            DatabaseManager.shared.getComments(postID: viewModel.id, owner: viewModel.user.username, completion: {[weak self] comments in
                DispatchQueue.main.async {
                    print("\n\ncomments")
                    print(comments)
                    self?.comments = comments
                    self?.tableView.reloadData()

                }
                
            })
            
        case .video(let viewModel):
            DatabaseManager.shared.getCommentsVideo(postID: viewModel.id, owner: viewModel.user.username, completion: {[weak self] comments in
                DispatchQueue.main.async {
                    print("\n\ncomments")
                    print(comments)
                    self?.comments = comments
                    self?.tableView.reloadData()

                }
                
            })
            
        }
        
        
    }

}


extension CommentsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = comments[indexPath.row].text
        cell.configure(with: comments[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comment = comments[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ProfileViewController(user: comment.user)
        navigationController?.pushViewController(vc, animated: true)

    }
}

extension CommentsViewController: CommentBarViewDelegate{
    func commentBarViewDidTapComment(_ commentBarView: CommentBarView, withText text: String) {
        delegate?.commentsViewControllerDidTapComment(with: self, withText: text)
    }
}
