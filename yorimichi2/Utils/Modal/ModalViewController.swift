

import UIKit
//import SemiModal

final class ModalViewController: UIViewController {

//    @IBOutlet private weak var contentView: UIView!
    private var contentView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .systemBlue
        myView.frame = CGRect(x: 0, y: 0, width: 300, height: 600)
        return myView
        
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        contentView.frame = CGRect(x: 100, y: 0, width: 200, height: 500)
//    }
    
    
}

//extension ModalViewController {
//
//    static func instantiateInitialViewControllerFromStoryboard() -> Self {
//        return UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
//            .instantiateInitialViewController() as! Self
//    }
//}

extension ModalViewController: SemiModalPresenterDelegate {

    var semiModalContentHeight: CGFloat {
        print("\n\n+++++++++")
        print(contentView.frame.height)
        print(contentView.top)
        print(contentView.left)
        //return 200
        
        return contentView.frame.height
    }
}
