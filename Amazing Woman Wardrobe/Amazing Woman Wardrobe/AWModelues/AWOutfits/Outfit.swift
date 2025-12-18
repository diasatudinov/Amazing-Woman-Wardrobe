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
    
    
    var imageData: Data?
    
    var image: UIImage? {
        get {
            guard let imageData else { return nil }
            return UIImage(data: imageData)
        }
        set {
            imageData = newValue?.jpegData(compressionQuality: 0.8)
        }
    }
}

enum ItemCategory: String, CaseIterable, Codable {
    case top
    case bottom
    case footwear
    case accessories
}

enum ItemStatus: String, CaseIterable, Codable {
    case clean
    case inLaundry
}
