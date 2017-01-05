//
//  VolumeDescription.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 08/10/2016.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

public struct VolumeDescription {
	
	public let description: String?
	
}

extension VolumeDescription: JSONDecodable {
	
	public init?(dictionary: JSONDictionary) {
		
		guard let description:String = dictionary["description"] as? String else {
			self.description = nil
			return
		}
		
		self.description = description
	}
	
}
