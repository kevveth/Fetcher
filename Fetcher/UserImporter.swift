//
//  JSONDataImporter.swift
//  Fetcher
//
//  Created by Kenneth Oliver Rathbun on 4/30/24.
//

import Foundation
import SwiftData

@MainActor
struct UserImporter {
    static func fetchData(context: ModelContext) async throws {
        let url: String = "https://www.hackingwithswift.com/samples/friendface.json"

        var userDescriptor = FetchDescriptor<User>()
        userDescriptor.fetchLimit = 1
        
        let persistedUsers = try context.fetch(userDescriptor)
        
        if persistedUsers.isEmpty {
            guard let url = URL(string: url) else {
                throw URLError(.badURL)
            }
            
            
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let decoder = JSONDecoder()
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoded = try decoder.decode([User].self, from: data)
            
            if !decoded.isEmpty {
                decoded.forEach { context.insert($0) }
            }
        }
    }
}
