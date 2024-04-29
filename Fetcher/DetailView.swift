//
//  DetailView.swift
//  Fetcher
//
//  Created by Kenneth Oliver Rathbun on 4/27/24.
//

import SwiftUI

struct DetailView: View {
    var user: User
    
    var body: some View {
        Form {
            Section("Name") { Text(user.name) }
            Section("Age") { Text(String(user.age)) }
            
            Section("Company") {
                Text(user.company)
                Text(user.about)
            }
            
            Section("Friends") {
                ForEach(user.friends) { friend in
                    HStack {
                        Text(friend.name)
                    }
                }
            }
        }
        .navigationTitle("\(user.name)")
    }
}

#Preview {
    DetailView(user: User.sampleUser)
}
