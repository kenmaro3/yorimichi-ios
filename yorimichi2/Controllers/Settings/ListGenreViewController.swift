//
//  ListGenreViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/25.
//

import UIKit

protocol ListGenreViewControllerDelegate: AnyObject{
    func listGenreViewControllerDidSelected()
}


class ListGenreViewController: UIViewController{
    weak var delegate: ListGenreViewControllerDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let type: ListType
    private var sections: [GenreSection] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.register(ListGenreTableViewCell.self, forCellReuseIdentifier: ListGenreTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
        
        
    }()
    
    enum ListType{
        case genres(genres: [String])
        
        var title: String {
            switch self{
            case .genres:
                return "Genres"
            }
        }
    }
    
    init(type: ListType){
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(label)
        view.addSubview(tableView)
        
        if let currentGenre = UserDefaults.standard.string(forKey: "genre"){
            label.text = "現在選択中のジャンル: \(currentGenre)"
  
        } else{
            label.text = "ヨリミチ先のジャンルを選択してください。"
            
        }
        
        title = type.title
        tableView.delegate = self
        tableView.dataSource = self
        
        configureModels()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: (view.width-label.width)/2, y: view.safeAreaInsets.bottom+40, width: label.width, height: label.height)
        //label.center = view.center
        tableView.frame = CGRect(x: 0, y: label.bottom + 20, width: view.width, height: view.height-label.height-100)
    }

    func resizeImage(image: UIImage) -> UIImage{
        guard let resizedImage = image.sd_resizedImage(with: CGSize(width: 128, height: 128), scaleMode: .aspectFill) else{
            return UIImage()
        }
        
        return resizedImage
    }
    
    
    private func configureModels(){
        var options: [GenreOption] = []
        for (i, item) in foodGenreList.enumerated(){
            var imageName = ""
            if(i < 10){
                imageName = "G00\(i)"
            }
            else{
                imageName = "G0\(i)"
            }
            guard let img = UIImage(named: imageName) else {
                return
            }
            let resizedImage = resizeImage(image: img)
            options.append(
                GenreOption(title: genreCodeToDisplayString(x: item), image: resizedImage)
            )
        }
        
        sections.append(
            GenreSection(title: "Food", options: options)
        
        )
//        sections.append(GenreSection(title: "Food", options: [
//            GenreOption(title: "おまかせ", image: UIImage()),
//            GenreOption(title: "居酒屋", image: UIImage(named: "1")),
//            GenreOption(title: "ダイニングバー, バル", image: UIImage(named: "1")),
//            GenreOption(title: "創作料理", image: UIImage(named: "1")),
//            GenreOption(title: "和食", image: UIImage(named: "1")),
//            GenreOption(title: "洋食", image: UIImage(named: "1")),
//            GenreOption(title: "イタリアン, フレンチ", image: UIImage(named: "1")),
//            GenreOption(title: "中華", image: UIImage(named: "1")),
//            GenreOption(title: "焼肉", image: UIImage(named: "1")),
//            GenreOption(title: "アジア料理", image: UIImage(named: "1")),
//            GenreOption(title: "各国料理", image: UIImage(named: "1")),
//            GenreOption(title: "カラオケ", image: UIImage(named: "1")),
//            GenreOption(title: "バー", image: UIImage(named: "1")),
//            GenreOption(title: "ラーメン", image: UIImage(named: "1")),
//            GenreOption(title: "カフェ", image: UIImage(named: "1")),
//            GenreOption(title: "その他グルメ", image: UIImage(named: "1")),
//            GenreOption(title: "お好み焼き", image: UIImage(named: "1")),
//            GenreOption(title: "韓国料理", image: UIImage(named: "1")),
//        ]))
        
    }
    
    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }

    
//    private func configureViewModels(){
//        switch type{
//        case .genres(let genres):
//            viewModels = genreList.compactMap{
//                ListGenreTableViewCellViewModel(genreImageUrl: nil, genreStr: genreCodeToDisplayString(x: $0))
//
//            }
//            tableView.reloadData()
//            break
//        }
//    }
}


extension ListGenreViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.imageView?.image = model.image
        cell.imageView?.layer.cornerRadius
//        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        cell.imageView?.layer.cornerRadius = 20
        
//        cell.imageView?.tintColor = model.color
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:  true)
        print("row")
        let section = indexPath.section
        if (section == 0){
            UserDefaults.standard.setValue(genreCodeToDisplayString(x: foodGenreList[indexPath.row]), forKey: "genre")
        }
        else if (section == 1){
            UserDefaults.standard.setValue(genreCodeToDisplayString(x: spotGenreList[indexPath.row]), forKey: "genre")
        }
        else if (section == 2){
            UserDefaults.standard.setValue(genreCodeToDisplayString(x: shopGenreList[indexPath.row]), forKey: "genre")
        }
        dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: .didGenreChanged, object: nil)
        
        delegate?.listGenreViewControllerDidSelected()

        
        //let genreLabel = viewModels[indexPath.row].genreStr
//
//        GoogleAPIManager.shared.getShops(location: Location(lat: 35.6880488, lng: 139.702560), genre: GenreInfo(code: genreDisplayStringToCode(x: genreLabel)), radius: 50.0, size: 2, completion: {[weak self] shops in
//                print(shops.count)
//                DispatchQueue.main.async{
//                    let vc = SwipeViewController(shops: shops)
//                    self?.navigationController?.pushViewController(vc, animated: true)
//
//                }
//        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
