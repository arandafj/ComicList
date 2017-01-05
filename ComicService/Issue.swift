//
//  Issue.swift
//  ComicList
//


import Foundation

/// A comic issue
public struct Issue {

    /// Issue title
    public let title: String

    /// Cover image URL
    public let coverURL: URL?
	
	/// Initializer
	public init(title: String, coverURL: URL?) {
		self.title = title
		self.coverURL = coverURL
	}
	
}

extension Issue : JSONDecodable {
	
	public init?(dictionary: JSONDictionary) {
        
		guard let title = dictionary["name"] as? String else {
			return nil
		}
		
		self.coverURL = ((dictionary as NSDictionary)
            .value(forKeyPath: "image.small_url") as? String)
            .flatMap{ URL(string: $0) }
        
        self.title = title
	}
	
}

