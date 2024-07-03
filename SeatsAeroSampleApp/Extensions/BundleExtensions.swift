//
//  BundleExtensions.swift
//  Sero
//
//  Created on 17/6/2024.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) throws -> T {
        let url = self.url(forResource: file, withExtension: nil)
        guard let url = url else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return try JSONDecoder().decode(T.self, from: data)
    }
}
