//
//  SavedQueriesRepository.swift
//  Sero
//
//  Created on 14/6/2024.
//

import Foundation

struct SavedQueriesRepository {
    func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let url = urls.first else {
            fatalError("couldn't find documents directory")
        }
        
        return url.appendingPathComponent("saved_queries.json")
    }
    
    func saveQuery(withSearch search: Search, filter: SearchFilter) throws {
        var savedQueries = loadSavedQueries()
        savedQueries.append(Query(search: search, filter: filter))
        writeSavedQueries(savedQueries)
    }
    
    func delete(atOffsets offsets: IndexSet) {
        var savedQueries = loadSavedQueries()
        savedQueries.remove(atOffsets: offsets)
        writeSavedQueries(savedQueries)
    }
    
    func loadSavedQueries() -> [Query] {
        let fileURL = fileURL()
        
        if false == FileManager.default.fileExists(atPath: fileURL.path) {
            return []
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode([Query].self, from: data)
        } catch {
            return []
        }
    }
    
    private func writeSavedQueries(_ savedQueries: [Query]) {
        let fileURL = fileURL()
        
        do {
            let jsonData = try JSONEncoder().encode(savedQueries)
            try jsonData.write(to: fileURL)
        } catch {
            print("Error writing to JSON file: \(error)")
        }
    }
}
