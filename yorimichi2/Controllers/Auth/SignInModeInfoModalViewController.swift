
import UIKit

class SignInModeInfoModalViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "アカウントモードについて"
        //label.font = .systemFont(ofSize: 22)
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        return label
    }()
    
    private let featureHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "アカウントモードの特徴"
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .label
        
        return label
    }()
    
    private let restrictionHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "アカウントの制約"
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .label
        
        return label
    }()
    
    
    private let featureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = """
        アカウントモードでログインすると、プロフィールに紐つけて投稿の追加を行えます。
        投稿の閲覧時には、他のログインしているユーザ名を確認することができます。
        また、お気に入り機能やフォロー機能などを使い、他ユーザの投稿を効果的に閲覧できます。
        ぜひアカウントモードでログインしてみましょう！！
        
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
        アカウントモードでは全ての機能をお使いいただけます。
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
