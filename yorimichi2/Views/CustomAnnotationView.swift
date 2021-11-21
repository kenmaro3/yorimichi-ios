//
//  CustomAnnotationView.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/30.
//

import Foundation
import Mapbox
import UIKit
import AVFoundation

//
// MGLAnnotationView subclass

class YorimichiAnnotationView: MGLAnnotationView {
    static let identifier = "YorimichiAnnotationView"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.backgroundColor = .clear
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.shadowColor = UIColor.systemYellow.cgColor
        imageView.layer.backgroundColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 6
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.5
        return imageView
        
    }()
    
    override func prepareForReuse() {
        imageView.image = nil
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(imageView)
        
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        imageView.layer.cornerRadius = width/2
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.hex(string: "#f2f2f2", alpha: 1.0).cgColor
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    public func configure(with post: Post){
        
        if post.isVideo{
            
            guard let url = URL(string: post.postThumbnailUrlString) else {
                print("cannot set to URL")
                return
            }
            
            imageView.sd_setImage(with: url, completed: {_,_,_,_ in
                guard let image = self.imageView.image else {
                    print("fell in here")
                    return
                }
                guard let resizedImage = image.sd_resizedImage(with: CGSize(width: 64, height: 64), scaleMode: .aspectFill) else{
                    print("fell in here2")
                    return
                }
                guard let roundedImage = resizedImage.sd_roundedCornerImage(withRadius:  CGFloat(64 / 2), corners: .allCorners, borderWidth: 3, borderColor: .white) else {
                    print("fell in here3")
                    return
                }
                print("seems okay")
                self.imageView.image = roundedImage
                
                
                
            })
        }
        else{
            
            guard let url = URL(string: post.postUrlString) else {
                print("cannot set to URL")
                return
            }
            
            imageView.sd_setImage(with: url, completed: {_,_,_,_ in
                guard let image = self.imageView.image else {
                    print("fell in here")
                    return
                }
                guard let resizedImage = image.sd_resizedImage(with: CGSize(width: 64, height: 64), scaleMode: .aspectFill) else{
                    print("fell in here2")
                    return
                }
                guard let roundedImage = resizedImage.sd_roundedCornerImage(withRadius:  CGFloat(64 / 2), corners: .allCorners, borderWidth: 3, borderColor: .white) else {
                    print("fell in here3")
                    return
                }
                print("seems okay")
                self.imageView.image = roundedImage
                
                
                
            })
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? 3 : 2
        layer.borderColor = selected ? UIColor.hex(string: "#ffbc98", alpha: 1.0).cgColor : UIColor.white.cgColor
        layer.add(animation, forKey: "borderWidth")
    }
}

class HPAnnotationView: MGLAnnotationView {
    static let identifier = "HPAnnotationView"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "test")
        imageView.image = image
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.shadowColor = UIColor.systemYellow.cgColor
        imageView.layer.shadowRadius = 6
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.5
        return imageView
        
    }()
    
    override func prepareForReuse() {
        imageView.image = nil
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(imageView)
        
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        imageView.layer.cornerRadius = width/2
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.hex(string: "#f2f2f2", alpha: 1.0).cgColor
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    public func configure(with imageUrl: String){
        guard let url = URL(string: imageUrl) else {
            print("cannot set to URL")
            return
        }
        
        imageView.sd_setImage(with: url, completed: {_,_,_,_ in
            guard let image = self.imageView.image else {
                print("fell in here")
                return
            }
            guard let resizedImage = image.sd_resizedImage(with: CGSize(width: 64, height: 64), scaleMode: .aspectFill) else{
                print("fell in here2")
                return
            }
            guard let roundedImage = resizedImage.sd_roundedCornerImage(withRadius:  CGFloat(64 / 2), corners: .allCorners, borderWidth: 3, borderColor: .white) else {
                print("fell in here3")
                return
            }
            print("seems okay")
            self.imageView.image = roundedImage
            
            
            
        })
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? 3 : 2
        layer.borderColor = selected ? UIColor.hex(string: "#ffbc98", alpha: 1.0).cgColor : UIColor.white.cgColor
        layer.add(animation, forKey: "borderWidth")
    }
}

