//
//  Extensions.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import Foundation

import UIKit

extension UIView {
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }

    func parentView<T: UIView>(type: T.Type) -> T? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let view = nextResponder as? T {
                return view
            }
            parentResponder = nextResponder
        }
    }
}

extension UIView{
    var top: CGFloat{
        frame.origin.y
    }
    
    var right: CGFloat{
        frame.origin.x + width
    }
    
    var bottom: CGFloat{
        frame.origin.y + height
    }
    
    var left: CGFloat{
        frame.origin.x
    }
    
    var width: CGFloat{
        frame.size.width
    }
    
    var height: CGFloat{
        frame.size.height
    }
}

extension Encodable {
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        let json = try? JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments
        ) as? [String: Any]
        return json
    }
}


extension Decodable{
    init?(with dictionary: [String: Any]){
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else{
            return nil
        }
        guard let result = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        
        self = result
    }
}

extension DateFormatter {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

extension String{
    static func date(from date: Date) -> String?{
        let formatter = DateFormatter.formatter
        let string = formatter.string(from: date)
        return string
    }
}

extension Notification.Name{
    static let didPostNotification = Notification.Name("didPostNotification")
    static let didLikeByAction = Notification.Name("didLikeByAction")
    static let didLikeByDoubleTap = Notification.Name("didLikeByDoubleTap")
    
    static let didGenreChanged = Notification.Name("didGenreChanged")
    static let didMethodsChanged = Notification.Name("didMethodsChanged")
    static let didSourceChanged = Notification.Name("didSourceChanged")
    
    static let didAddCandidateNotification = Notification.Name("didAddCandidateNotification")
}


extension Float {
    var double: Double{
        return Double(self)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

enum BorderPosition {
    case top
    case left
    case right
    case bottom
}

extension UIView {
    /// 特定の場所にborderをつける
    ///
    /// - Parameters:
    ///   - width: 線の幅
    ///   - color: 線の色
    ///   - position: 上下左右どこにborderをつけるか
    func addBorder(width: CGFloat, color: UIColor, position: BorderPosition) {

        let border = CALayer()

        switch position {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
            border.backgroundColor = color.cgColor
            self.layer.addSublayer(border)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
            border.backgroundColor = color.cgColor
            self.layer.addSublayer(border)
        case .right:
            print(self.frame.width)

            border.frame = CGRect(x: self.frame.width - width, y: 0, width: width, height: self.frame.height)
            border.backgroundColor = color.cgColor
            self.layer.addSublayer(border)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
            border.backgroundColor = color.cgColor
            self.layer.addSublayer(border)
        }
    }
}

class ShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = 10
//        self.clipsToBounds = true これは設定してはダメ
//        self.layer.masksToBounds = true これは設定してはダメ

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.backgroundColor = UIColor.yellow.cgColor
    }
}

extension UIColor {
    class func hex ( string : String, alpha : CGFloat) -> UIColor {
        let string_ = string.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: string_ as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            return UIColor.white;
        }
    }
}

