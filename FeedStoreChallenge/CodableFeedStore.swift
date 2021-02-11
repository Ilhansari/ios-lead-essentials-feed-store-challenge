//
//  InMemoryFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Ilhan Sari on 11.02.2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public class CodableFeedStore: FeedStore {
	
	private struct CodableFeed: Codable {
		let feed: [CodableImage]
		let timestamp: Date
		
		var localFeed: [LocalFeedImage] {
			return feed.map { $0.local }
		}
	}
		
	private struct CodableImage: Codable {
		private let id: UUID
		private let description: String?
		private let location: String?
		private let url: URL
		
		init(_ image: LocalFeedImage) {
			self.id = image.id
			self.description = image.description
			self.location = image.location
			self.url = image.url
		}
		
		var local: LocalFeedImage {
			return LocalFeedImage(id: id, description: description, location: location, url: url)
		}
	}
	
	private let queue = DispatchQueue(label: "\(CodableFeedStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
	private let storeURL: URL
	
	public init(storeURL: URL) {
		self.storeURL = storeURL
	}
	
	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		let storeURL = self.storeURL
		queue.async(flags: .barrier) {
			guard FileManager.default.fileExists(atPath: storeURL.path) else {
				return completion(nil)
			}
			do {
				try FileManager.default.removeItem(at: storeURL)
				completion(nil)
			} catch {
				completion(error)
			}
		}

	}
	
	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		let storeURL = self.storeURL
		queue.async(flags: .barrier) {
			do {
				let encoder = JSONEncoder()
				let cache = CodableFeed(feed: feed.map(CodableImage.init), timestamp: timestamp)
				let encoded = try encoder.encode(cache)
				try encoded.write(to: storeURL)
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}
	
	public func retrieve(completion: @escaping RetrievalCompletion) {
		let storeURL = self.storeURL
		queue.async {
			guard let data = try? Data(contentsOf: storeURL) else {
				return completion(.empty)
			}
			do {
				let decoder = JSONDecoder()
				let cache = try decoder.decode(CodableFeed.self, from: data)
				completion(.found(feed: cache.localFeed , timestamp: cache.timestamp))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
}
