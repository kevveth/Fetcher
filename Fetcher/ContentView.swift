//
//  ContentView.swift
//  Fetcher
//
//  Created by Kenneth Oliver Rathbun on 4/27/24.
//

import SwiftUI

struct User: Codable, Hashable, Identifiable {
    struct Friend: Codable, Hashable, Identifiable {
        let id: String
        let name: String
    }
    
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let about: String
    let friends: [Friend]
}

@Observable
class Users {
    var users: [User] = []
}

struct ContentView: View {
    @State var users = Users()
    let url = "https://www.hackingwithswift.com/samples/friendface.json"
    
    @State var selectedUserCategory = [User]()
    
    var allUsers: [User] { users.users }
    var activeUsers: [User] { users.users.filter { $0.isActive } }
    var inactiveUsers: [User] { users.users.filter { !$0.isActive } }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(selectedUserCategory) { user in
                    HStack {
                        Text(user.isActive ? "🟢" : "🔴")
                            .font(.subheadline)
                        Text(user.name)
                    }
                }
            }
            .navigationTitle("Fetcher")
            .toolbar {
                ToolbarItem {
                    Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                        // More code to come...
                        Picker("Filter", selection: $selectedUserCategory) {
                            Text("All").tag(allUsers)
                            Text("Active").tag(activeUsers)
                            Text("Inactive").tag(inactiveUsers)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                users.users = await fetchUsers(from: url)
                selectedUserCategory = allUsers
            }
        }
    }
    
    func fetchUsers(from url: String) async -> [User] {
        // Get the URL
        let url = URL(string: url)!
        // Make a request to the url's server
        var request = URLRequest(url: url)
        // Specify the GET method for reading data
        request.httpMethod = "GET"
        
        var users: [User] = []
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedUsers = try JSONDecoder().decode([User].self, from: data)
            
            users = decodedUsers
            
        } catch {
            print("Failed to fetch users: \(error.localizedDescription)")
        }
        
        
        return users
    }
}

#Preview {
    ContentView()
}
