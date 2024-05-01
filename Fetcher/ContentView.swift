//
//  ContentView.swift
//  Fetcher
//
//  Created by Kenneth Oliver Rathbun on 4/27/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query() var users: [User]
    
    var allUsers = #Predicate<User> { _ in true }
    var activeUsers = #Predicate<User> { user in user.isActive == true}
    var offlineUsers = #Predicate<User> { user in user.isActive == false}
    
    var onImage = Image(systemName: "lightswitch.on")
    var offImage = Image(systemName: "lightswitch.on")
    
    var body: some View {
        NavigationStack {
            Text("Number of users: \(users.count)")
            List {
                ForEach(users) { user in
                    NavigationLink(value: user) {
                        if user.isActive {
                            onImage
                                .font(.subheadline)
                                .foregroundStyle(.green)

                        } else {
                            offImage
                                .font(.subheadline)
                                .foregroundStyle(.red)
                        }
                        Text(user.name)
                    }
                }
            }
            .navigationTitle("Fetcher")
            .navigationDestination(for: User.self) { user in
                DetailView(user: user)
            }
            .task {
                do {
                    let url = "https://www.hackingwithswift.com/samples/friendface.json"
                    
                    try await UserImporter.fetchData(from: url, context: modelContext)
                } catch {
                    print("Failed to import data: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: User.self)
}
