//
//  SwipeViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/25.
//

//import UIKit
//import Koloda

//class SwipeViewController: UIViewController {
//    
//    private var shops: [Shop] = []
//    
//    private var kolodaView: KolodaView = {
//        let view = KolodaView()
//        view.backgroundColor = .systemRed
//        return view
//        
//    }()
//    
//
//    private let rightButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("right", for: .normal)
//        button.setTitleColor(.label, for: .normal)
//        button.layer.cornerRadius = 8
//        button.layer.masksToBounds = true
//        button.backgroundColor = .systemBlue
//        
//        return button
//    }()
//    
//    private let nowButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("now", for: .normal)
//        button.setTitleColor(.label, for: .normal)
//        button.layer.cornerRadius = 8
//        button.layer.masksToBounds = true
//        button.backgroundColor = .systemBlue
//        
//        return button
//    }()
//    
//    private let leftButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("left", for: .normal)
//        button.setTitleColor(.label, for: .normal)
//        button.layer.cornerRadius = 8
//        button.layer.masksToBounds = true
//        button.backgroundColor = .systemBlue
//        
//        return button
//    }()
//    
//    
//    // MARK: Init
//    
//    init(shops: [Shop]){
//        self.shops = shops
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        print("here")
//        print(shops.count)
//        
//        view.backgroundColor = .systemBackground
//        title = "Yorimichi Swipe"
//        
//        view.addSubview(kolodaView)
//        view.addSubview(rightButton)
//        view.addSubview(leftButton)
//        view.addSubview(nowButton)
//        
//        // kolodaViewのためのデリゲート、必須
//        kolodaView.dataSource = self
//        kolodaView.delegate = self
//        
//        kolodaView.reloadData()
//
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        kolodaView.frame = CGRect(x: 20, y: view.safeAreaInsets.bottom+20, width: 400, height: 500)
//        
////        rightButton.sizeToFit()
////        rightButton.frame = CGRect(x: 0, y: 100, width: rightButton.width, height: rightButton.height)
////        leftButton.sizeToFit()
////        leftButton.frame = CGRect(x: 0, y: 130, width: leftButton.width, height: leftButton.height)
////        nowButton.sizeToFit()
////        nowButton.frame = CGRect(x: 0, y: 160, width: nowButton.width, height: nowButton.height)
//        
//        
//    }
//    
//}
//
//
//extension SwipeViewController: KolodaViewDataSource, KolodaViewDelegate{
//    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
//        return shops.count
//    }
//    
//    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
//        return .fast
//    }
//    
//    //表示内容
//    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
//        print("koloda view called here==================")
//        var imageView = UIImageView(frame: koloda.bounds)
//
//        imageView.contentMode = .scaleAspectFill
//        let uiImage = shops[index].photo.image
//        print("\n===========")
//        print(shops[index])
//        print(shops[index].photo)
//        uiImage.layer.cornerRadius = 18
//        uiImage.layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
//        uiImage.layer.shadowColor = UIColor.black.cgColor
//        uiImage.layer.shadowOpacity = 0.6
//        uiImage.contentMode = .scaleToFill
//
//        koloda.addSubview(uiImage)
//        imageView.backgroundColor = .systemOrange
//        
//        
////        //グラデーションをつける
////        let gradientLayer = CAGradientLayer()
////        gradientLayer.frame.size = self.kolodaView.bounds.size
////
////        //グラデーションさせるカラーの設定
////        //今回は、徐々に色を濃くしていく
////        //CAGradientLayerにグラデーションさせるカラーをセット
////        gradientLayer.colors = [
////            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0).cgColor,
////            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1).cgColor,
////            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1).cgColor
////        ]
////        gradientLayer.locations = [
////            0.6,
////            0.8,
////            1.0
////        ]
////
////        //グラデーションの開始地点・終了地点の設定
////
////        imageView.layer.addSublayer(gradientLayer)
////        let textView = UITextView(frame: kolodaView.frame)
////        textView.text = shops[index].shop
////        textView.font = UIFont.systemFont(ofSize: 20, weight: .bold)
////        textView.center = CGPoint(x: (kolodaView.frame.maxX - kolodaView.frame.minX)/2.0, y: kolodaView.frame.maxY + 10)
////
////        textView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0);
////
////        imageView.layer.addSublayer(gradientLayer)
////        let textInfoView = UITextView(frame: kolodaView.frame)
////        textInfoView.text = "情報: \(shops[index].info)"
////        textInfoView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
////        textInfoView.center = CGPoint(x: (kolodaView.frame.maxX - kolodaView.frame.minX)/2.0, y: kolodaView.frame.maxY + 55)
////
////        imageView.layer.addSublayer(gradientLayer)
////        let textDistanceView = UITextView(frame: kolodaView.frame)
////        textDistanceView.text = "現在地からの距離: \(String(Int(shops[index].distance))) m"
////        textDistanceView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
////        textDistanceView.center = CGPoint(x: (kolodaView.frame.maxX - kolodaView.frame.minX)/2.0, y: kolodaView.frame.maxY + 55 + 40)
////
////        textInfoView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0);
////        textDistanceView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0);
////        imageView.addSubview(textView)
////        imageView.addSubview(textInfoView)
////        imageView.addSubview(textDistanceView)
//        return imageView
//    }
//    
//    // カードを全て消費したときの処理を定義する
//    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        print("Finish cards.")
//        
//
//    }
//    
//    //カードをタップした時に呼ばれる
//    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        print("TAPPED")
////        let modalVC = self.storyboard?.instantiateViewController(identifier: "modal") as! ModalViewController?
////        modalVC!.modalPresentationStyle = .custom
////        modalVC!.transitioningDelegate = self
////        modalVC!.shop = self.yori.yoriArray[index]
////        present(modalVC!, animated: true, completion: nil)
//
//    }
//
//    //dragやめたら呼ばれる
//   func kolodaDidResetCard(_ koloda: KolodaView) {
//       print("reset")
//   }
//    //darag中に呼ばれる
//    func koloda(_ koloda: KolodaView, shouldDragCardAt index: Int) -> Bool {
//        print(index, "drag")
//        return true
//    }
//    
//    //dtagの方向によって行うプログラムはここに書く。
//    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
//        print(index, direction)
//        if direction == .right{
//            print("liked")
////            yori.select(idx: index)
////            var swipeInfo = SwipeInfo(userId: self.userUid, shopId: self.yori.yoriArray[index].id, searchType: self.yori.yoriArray[index].type, action: "right")
////            addSwipe(swipeInfo: swipeInfo)
//        }else if (direction == .left){
//            print("not liked")
////            var swipeInfo = SwipeInfo(userId: self.userUid, shopId: self.yori.yoriArray[index].id, searchType: self.yori.yoriArray[index].type, action: "left")
////            addSwipe(swipeInfo: swipeInfo)
//        }
//    }
//    
//    // フリックできる方向を指定する
//    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
//        return [.left, .right]
//    }
//
//    
//}
