//
//  RecordButton.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/06.
//

import UIKit
import SwiftyCam

class RecordButton: SwiftyCamButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = nil
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = height/2
    }
    
    enum State{
        case recording
        case notRecording
    }
    
    public func toggle(for state: State){
        switch state{
        case .recording:
            backgroundColor = .systemRed
        case .notRecording:
            backgroundColor = nil
        }
        
    }
    
    
    
}
