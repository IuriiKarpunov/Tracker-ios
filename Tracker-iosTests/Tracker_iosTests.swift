//
//  Tracker_iosTests.swift
//  Tracker-iosTests
//
//  Created by Iurii on 01.12.23.
//

import XCTest
import SnapshotTesting
@testable import Tracker_ios

final class TrackerIosTests: XCTestCase {
    
    func testViewControllerDark() {
        let vc = TrackersViewController()
        
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    func testTrackersViewControllerLight() {
        let vc = TrackersViewController()
        
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
}
