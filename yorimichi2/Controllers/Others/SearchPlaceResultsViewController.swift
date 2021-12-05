
import UIKit

protocol SearchPostResultsViewControllerDelegate: AnyObject{
    //func searchPostResultsViewController(_ vc: SearchPostResultsViewController, didSelectResultsPost post: Post)
    func searchPostResultsViewController(_ vc: SearchPostResultsViewController, didSelectResultsPlace placeTitle: String)
}

class SearchPostResultsViewController: UIViewController {
    private var places = [String]()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
        
    }()
    
    
    public weak var delegate: SearchPostResultsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        

    }
    
    public func update(with results: [String]){
        self.places = results
        tableView.reloadData()
        tableView.isHidden = places.isEmpty
        
        
    }
}

extension SearchPostResultsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchPostResultsViewController(self, didSelectResultsPlace: places[indexPath.row])
    }
    
}

