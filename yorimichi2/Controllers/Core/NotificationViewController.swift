
import UIKit

class NotificationViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    private let noActivityLabel: UILabel = {
        let label = UILabel()
        label.text = "No Notifications"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private var viewModels: [NotificationCellType] = []
    private var models: [IGNotification] = []

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isHidden = true
        tableView.register(FollowNotificationTableViewCell.self, forCellReuseIdentifier: FollowNotificationTableViewCell.identifier)
        tableView.register(LikeNotificationTableViewCell.self, forCellReuseIdentifier: LikeNotificationTableViewCell.identifier)
        tableView.register(CommentNotificationTableViewCell.self, forCellReuseIdentifier: CommentNotificationTableViewCell.identifier)

        return tableView
    }()


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "通知"
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(noActivityLabel)

        fetchNotifications()
    }

    private func fetchNotifications(){
//        NotificationManager.shared.getNotifications notifications in
//
//        }

        noActivityLabel.isHidden = true
        NotificationManager.shared.getNotifications{ [weak self] models in
            print("\n\nheree=================")
            print(models)
            DispatchQueue.main.async {
                self?.models = models
                self?.createViewModels()
            }

        }
    }

    private func createViewModels(){
        print("createing")
        print(models.count)
        models.forEach{ model in
            guard let type = NotificationManager.IGType(rawValue: model.notificationType) else {
                print("falling type guard")
                return
                
                
            }
            print("here")
            print(type)

            let username = model.username
            guard let profilePictureUrl = URL(string: model.profilePictureUrl) else {return}

            print("here2")
            // Derive
            switch type{
            case .like:
                print("at least here")
                guard let postUrl = URL(string: model.postUrl ?? "") else {
                    print("\n\nfalling here")
                    return
                }
                viewModels.append(
                    .like(
                        viewModel: LikeNotificationCellViewModel(
                            username: username,
                            profilePictureUrl: profilePictureUrl,
                            postUrl: postUrl,
                            date: model.dateString
                        )))
            case .comment:
                guard let postUrl = URL(string: model.postUrl ?? "") else{
                    return
                }
                viewModels.append(
                    .comment(
                        viewModel: CommentNotificationCellViewModel(
                            username: username,
                            profilePictureUrl: profilePictureUrl,
                            postUrl: postUrl,
                            date: model.dateString
                        )))
            case .follow:
                viewModels.append(
                    .follow(
                        viewModel: FollowNotificationCellViewModel(
                            username: username,
                            profilePictureUrl: profilePictureUrl,
                            date: model.dateString
                        )))
            }

        }
        
        print("count")
        print(viewModels.count)

        if viewModels.isEmpty{
            print("isempty")
            noActivityLabel.isHidden = false
            tableView.isHidden = true
        }
        else{
            print("is not Empty")
            noActivityLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()

        }

    }


    private func mockData(){
        tableView.isHidden = false
        guard let postUrl = URL(string: "https://iosacademy.io/assets/images/courses/swiftui.png"),
              let iconUrl = URL(string: "https://iosacademy.io/assets/images/brand/icon.jpg") else {
                  return
              }

        guard let tmpDateString = String.date(from: Date()) else {
            return
        }
        viewModels = [
            .like(viewModel: LikeNotificationCellViewModel(username: "Mizuki", profilePictureUrl: iconUrl, postUrl: postUrl, date: tmpDateString)),
            .comment(viewModel: CommentNotificationCellViewModel(username: "Tamai", profilePictureUrl: iconUrl, postUrl: postUrl, date: tmpDateString)),
            .follow(viewModel: FollowNotificationCellViewModel(username: "Smith", profilePictureUrl: iconUrl, date: tmpDateString))
        ]

        tableView.reloadData()
    }

    // MARK: - Table


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
        noActivityLabel.sizeToFit()
        noActivityLabel.center = view.center
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModels[indexPath.row]
        switch cellType{
        case .follow(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowNotificationTableViewCell.identifier, for: indexPath) as? FollowNotificationTableViewCell else{
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell

        case .like(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeNotificationTableViewCell.identifier, for: indexPath) as? LikeNotificationTableViewCell else{
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell

        case .comment(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentNotificationTableViewCell.identifier, for: indexPath) as? CommentNotificationTableViewCell else{
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell

        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cellType = viewModels[indexPath.row]
        let username: String
        switch cellType{
        case .follow(let viewModel):
            username = viewModel.username
        case .like(let viewModel):
            username = viewModel.username
        case .comment(let viewModel):
            username = viewModel.username
        }


        DatabaseManager.shared.findUser(username: username){[weak self] user in
            guard let user = user else{
                let alert = UIAlertController(title: "Cannot find user", message: "Unable to find user with notification tap", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                self?.present(alert, animated: true)
                return
            }

            DispatchQueue.main.async{
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)

            }

        }
    }
}



// MARK: - Actions


extension NotificationViewController: FollowNotificationTableViewCellDelegate{
    func openPost(with index: Int, username: String){
        guard index < models.count else{
            return
        }
        let model = models[index]
        let username = model.username
        guard let postId = model.postId else{
            return
        }
        
        
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        // Find post by id from target user
        
        switch model.postType{
        case .photo:
            DatabaseManager.shared.getPost(with: postId, from: currentUsername, completion: {[weak self] post in
                DispatchQueue.main.async {
                    guard let post = post else {
                        let alert = UIAlertController(title: "投稿表示エラー", message: "投稿を開けませんでした。この投稿はすでに削除された可能性があります。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                        return
                    }
                    print(post)
                    
                    let vc = PhotoPostViewController(model: post)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            })
        case .video:
            DatabaseManager.shared.getVideoPost(with: postId, from: currentUsername, completion: {[weak self] post in
                DispatchQueue.main.async {
                    guard let post = post else {
                        let alert = UIAlertController(title: "投稿表示エラー", message: "投稿を開けませんでした。この投稿はすでに削除された可能性があります。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                        return
                    }
                    print(post)
                    
                    let vc = VideoPostViewController(model: post)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            })
        default:
            break
        }

    }

    func followNotificationTableViewCell(_ cell: FollowNotificationTableViewCell, didTapButton isFollowing: Bool, viewModel: FollowNotificationCellViewModel) {

        let username = viewModel.username


        print("Request follow= \(isFollowing), for username = \(username)")
        DatabaseManager.shared.updateRelationship(
            state: isFollowing ? .follow : .unfollow,
            for: username
        ){ [weak self] success in
            if !success{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Following Error", message: "Unable to follow/unfollow user: \(username)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
            }


        }
    }
}

extension NotificationViewController: LikeNotificationTableViewCellDelegate{
    func likeNotificationTableViewCell(_ cell: LikeNotificationTableViewCell, didTapPostWith viewModel: LikeNotificationCellViewModel) {
        print("openPost")

        guard let index = viewModels.firstIndex(where: {
            switch $0{
            case .follow, .comment:
                return false
            case .like(let current):
                return current == viewModel
            }
        }) else{
            return
        }
        
        openPost(with: index, username: viewModel.username)

    }
}



extension NotificationViewController: CommentNotificationTableViewCellDelegate{
    func commentNotificationTableViewCell(_ cell: CommentNotificationTableViewCell, didTapPostWith viewModel: CommentNotificationCellViewModel) {
        guard let index = viewModels.firstIndex(where: {
            switch $0{
            case .follow, .like:
                return false
            case .comment(let current):
                return current == viewModel
            }
        }) else{
            return
        }

        openPost(with: index, username: viewModel.username)

        // Find Post by Id



    }


}
