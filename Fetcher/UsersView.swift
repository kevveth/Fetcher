//
//  UsersView.swift
//  Fetcher
//
//  Created by Kenneth Oliver Rathbun on 5/1/24.
//

import SwiftUI
import SwiftData

struct UsersView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]
    
    init(fetch descriptor: FetchDescriptor<User>) {
        _users = Query(descriptor)
    }
    
    let onImage = Image(systemName: "lightswitch.on")
    let offImage = Image(systemName: "lightswitch.on")
    
    var body: some View {
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
        .task {
            do {
                try await UserImporter.fetchData(context: modelContext)
            } catch {
                print("Failed to import data: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: config)
        
        let descriptor = FetchDescriptor<User>()
        
        return UsersView(fetch: descriptor)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
