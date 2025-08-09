//
//  ChickenBreed.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 09.08.2025.
//

import Foundation

// MARK: - ChickenBreed Data Model
struct ChickenBreed: Codable, Identifiable {
    let id = UUID()
    let name: String
    let origin: String?
    let purpose: String // "eggs", "meat", "dual-purpose", "exhibition"
    let eggsPerYear: Int?
    let eggSize: String? // "small", "medium", "large"
    let eggColor: String?
    let size: String // "small", "medium", "large"
    let description: String
    let characteristics: [String]
    let isAPARecognized: Bool
    let combType: String // "single", "rose", "pea", "v-shaped", etc.
    let imageURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, origin, purpose, description, characteristics, combType, imageURL
        case eggsPerYear = "eggs_per_year"
        case eggSize = "egg_size"
        case eggColor = "egg_color"
        case size
        case isAPARecognized = "is_apa_recognized"
    }
}

// MARK: - Sample Data for Offline Use
extension ChickenBreed {
    static let sampleBreeds: [ChickenBreed] = [
        ChickenBreed(
            name: "Rhode Island Red",
            origin: "United States",
            purpose: "dual-purpose",
            eggsPerYear: 250,
            eggSize: "large",
            eggColor: "brown",
            size: "large",
            description: "The Rhode Island Red is a popular dual-purpose breed known for its hardiness and excellent egg production. They are friendly, docile birds that make great additions to any backyard flock.",
            characteristics: ["Hardy", "Good foragers", "Cold-tolerant", "Friendly temperament"],
            isAPARecognized: true,
            combType: "single",
            imageURL: "https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400&h=300&fit=crop"
        ),
        ChickenBreed(
            name: "Leghorn",
            origin: "Italy",
            purpose: "eggs",
            eggsPerYear: 320,
            eggSize: "large",
            eggColor: "white",
            size: "medium",
            description: "Leghorns are excellent white egg layers known for their efficiency and high production. They are active, flighty birds that prefer to free-range.",
            characteristics: ["Excellent egg layers", "Active", "Heat tolerant", "Good foragers"],
            isAPARecognized: true,
            combType: "single",
            imageURL: "https://images.unsplash.com/photo-1612170153139-6f881ff067e0?w=400&h=300&fit=crop"
        ),
        ChickenBreed(
            name: "Buff Orpington",
            origin: "England",
            purpose: "dual-purpose",
            eggsPerYear: 180,
            eggSize: "large",
            eggColor: "brown",
            size: "large",
            description: "Buff Orpingtons are gentle, docile birds perfect for families. They are excellent mothers and make great pets due to their calm nature.",
            characteristics: ["Docile", "Good mothers", "Cold-hardy", "Beautiful golden color"],
            isAPARecognized: true,
            combType: "single",
            imageURL: "https://images.unsplash.com/photo-1605174725302-1531e5e6a7da?w=400&h=300&fit=crop"
        ),
        ChickenBreed(
            name: "Ameraucana",
            origin: "United States",
            purpose: "eggs",
            eggsPerYear: 200,
            eggSize: "medium",
            eggColor: "blue",
            size: "medium",
            description: "Ameraucanas are known for their beautiful blue eggs and distinctive appearance with muffs and beards. They are friendly and make great backyard chickens.",
            characteristics: ["Blue eggs", "Muffs and beard", "Cold-hardy", "Friendly"],
            isAPARecognized: true,
            combType: "pea",
            imageURL: "https://images.unsplash.com/photo-1594736797933-d0301ba2fe65?w=400&h=300&fit=crop"
        ),
        ChickenBreed(
            name: "Silkie",
            origin: "China",
            purpose: "exhibition",
            eggsPerYear: 100,
            eggSize: "small",
            eggColor: "cream",
            size: "small",
            description: "Silkies are unique ornamental chickens with fluffy, silk-like feathers. They are excellent mothers and very docile, making them popular pets.",
            characteristics: ["Fluffy feathers", "Black skin", "Five toes", "Excellent mothers"],
            isAPARecognized: true,
            combType: "walnut",
            imageURL: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop"
        ),
        ChickenBreed(
            name: "Plymouth Rock",
            origin: "United States",
            purpose: "dual-purpose",
            eggsPerYear: 200,
            eggSize: "large",
            eggColor: "brown",
            size: "large",
            description: "Plymouth Rocks are hardy, reliable birds excellent for beginners. They have distinctive barred plumage and are good layers and meat birds.",
            characteristics: ["Barred plumage", "Hardy", "Good for beginners", "Reliable layers"],
            isAPARecognized: true,
            combType: "single",
            imageURL: "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&h=300&fit=crop"
        ),
        ChickenBreed(
            name: "Marans",
            origin: "France",
            purpose: "dual-purpose",
            eggsPerYear: 150,
            eggSize: "large",
            eggColor: "dark brown",
            size: "large",
            description: "Marans are famous for their chocolate-colored eggs. They are active foragers with beautiful plumage and make excellent dual-purpose birds.",
            characteristics: ["Dark chocolate eggs", "Active foragers", "Beautiful plumage", "Good meat birds"],
            isAPARecognized: true,
            combType: "single",
            imageURL: "https://images.unsplash.com/photo-1519434026276-6c59a0b3b95b?w=400&h=300&fit=crop"
        ),
        ChickenBreed(
            name: "Wyandotte",
            origin: "United States",
            purpose: "dual-purpose",
            eggsPerYear: 200,
            eggSize: "large",
            eggColor: "brown",
            size: "large",
            description: "Wyandottes are beautiful, cold-hardy birds with rose combs. They come in many color varieties and are excellent for colder climates.",
            characteristics: ["Rose comb", "Cold-hardy", "Many color varieties", "Docile temperament"],
            isAPARecognized: true,
            combType: "rose",
            imageURL: "https://images.unsplash.com/photo-1553603227-2358aabe821e?w=400&h=300&fit=crop"
        ),
        ChickenBreed(
            name: "Australorp",
            origin: "Australia",
            purpose: "dual-purpose",
            eggsPerYear: 300,
            eggSize: "large",
            eggColor: "brown",
            size: "large",
            description: "Australorps are excellent layers known for their record-breaking egg production. They are calm, friendly birds with beautiful black plumage.",
            characteristics: ["Record egg production", "Calm temperament", "Black plumage", "Hardy"],
            isAPARecognized: true,
            combType: "single",
            imageURL: "https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=400&h=300&fit=crop"
        ),
        ChickenBreed(
            name: "Brahma",
            origin: "United States",
            purpose: "dual-purpose",
            eggsPerYear: 150,
            eggSize: "large",
            eggColor: "brown",
            size: "large",
            description: "Brahmas are gentle giants with feathered feet. They are excellent winter layers and have a calm, docile temperament perfect for families.",
            characteristics: ["Feathered feet", "Gentle giants", "Winter layers", "Calm temperament"],
            isAPARecognized: true,
            combType: "pea",
            imageURL: "https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400&h=300&fit=crop"
        )
    ]
}