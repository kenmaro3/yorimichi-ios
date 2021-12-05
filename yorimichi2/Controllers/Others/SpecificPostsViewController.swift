import Foundation

import UIKit

class SpecificPostsViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout{ index, _  -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
            let fullItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            let tripletItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1)))
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)), subitem: fullItem, count: 2)
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160)), subitems: [item, verticalGroup])
            let threeItemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160)), subitem: tripletItem, count: 3)
            let finalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(320)), subitems: [horizontalGroup, threeItemGroup])

            return NSCollectionLayoutSection(group: finalGroup)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView

    }()


    private var posts = [Post]()
    
    
    // MARK: - Init
    init(locationTitle: String){
        super.init(nibName: nil, bundle: nil)
        title = "\(locationTitle) の投稿"
        fetchData(locationTitle: locationTitle)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self

    }


    public func fetchData(locationTitle: String){
        DatabaseManager.shared.findPlaces(with: locationTitle, completion: { [weak self] posts in
            DispatchQueue.main.async {
                self?.posts = posts
                self?.collectionView.reloadData()
            }
        })
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

}


extension SpecificPostsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError()
        }
        let model = posts[indexPath.row]
        cell.configure(with: URL(string: model.postUrlString))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = posts[indexPath.row]
        print("\n\ndebug")
        print(model)
        let vc = PhotoPostViewController(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}

