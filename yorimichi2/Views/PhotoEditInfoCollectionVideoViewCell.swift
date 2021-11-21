//
//  PhotoEditInfoCollectionVideoViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/11.
//

import AVFoundation
import Foundation
import UIKit

class PhotoEditInfoCollectionVideoViewCell: UICollectionViewListCell {
   static let identifier = "PhotoEditInfoCollectionVideoViewCell"
    
    // Capture Preview
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    private var previewLayer: AVPlayerLayer?
    private var playerDidFinishObserver: NSObjectProtocol?
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(imageView)
        self.addBorder(width: 0.5, color: UIColor.secondarySystemBackground, position: .bottom)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        frame = contentView.bounds
        let imageSize: CGFloat = 100
        let imagePadding: CGFloat = 5
        previewLayer?.frame = CGRect(x: (contentView.width-imageSize)/2, y: (contentView.height-imageSize)/2 + imagePadding, width: imageSize, height: imageSize - imagePadding*2)
        
    }
    
    public func configure(url: URL){
        print(url)
        let player = AVPlayer(url: url)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspect
        //previewLayer?.frame = contentView.bounds
        
        guard let previewLayer = previewLayer else {
            return
        }
        
        contentView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
        
        self.playerDidFinishObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main,
            using: { _ in
                player.seek(to: .zero)
                player.play()
                
            })
    }
    
    
}
