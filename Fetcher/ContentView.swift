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
    enum UserFilter: String, CaseIterable {
        case all = "All"
        case active = "Active"
        case offline = "Offline"
        
        var predicate: Predicate<User> {
            switch self {
            case .all:
                return #Predicate<User> { _ in true }
            case .active:
                return #Predicate<User> { $0.isActive == true }
            case .offline:
                return #Predicate<User> { $0.isActive == false }
            }
        }
    }
    
    @State private var userFilter: UserFilter = .all
    @State private var sortOrder: [SortDescriptor<User>] = []
    
    var fetchDescriptor: FetchDescriptor<User> {
        let descriptor = FetchDescriptor(
            predicate: userFilter.predicate,
            sortBy: sortOrder
        )
        
        return descriptor
    }
    
    @State private var showingDeleteAllConfirmation = false
    
    var body: some View {
        NavigationStack {
            UsersView(fetch: fetchDescriptor)
                .navigationDestination(for: User.self) { user in
                    DetailView(user: user)
                }
                .navigationTitle("Fetcher")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button("Delete All", systemImage: "trash") {
                            showingDeleteAllConfirmation = true
                        }
                        .tint(.red)
                        .alert("Delete All", isPresented: $showingDeleteAllConfirmation) {
                            Button("Delete", role: .destructive) {
                                do {
                                    try modelContext.delete(model: User.self, where: #Predicate<User> { _ in true })
                                } catch {
                                    print("Failed to delete models: \(error.localizedDescription)")
                                }
                            }
                            
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("Are you sure you want to delete all of your models?")
                        }
                        
                        Button("Refresh", systemImage: "arrow.clockwise.circle") {
                            Task {
                                try await UserImporter.fetchData(context: modelContext)
                            }
                        }
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Menu("Filter Users", systemImage: "line.3.horizontal.decrease.circle") {
                            Picker("Filter Users", selection: $userFilter) {
                                ForEach(UserFilter.allCases, id: \.self) { filter in
                                    Text(filter.rawValue)
                                        .tag(filter)
                                }
                            }
                        }
                        
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort", selection: $sortOrder) {
                                Text("By Name")
                                    .tag([
                                        SortDescriptor(\User.name)
                                    ])
                                Text("Activity")
                                    .tag([
                                        SortDescriptor(\User.isActive, order: .reverse)
                                    ])
                            }
                        }
                    }
                }
        }
    }
}

extension Bool: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        !lhs && rhs
    }
}

#Preview {
    //    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    //    let container = try! ModelContainer(for: User.self, configurations: config)
    //    return
    ContentView()
        .modelContainer(for: User.self)
}
