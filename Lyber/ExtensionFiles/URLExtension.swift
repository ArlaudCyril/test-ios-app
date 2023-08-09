//
//  URLExtension.swift
//  Lyber
//
//  Created by Lyber on 04/08/2023.
//

import Foundation

extension URL {
	var queryParameters: [String: String]? {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
			  let queryItems = components.queryItems else {
			return nil
		}
		return queryItems.reduce(into: [String: String]()) { result, item in
			result[item.name] = item.value
		}
	}
}
