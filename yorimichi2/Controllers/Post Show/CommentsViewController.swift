//
//  CommentsViewController.swift
//  tiktok
//
//  Created by Kentaro Mihara on 2021/11/03.
//

import UIKit


protocol CommentsViewControllerDeleagate: AnyObject{
    func commentsViewControllerDidTapCloseForComments(with viewController: CommentsViewController)
    func commentsViewControllerDidTapComment(with viewController: CommentsViewController, withText text: String, type: ShowingCommentSegment)
}

class CommentsViewController: UIViewController {
    weak var delegate: CommentsViewControllerDeleagate?
    
    //private var comments = [PostComment]()
    private var commentsMenu = [PostComment]()
    private var commentsPrice = [PostComment]()
    private var commentsTime = [PostComment]()
    
    
    private var showingSegment: ShowingCommentSegment = .menu
    
    private let mySegcon: UISegmentedControl = {
        // 表示する配列を作成する.
        let myArray: NSArray = ["メニュー","価格", "営業時間"]
        let mySegcon: UISegmentedControl = UISegmentedControl(items: myArray as [AnyObject])
        mySegcon.selectedSegmentIndex = 0
        return mySegcon
        
    }()

    
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
        
        let closeButtonSize: CGFloat = 16
        
        closeButton.frame = CGRect(x: view.width-35, y: 10, width: closeButtonSize, height: closeButtonSize)
        mySegcon.frame = CGRect(x: 20, y: closeButton.bottom+20, width: view.width-40, height: 40)
        mySegcon.backgroundColor = UIColor.gray
        mySegcon.tintColor = UIColor.white

        tableView.frame = CGRect(x: 0, y: mySegcon.bottom + 14, width: view.width, height: view.height-closeButton.bottom-commentBarViewHeight)
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
        view.addSubview(mySegcon)
        
        // イベントを追加する.
        mySegcon.addTarget(self, action: #selector(segconChanged(segCon:)), for: UIControl.Event.valueChanged)
        
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        commentBarView.delegate = self
        
        observeKeyBoardChange()
        
//        fetchPostComment()
    }
    
    /*
     SwgmentedControlの値が変わったときに呼び出される.
     */
    @objc private func segconChanged(segCon: UISegmentedControl){

        switch segCon.selectedSegmentIndex {
        case 0:
            self.showingSegment = .menu
            commentBarView.field.text = "この場所のメニュー情報を追加しましょう。"
            self.tableView.reloadData()

        case 1:
            self.showingSegment = .price
            commentBarView.field.text = "この場所の価格情報を追加しましょう。"
            self.tableView.reloadData()
            
        case 2:
            self.showingSegment = .time
            commentBarView.field.text = "この場所の営業時間情報を追加しましょう。"
            self.tableView.reloadData()

        default:
            print("Error")
        }
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
                        y: self.view.height - 60 - height,
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
                
                comments.forEach{
                    switch $0.type{
                    case .menu:
                        self?.commentsMenu.append($0)
                    case .price:
                        self?.commentsPrice.append($0)
                    case .time:
                        self?.commentsTime.append($0)
                    case .none:
                       print("comment type none")
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()

                }
                
            })
            
        case .video(let viewModel):
            DatabaseManager.shared.getCommentsVideo(postID: viewModel.id, owner: viewModel.user.username, completion: {[weak self] comments in
                comments.forEach{
                    switch $0.type{
                    case .menu:
                        self?.commentsMenu.append($0)
                    case .price:
                        self?.commentsPrice.append($0)
                    case .time:
                        self?.commentsTime.append($0)
                    case .none:
                       print("comment type none")
                        
                    }
                }

                DispatchQueue.main.async {
                    self?.tableView.reloadData()

                }
                
            })
            
        }
        
        
    }

}


extension CommentsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.showingSegment{
        case .menu:
            return commentsMenu.count
        case .price:
            return commentsPrice.count
        case .time:
            return commentsTime.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.showingSegment{
        case .menu:
            let comment = commentsMenu[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier) as? CommentTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: commentsMenu[indexPath.row])
            return cell
        case .price:
            let comment = commentsPrice[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier) as? CommentTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: commentsPrice[indexPath.row])
            return cell
        case .time:
            let comment = commentsTime[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier) as? CommentTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: commentsTime[indexPath.row])
            return cell


        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("called selected")
        switch self.showingSegment{
        case .menu:
            print("called selected1")
            let comment = commentsMenu[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            let vc = ProfileViewController(user: comment.user)
            navigationController?.pushViewController(vc, animated: true)
        case .price:
            let comment = commentsPrice[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            let vc = ProfileViewController(user: comment.user)
            navigationController?.pushViewController(vc, animated: true)
        case .time:
            let comment = commentsTime[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            let vc = ProfileViewController(user: comment.user)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension CommentsViewController: CommentBarViewDelegate{
    func commentBarViewDidTapComment(_ commentBarView: CommentBarView, withText text: String) {
        delegate?.commentsViewControllerDidTapComment(with: self, withText: text, type: self.showingSegment)
    }
    
//    func commentBarViewDidTapGenreButton(_ sender: UIButton) {
//        let frame = sender.frame
//        presentPopoverView(frame: frame)
//    }
    
//    func presentPopoverView(frame: CGRect){
//        let contentVC = CommentGenreViewController()
//
//        contentVC.modalPresentationStyle = .popover
//        contentVC.preferredContentSize = CGSize(width: 100, height: 200)
//
//        guard let popoverPresentationController = contentVC.popoverPresentationController else { return }
//
//        popoverPresentationController.sourceView = view
//        popoverPresentationController.sourceRect = frame
//        popoverPresentationController.permittedArrowDirections = .any
//        popoverPresentationController.delegate = self
//
//        present(contentVC, animated: true, completion: nil)
//    }
}

//extension CommentsViewController: UIPopoverPresentationControllerDelegate {
//    // iPhoneで表示させる場合に必要
//    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
//        return .none
//    }
//}
