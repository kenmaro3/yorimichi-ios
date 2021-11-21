//
//  AnalyticsManager.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsManager{
    static let shared = AnalyticsManager()
    
    private init(){}
    
    enum FeedInteraction: String{
        case like
        case comment
        case share
        case reported
        case doubleTapToLike
    }
    
    func logFeedInteraction(_ type: FeedInteraction){
        Analytics.logEvent("Feedback_interaction", parameters: ["type": type.rawValue.lowercased()])
    }
    
}
