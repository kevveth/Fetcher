//
//  User.swift
//  Fetcher
//
//  Created by Kenneth Oliver Rathbun on 4/30/24.
//

import Foundation
import SwiftData

@Model
final class User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case isActive
        case name
        case age
        case company
        case about
        case registrationDate = "registered"
        case friends
    }
    
    var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var about: String
    var registrationDate: Date
    @Relationship var friends: [Friend]
    
    static var sampleUser: User = User(id: "0000001", isActive: true, name: "Kenneth Rathbun", age: 28, company: "Better Buzz Coffee Roasters", about: "Makin' Coffee for the people.", registrationDate: Date.now, friends: [Friend(id: "0000002", name: "Friend Lee")])
    
    init(id: String, isActive: Bool, name: String, age: Int, company: String, about: String, registrationDate: Date, friends: [Friend]) {
        self.id = id
        self.isActive = isActive
        self.name = name
        self.age = age
        self.company = company
        self.about = about
        self.registrationDate = registrationDate
        self.friends = friends
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.isActive = try container.decode(Bool.self, forKey: .isActive)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decode(Int.self, forKey: .age)
        self.company = try container.decode(String.self, forKey: .company)
        self.about = try container.decode(String.self, forKey: .about)
        
        let stringRegistrationDate = try container.decode(String.self, forKey: .registrationDate)
        self.registrationDate = try Date(stringRegistrationDate, strategy: .iso8601)
        
        self.friends = try container.decode([Friend].self, forKey: .friends)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.isActive, forKey: .isActive)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.age, forKey: .age)
        try container.encode(self.company, forKey: .company)
        try container.encode(self.about, forKey: .about)
        try container.encode(self.registrationDate.ISO8601Format(), forKey: .registrationDate)
        try container.encode(self.friends, forKey: .friends)
        
    }
}

@Model
final class Friend: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
//        case user
    }
    
    var id: String
    let name: String
//    var user: User?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
//        self.user = try container.decodeIfPresent(User.self, forKey: .user)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
//        try container.encodeIfPresent(self.user, forKey: .user)
    }
}