class GoogleAnnotationView: MGLAnnotationView {
    static let identifier = "GoogleAnnotationView"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "test")
        imageView.image = image
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.shadowColor = UIColor.systemYellow.cgColor
        imageView.layer.shadowRadius = 6
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.5
        return imageView
        
    }()
    
    override func prepareForReuse() {
        imageView.image = nil
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(imageView)
        
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        imageView.layer.cornerRadius = width/2
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.hex(string: "#f2f2f2", alpha: 1.0).cgColor
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    public func configure(with image: UIImage){
        
        guard let resizedImage = image.sd_resizedImage(with: CGSize(width: 64, height: 64), scaleMode: .aspectFill) else{
            print("fell in here2")
            return
        }
        guard let roundedImage = resizedImage.sd_roundedCornerImage(withRadius:  CGFloat(64 / 2), corners: .allCorners, borderWidth: 3, borderColor: .white) else {
            print("fell in here3")
            return
        }
        print("seems okay")
        self.imageView.image = roundedImage
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? 3 : 2
        layer.borderColor = selected ? UIColor.hex(string: "#ffbc98", alpha: 1.0).cgColor : UIColor.white.cgColor
        layer.add(animation, forKey: "borderWidth")
    }
}


class DestinationAnnotationView: MGLAnnotationView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "flag.fill", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 14))
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 1
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.5
        imageView.image = image
        return imageView
        
    }()

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(imageView)
        
        imageView.frame = CGRect(x: width/4, y: height/4, width: width/2, height: height/2)
        imageView.layer.cornerRadius = width/2
        imageView.tintColor = .systemBlue
        
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.hex(string: "#f2f2f2", alpha: 1.0).cgColor
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? 3 : 2
        layer.borderColor = selected ? UIColor.hex(string: "#ffbc98", alpha: 1.0).cgColor : UIColor.white.cgColor
        layer.add(animation, forKey: "borderWidth")
    }
}

class LikesAnnotationView: MGLAnnotationView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "heart.fill", withConfiguration:  UIImage.SymbolConfiguration(pointSize: 14))
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 2
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.5
        imageView.image = image
        return imageView
        
    }()

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(imageView)
        
        imageView.frame = CGRect(x: width*0.2, y: height*0.2, width: width*0.6, height: height*0.6)
        imageView.layer.cornerRadius = (width*0.6)/2
        imageView.tintColor = .systemRed
        
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.hex(string: "#f2f2f2", alpha: 1.0).cgColor
        layer.borderColor = UIColor.white.cgColor
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? 3 : 2
        layer.borderColor = selected ? UIColor.hex(string: "#ffbc98", alpha: 1.0).cgColor : UIColor.white.cgColor
        layer.add(animation, forKey: "borderWidth")
    }
}

class SelectedAnnotationView: MGLAnnotationView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "logo")
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 6
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.5
        return imageView
        
    }()

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(imageView)
        
        imageView.frame = CGRect(x: width*0.15, y: height*0.15, width: width*0.7, height: height*0.7)
        imageView.layer.cornerRadius = (width*0.7)/2
        imageView.tintColor = .systemBlue
        
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.hex(string: "#f2f2f2", alpha: 1.0).cgColor
        layer.borderColor = UIColor.white.cgColor
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? 3 : 2
        layer.borderColor = selected ? UIColor.hex(string: "#ffbc98", alpha: 1.0).cgColor : UIColor.white.cgColor
        layer.add(animation, forKey: "borderWidth")
    }
}

class CurrentLocationAnnotationView: MGLAnnotationView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "standing_man")
        imageView.image = image
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 2
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.5
        
        return imageView
        
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(imageView)
        
        imageView.frame = CGRect(x: width*0.1, y: height*0.1, width: width*0.8, height: height*0.8)
        imageView.layer.cornerRadius = width*0.8/2
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.hex(string: "#f2f2f2", alpha: 1.0).cgColor
        layer.borderColor = UIColor.white.cgColor
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? 3 : 2
        layer.borderColor = selected ? UIColor.hex(string: "#ffbc98", alpha: 1.0).cgColor : UIColor.white.cgColor
        layer.add(animation, forKey: "borderWidth")
    }
}
