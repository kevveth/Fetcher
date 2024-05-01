//
//  FetcherApp.swift
//  Fetcher
//
//  Created by Kenneth Oliver Rathbun on 4/27/24.
//

import SwiftUI
import SwiftData

@main
struct FetcherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
