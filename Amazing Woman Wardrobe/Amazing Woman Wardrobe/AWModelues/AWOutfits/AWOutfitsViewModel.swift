//
//  AWOutfitsViewModel.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

final class AWOutfitsViewModel: ObservableObject {
    @Published var outfits: [Outfit] = [] {
        didSet {
            saveOutfits()
        }
    }
    @Published var outfitItems: [Item] = [] {
        didSet {
            saveOutfitItems()
        }
    }
    
    // MARK: – UserDefaults keys
    private var outfitsFileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("outfits.json")
    }
    private var outfitItemsFileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("outfitItems.json")
    }
    
    // MARK: – Init
    init() {
        loadOutfits()
        loadOutfitItems()
    }
    
    // MARK: – Save / Load Outfits
    
    private func saveOutfits() {
        let url = outfitsFileURL
        do {
            let data = try JSONEncoder().encode(outfits)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save myDives:", error)
        }
    }
    
    private func loadOutfits() {
        let url = outfitsFileURL
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let outfitsData = try JSONDecoder().decode([Outfit].self, from: data)
            outfits = outfitsData
        } catch {
            print("Failed to load myDives:", error)
        }
    }
    
    // MARK: – Save / Load OutfitsItems
    
    private func saveOutfitItems() {
        let url = outfitItemsFileURL
        do {
            let data = try JSONEncoder().encode(outfitItems)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save myDives:", error)
        }
    }
    
    private func loadOutfitItems() {
        let url = outfitItemsFileURL
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let itemsData = try JSONDecoder().decode([Item].self, from: data)
            outfitItems = itemsData
        } catch {
            print("Failed to load myDives:", error)
        }
    }
    
    // MARK: – Example buy action
    func add(outfit: Outfit) {
        guard !outfits.contains(outfit) else { return }
        outfits.append(outfit)
        
    }
    
    func delete(outfit: Outfit) {
        guard let index = outfits.firstIndex(of: outfit) else { return }
        outfits.remove(at: index)
    }
    
    // MARK: – Example buy action
    func add(item: Item) {
        guard !outfitItems.contains(item) else { return }
        outfitItems.append(item)
        
    }
    
    func delete(item: Item) {
        guard let index = outfitItems.firstIndex(of: item) else { return }
        outfitItems.remove(at: index)
    }
}
