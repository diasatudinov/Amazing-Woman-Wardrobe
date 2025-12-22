//
//  Outfit.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

struct Outfit: Codable, Equatable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var clothes: [Item]
}

struct Item: Codable, Equatable, Hashable {
    var id = UUID()
    var name: String
    var category: ItemCategory
    var status: ItemStatus
    
    var imageFileName: String?
    var imageVersion: Int = 0
}

struct Event: Codable, Equatable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var date: Date
    var type: EventType
    var outfit: Outfit?
}

enum EventType: String, CaseIterable, Codable {
    case wedding = "Wedding"
    case meeting = "Business meeting"
    case party = "Party"
    case other = "Other"
}

enum ItemCategory: String, CaseIterable, Codable {
    case top = "Top"
    case bottom = "Bottom"
    case footwear = "Footwear"
    case accessories = "Accessories"
    
    
}

enum ItemStatus: String, CaseIterable, Codable {
    case clean
    case inLaundry
    
    var text: String {
        switch self {
        case .clean:
                "Clean"
        case .inLaundry:
                "In laundry"
        }
    }
    
    var image: ImageResource {
        switch self {
        case .clean:
                .cleanIconAW
        case .inLaundry:
                .inLaundryIconAW
        }
    }
}
