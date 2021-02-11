//
//  sharedHelpers.swift
//  Tests
//
//  Created by Ilhan Sari on 11.02.2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import FeedStoreChallenge

extension XCTestCase {
	func testSpecificStoreURL() -> URL {
		return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
	}
	
	func cachesDirectory() -> URL {
		return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
	}
	
	func deleteStoreArtifacts() {
		try? FileManager.default.removeItem(at: testSpecificStoreURL())
	}
}
