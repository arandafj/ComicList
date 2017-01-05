//
//  Client.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 08/10/2016.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import HTTPFetcher
import RxSwift

private let baseURL = URL(string: "http://www.comicvine.com/api")!
private let key = "78d108db78f0c97b51e3903f6d5853bd934ef1e7"

public enum ClientError:Error {
	case couldNotDecodeJSON
	case badStatus(Int, String)
}

public final class Client {
	
	private let fetcher: HTTPFetcher
	
	public init(fetcher: HTTPFetcher = URLSession(configuration: .default)) {
		self.fetcher = fetcher
	}
	
	public func object<T: JSONDecodable>(forResource resource: Resource) -> Observable<T> {
        
            return response(forRecouce: resource).map { response in
			guard let result: T = response.result() else {
				throw ClientError.couldNotDecodeJSON
			}
            
			return result
		}
	}
	
	public func objects<T: JSONDecodable>(forResource resource: Resource) -> Observable<[T]> {
        
		return response(forRecouce: resource).map { response in
			guard let results: [T] = response.results() else {
				throw ClientError.couldNotDecodeJSON
			}
			return results
		}
	}
	
	private func response(forRecouce resource: Resource) -> Observable<Response> {
        
		let request = resource.request(withBaseURL: baseURL, additionalParameters: ["api_key":key])
		return fetcher.data(request: request).map { data in
			guard let response: Response = decode(data) else {
				throw ClientError.couldNotDecodeJSON
			}
			guard response.succedded else {
				throw ClientError.badStatus(response.status, response.message)
			}
			return response
		}
	}
	
}
