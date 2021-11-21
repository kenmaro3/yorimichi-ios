//
//  SettingsModels.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/23.
//

import Foundation
import UIKit


struct SettingsSection{
    let title: String
    let options: [SettingOption]
}

struct SettingOption{
    let title: String
    let image: UIImage?
    let color: UIColor
    let handler: (() -> Void)
}
