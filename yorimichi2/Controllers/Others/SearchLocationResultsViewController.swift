//
//  SearchLocationResultsViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/09.
//

import UIKit
import MapKit


protocol SearchLocationResultsViewControllerDelegate: AnyObject{
    func searchResultsViewControllerDidSelected(title: String, subTitle: String, location: Location)
}

class SubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchLocationResultsViewController: UIViewController {
    weak var delegate: SearchLocationResultsViewControllerDelegate?
    private var places = [MKLocalSearchCompletion]()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
        
    }()
    
    
//    public weak var delegate: SearchResultsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        

    }
    
    public func update(with results: [MKLocalSearchCompletion]){
        self.places = results
        tableView.reloadData()
        tableView.isHidden = places.isEmpty
        
        
    }
}

extension SearchLocationResultsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SubtitleTableViewCell else {
            return UITableViewCell()
        }
        let place = places[indexPath.row]
        cell.textLabel?.text = "\(place.title)"
        cell.detailTextLabel?.text = "\(place.subtitle)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = places[indexPath.row]
        print("\n\nplace===========================================")
        let request: MKLocalSearch.Request =  MKLocalSearch.Request(completion: places[indexPath.row])
        let search = MKLocalSearch(request: request)

        search.start(completionHandler: {[weak self] response, error in
            if let response = response {
                if (response.mapItems.count > 0){
                    let location = Location(lat: response.mapItems[0].placemark.coordinate.latitude, lng: response.mapItems[0].placemark.coordinate.longitude)
                    self?.delegate?.searchResultsViewControllerDidSelected(title: place.title, subTitle: place.subtitle, location: location)
                    
                    self?.dismiss(animated: true, completion: nil)
                    
                }else{
                    AlertManager.shared.presentError(title: "?????????????????????", message: "????????????????????????????????????????????????????????????????????????????????????????????????", completion: {[weak self] alert in
                        self?.present(alert, animated: true)
                    })
                    return

                }
            }else{
                AlertManager.shared.presentError(title: "?????????????????????", message: "????????????????????????????????????????????????????????????????????????????????????????????????", completion: {[weak self] alert in
                    self?.present(alert, animated: true)
                })
                return

            }

        })
        
        
    }
    
}
