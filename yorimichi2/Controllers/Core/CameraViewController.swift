//
//  CameraViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import AVFoundation
import UIKit
import SwiftyCam

class CameraViewController: SwiftyCamViewController{
    
    
//    private let shutterButton: SwiftyCamButton = {
//        let button = SwiftyCamButton()
//        button.layer.masksToBounds = true
//        button.layer.borderWidth = 2
//        button.layer.borderColor = UIColor.label.cgColor
//        button.backgroundColor = nil
//        return button
//
//    }()
    private let recordButton = RecordButton()
    
    private var recordedVideoUrl: URL?
    // Capture Preview
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    private var previewLayer: AVPlayerLayer?
    private var playerDidFinishObserver: NSObjectProtocol?
    
    private let photoPickerButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32)), for: .normal)
        return button
    }()
    
    private let changeCameraButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "repeat", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32)), for: .normal)
        return button
    }()
    
    private let changeFlashButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "bolt.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32)), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let flashLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.tintColor = .white
        label.text = "Flash OFF"
        return label
        
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
        
        setUpButtons()
        setUpNavBar()
        setUpCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpButtons()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let layer = previewLayer{
            layer.removeFromSuperlayer()
            recordButton.isHidden = false
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
    }
    @objc private func didTapClose(){
        tabBarController?.selectedIndex = 2
        tabBarController?.tabBar.isHidden = false
    }

    
    private func setUpButtons(){
        recordButton.delegate = self
        view.addSubview(recordButton)
        view.addSubview(photoPickerButton)
        view.addSubview(changeCameraButton)
        view.addSubview(changeFlashButton)
        view.bringSubviewToFront(recordButton)
        view.bringSubviewToFront(photoPickerButton)
        view.bringSubviewToFront(changeFlashButton)
        view.bringSubviewToFront(changeCameraButton)
        
        
        photoPickerButton.addTarget(self, action: #selector(didTapPickPhoto), for: .touchUpInside)
        changeCameraButton.addTarget(self, action: #selector(didTapChangeCamera), for: .touchUpInside)
        changeFlashButton.addTarget(self, action: #selector(didTapChangeFlash), for: .touchUpInside)
    }
    
    @objc private func didTapChangeCamera(){
        switchCamera()
        
    }
    
    @objc private func didTapChangeFlash(){
        flashEnabled = !flashEnabled
        if (flashEnabled){
            UIView.animate(withDuration: 0.2){[weak self] in
                self?.changeFlashButton.tintColor = .systemOrange
            }
        }
        else{
            UIView.animate(withDuration: 0.2){[weak self] in
                self?.changeFlashButton.tintColor = .white
            }
        }
        
    }
    
    
    private func setUpCamera(){
        maximumVideoDuration = 5.0
        allowBackgroundAudio = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let buttonSize: CGFloat = view.width/5
        recordButton.frame = CGRect(x: (view.width-buttonSize)/2, y: view.safeAreaInsets.top + view.width+100, width: buttonSize, height: buttonSize)
        photoPickerButton.frame = CGRect(x: view.width/5-buttonSize/4, y: recordButton.top + (buttonSize/2)/2, width: buttonSize/2, height: buttonSize/2)
        recordButton.layer.cornerRadius = buttonSize/2
        
        changeCameraButton.frame = CGRect(x: view.width*4/5-buttonSize/4, y: recordButton.top + (buttonSize/2)/2, width: buttonSize/2, height: buttonSize/2)
        changeFlashButton.frame = CGRect(x: view.center.x - buttonSize/6, y: view.safeAreaInsets.top+10, width: buttonSize/3, height: buttonSize/3)
    }
    
    
    @objc func didTapPickPhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    private func setUpNavBar(){
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
}


extension CameraViewController: SwiftyCamViewControllerDelegate{
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        print("took photo")

        showEditPhoto(image: photo)
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        print("finished recording")
        recordedVideoUrl = url
        

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))
        
        
        print("finished recording to url: \(url.absoluteString)")
        let player = AVPlayer(url: url)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.bounds
        
        guard let previewLayer = previewLayer else {
            return
        }
        
        recordButton.isHidden = true
        view.layer.addSublayer(previewLayer)
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
    
    @objc private func didTapNext(){
        // push to caption controller
        guard let url = recordedVideoUrl else {
            return
        }
        if UserDefaults.standard.bool(forKey: "save_video"){
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
        }
//        let vc = VideoCaptionViewController(videoUrl: url)
        let vc = PhotoEditInfoViewController()
        vc.createVideoViewModels(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        recordButton.toggle(for: .notRecording)
    }

    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        recordButton.toggle(for: .recording)
    }
}


extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
           return
            
        }
        
        showEditPhoto(image: image)
    }
    

    
    
}


extension CameraViewController{
    func showEditPhoto(image: UIImage){
        guard let resizedImage = image.sd_resizedImage(with: CGSize(width: 640, height: 640), scaleMode: .aspectFill) else{
            return
        }
        if UserDefaults.standard.bool(forKey: "save_photo"){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil
            )
        }
        
//        let vc = PostEditFilterViewController(image: resizedImage)
        let vc = PhotoEditInfoViewController()
        vc.createPhotoViewModels(image: resizedImage)
        vc.navigationItem.backButtonDisplayMode = .minimal
        navigationController?.pushViewController(vc, animated: true)
    }
}
