
import UIKit

class LocationInfoModalViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "投稿の場所指定について"
        //label.font = .systemFont(ofSize: 22)
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        return label
    }()
    
    private let featureHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "名称からの検索"
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .label
        
        return label
    }()
    
    private let restrictionHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "マップ上で直接手入力"
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .label
        
        return label
    }()
    
    
    private let featureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = """
        投稿時の位置情報の紐付けは必須となっています。
        名称を検索して選択することで、投稿に位置情報を紐つけることができます。
        他のユーザに場所を教えてあげましょう！
        """
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        
        return label
    }()
    
    private let restrictionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = """
        もしあなたのヨリミチが地図では検索できないあなただけの場所の時、
        マップ上で位置を手入力でピン付することができます。
        （例）河川敷で見れる景色　など
        細かい場所を共有したいときはぜひ使ってみましょう！
        """
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(featureHeader)
        view.addSubview(restrictionHeader)
        view.addSubview(featureLabel)
        view.addSubview(restrictionLabel)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 20, y: 20, width: view.width-70, height: titleLabel.height)
        
        var infoContentLeftPadding: CGFloat = 30
        
        featureHeader.sizeToFit()
        featureHeader.frame = CGRect(x: infoContentLeftPadding, y: titleLabel.bottom+30, width: view.width-70, height: featureHeader.height)
        
        featureLabel.sizeToFit()
        featureLabel.frame = CGRect(x: infoContentLeftPadding, y: featureHeader.bottom+10, width: view.width-70, height: featureLabel.height)
        

        restrictionHeader.sizeToFit()
        restrictionHeader.frame = CGRect(x: infoContentLeftPadding, y: featureLabel.bottom+20, width: view.width-70, height: restrictionHeader.height)
        
        restrictionLabel.sizeToFit()
        restrictionLabel.frame = CGRect(x: infoContentLeftPadding, y: restrictionHeader.bottom+10, width: view.width-70, height: restrictionLabel.height)
        
    }

}
