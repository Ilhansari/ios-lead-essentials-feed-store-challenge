//
//  InMemoryFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Ilhan Sari on 11.02.2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public class InMemoryFeedStore: FeedStore {
	
	private struct InMemoryFeedModel {
		let feed: [LocalFeedImage]
		let timestamp: Date
	}
	
	private var storeFeedModel: InMemoryFeedModel?
	
	public init() { }
	
	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		storeFeedModel = nil
		completion(nil)
	}
	
	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		storeFeedModel = InMemoryFeedModel(feed: feed, timestamp: timestamp)
		completion(nil)
	}
	
	public func retrieve(completion: @escaping RetrievalCompletion) {
		guard let model = storeFeedModel else {
			return completion(.empty)
		}
		completion(.found(feed: model.feed, timestamp: model.timestamp))
	}
	
}
