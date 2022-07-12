
import UIKit

class GhostModeInfoModalViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "ゴーストモードについて"
        //label.font = .systemFont(ofSize: 22)
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        return label
    }()
    
    private let featureHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "ゴーストモードの特徴"
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .label
        
        return label
    }()
    
    private let restrictionHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "ゴーストモードの制約"
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .label
        
        return label
    }()
    
    
    private let featureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = """
        ゴーストモードでログインすると、匿名で投稿の閲覧、投稿の追加を行えます。
        投稿をすると「名無しさん」として投稿されます。
        匿名でこのアプリを使いたいとき、匿名で投稿したいときはゴーストモードを使ってみましょう！
        
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
        ゴーストモードでは、他のユーザ情報や、投稿がどのユーザから行われた情報をみることはできません。
        また、お気に入り機能の使用もできません。
        
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
