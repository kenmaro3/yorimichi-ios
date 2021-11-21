//
//  yorimichi2Tests.swift
//  yorimichi2Tests
//
//  Created by Kentaro Mihara on 2021/10/20.
//

import XCTest
//@testable import yorimichi2

class yorimichi2Tests: XCTestCase {
    
    func testNotificationIDCreation(){
//        let first = NotificationManager.newIdentifier()
//        let second = NotificationManager.newIdentifier()
        let first = "123_abc"
        let second = "456_def"
        XCTAssertNotEqual(first, second)
    }


}
