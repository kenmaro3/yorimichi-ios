import Foundation

import UIKit

class ExploreViewController: UIViewController, UISearchResultsUpdating {
    private let searchVC = UISearchController(searchResultsController: SearchPostResultsViewController())

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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Explore"
        (searchVC.searchResultsController as? SearchPostResultsViewController)?.delegate = self

        searchVC.searchBar.placeholder = "キーワード検索 ..."
        navigationItem.searchController = searchVC
        searchVC.searchResultsUpdater = self

        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self

        fetchData()

    }


    private func fetchData(){
        DatabaseManager.shared.explorePosts{ [weak self] posts in
            DispatchQueue.main.async {
                self?.posts = posts
                self?.collectionView.reloadData()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    /// when user hit the keyboard key
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchPostResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }

        DatabaseManager.shared.findPlacesSubString(with: query){ results in
            resultsVC.update(with: results)
        }
    }
}

extension ExploreViewController: SearchPostResultsViewControllerDelegate{
    func searchPostResultsViewController(_ vc: SearchPostResultsViewController, didSelectResultsPlace locationTitle: String) {
        print("\n\n==================================")
        print(locationTitle)
        let vc = SpecificPostsViewController(locationTitle: locationTitle)
        //vc.fetchData(with: locationTitle)
        navigationController?.pushViewController(vc, animated: true)
//        let vc = PhotoPostViewController(model: post)
//        navigationController?.pushViewController(vc, animated: true)
    }


}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource{
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

