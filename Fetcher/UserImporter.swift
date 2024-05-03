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
        
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let decoder = JSONDecoder()
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse) // Handle unsuccessful response codes
        }
        
        let decoded = try decoder.decode([User].self, from: data)
        
        for user in decoded {
            if userExists(with: user.id, in: context) == false {
                context.insert(user) // Insert only if user doesn't exist
            }
        }
    }
    
    static func userExists(with id: String, in context: ModelContext) -> Bool {
        let userDescriptor = FetchDescriptor<User>(predicate: #Predicate { $0.id == id })
        return try! !context.fetch(userDescriptor).isEmpty
    }
}
