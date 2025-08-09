//
//  ChickenHealth.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 09.08.2025.
//

import Foundation

// MARK: - Disease Severity
enum DiseaseSeverity: String, CaseIterable, Codable {
    case mild = "mild"
    case moderate = "moderate"
    case severe = "severe"
    case fatal = "fatal"
    
    var displayName: String {
        switch self {
        case .mild: return "Mild"
        case .moderate: return "Moderate"
        case .severe: return "Severe"
        case .fatal: return "Fatal"
        }
    }
    
    var color: String {
        switch self {
        case .mild: return "greenApp"
        case .moderate: return "yellowApp"
        case .severe: return "orange"
        case .fatal: return "redApp"
        }
    }
}

// MARK: - Disease Category
enum DiseaseCategory: String, CaseIterable, Codable {
    case respiratory = "respiratory"
    case digestive = "digestive"
    case parasitic = "parasitic"
    case viral = "viral"
    case bacterial = "bacterial"
    case nutritional = "nutritional"
    case reproductive = "reproductive"
    case skin = "skin"
    case infectious = "infectious"
    case traumatic = "traumatic"
    
    var displayName: String {
        switch self {
        case .respiratory: return "Respiratory"
        case .digestive: return "Digestive"
        case .parasitic: return "Parasitic"
        case .viral: return "Viral"
        case .bacterial: return "Bacterial"
        case .nutritional: return "Nutritional"
        case .reproductive: return "Reproductive"
        case .skin: return "Skin & Feathers"
        case .infectious: return "Infectious"
        case .traumatic: return "Traumatic"
        }
    }
    
    var icon: String {
        switch self {
        case .respiratory: return "wind"
        case .digestive: return "circle.fill"
        case .parasitic: return "ant.fill"
        case .viral: return "cross.circle.fill"
        case .bacterial: return "circle.dotted"
        case .nutritional: return "leaf.fill"
        case .reproductive: return "heart.fill"
        case .skin: return "hand.raised.fill"
        case .infectious: return "exclamationmark.triangle.fill"
        case .traumatic: return "bandage.fill"
        }
    }
}

// MARK: - Chicken Disease Model
struct ChickenDisease: Codable, Identifiable {
    let id = UUID()
    let name: String
    let category: DiseaseCategory
    let severity: DiseaseSeverity
    let description: String
    let symptoms: [String]
    let causes: [String]
    let treatment: [String]
    let prevention: [String]
    let contagious: Bool
    let reportable: Bool
    let affectedAge: String // "all ages", "chicks", "adults", "laying hens"
    let recoveryTime: String?
    let mortality: String?
    let imageURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, category, severity, description, symptoms, causes, treatment, prevention
        case contagious, reportable, recoveryTime, mortality, imageURL
        case affectedAge = "affected_age"
    }
}

// MARK: - Vaccination Model
struct ChickenVaccination: Codable, Identifiable {
    let id = UUID()
    let name: String
    let disease: String
    let ageToVaccinate: String
    let method: String // "water", "injection", "spray", "in ovo"
    let frequency: String
    let mandatory: Bool
    let description: String
    let sideEffects: [String]
    let cost: String?
}

// MARK: - Sample Health Data
extension ChickenDisease {
    static let sampleDiseases: [ChickenDisease] = [
        ChickenDisease(
            name: "Marek's Disease",
            category: .viral,
            severity: .fatal,
            description: "Marek's disease is a highly contagious viral disease that affects chickens worldwide. It's caused by the Marek's disease virus (MDV) and can cause tumors, paralysis, and death.",
            symptoms: [
                "Paralysis of legs, wings, or neck",
                "Loss of weight",
                "Irregular pupils",
                "Grey iris or blindness",
                "Skin tumors",
                "Death without clinical signs"
            ],
            causes: [
                "Marek's disease virus (MDV)",
                "Airborne transmission",
                "Contaminated dust and dander",
                "Direct contact with infected birds"
            ],
            treatment: [
                "No treatment available",
                "Supportive care only",
                "Isolate affected birds",
                "Maintain good nutrition",
                "Prevent secondary infections"
            ],
            prevention: [
                "Vaccination at day 1 of age",
                "Good biosecurity measures",
                "Avoid overcrowding",
                "Proper ventilation",
                "Regular cleaning and disinfection"
            ],
            contagious: true,
            reportable: false,
            affectedAge: "3-20 weeks",
            recoveryTime: "No recovery",
            mortality: "Up to 80%",
            imageURL: "https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400&h=300&fit=crop"
        ),
        
        ChickenDisease(
            name: "Newcastle Disease",
            category: .viral,
            severity: .fatal,
            description: "Newcastle disease is a highly contagious viral infection that affects many bird species. It can cause severe respiratory, nervous, and digestive symptoms.",
            symptoms: [
                "Gasping and coughing",
                "Nasal discharge",
                "Swelling around eyes and neck",
                "Greenish diarrhea",
                "Nervous signs (tremors, twisted neck)",
                "Drop in egg production"
            ],
            causes: [
                "Newcastle disease virus (NDV)",
                "Airborne transmission",
                "Contaminated feed and water",
                "Wild birds"
            ],
            treatment: [
                "No specific treatment",
                "Supportive care",
                "Antibiotics for secondary infections",
                "Isolation of affected birds"
            ],
            prevention: [
                "Vaccination program",
                "Quarantine new birds",
                "Limit access to wild birds",
                "Disinfection protocols"
            ],
            contagious: true,
            reportable: true,
            affectedAge: "All ages",
            recoveryTime: "2-4 weeks if survives",
            mortality: "10-90%",
            imageURL: "https://images.unsplash.com/photo-1612170153139-6f881ff067e0?w=400&h=300&fit=crop"
        ),
        
        ChickenDisease(
            name: "Coccidiosis",
            category: .parasitic,
            severity: .severe,
            description: "Coccidiosis is a parasitic disease caused by protozoa that damages the intestinal lining. It's especially dangerous in young chickens.",
            symptoms: [
                "Bloody diarrhea",
                "Weakness and lethargy",
                "Loss of appetite",
                "Ruffled feathers",
                "Dehydration",
                "Poor weight gain"
            ],
            causes: [
                "Eimeria species (parasites)",
                "Contaminated environment",
                "Wet, dirty conditions",
                "Stress factors"
            ],
            treatment: [
                "Anticoccidial medications",
                "Amprolium treatment",
                "Supportive fluids",
                "Clean, dry environment"
            ],
            prevention: [
                "Medicated starter feed",
                "Clean water systems",
                "Dry bedding",
                "Good ventilation",
                "Gradual immunity building"
            ],
            contagious: true,
            reportable: false,
            affectedAge: "3-6 weeks",
            recoveryTime: "1-2 weeks",
            mortality: "10-50%",
            imageURL: "https://images.unsplash.com/photo-1605174725302-1531e5e6a7da?w=400&h=300&fit=crop"
        ),
        
        ChickenDisease(
            name: "Bumblefoot",
            category: .bacterial,
            severity: .moderate,
            description: "Bumblefoot is a bacterial infection of the foot, usually caused by a cut or puncture wound that becomes infected with Staphylococcus bacteria.",
            symptoms: [
                "Swollen foot pad",
                "Black scab on bottom of foot",
                "Limping or favoring one foot",
                "Heat and redness in foot",
                "Hard core in center of swelling"
            ],
            causes: [
                "Staphylococcus aureus bacteria",
                "Cuts or puncture wounds",
                "Rough perches",
                "Dirty, wet conditions",
                "Heavy birds jumping from heights"
            ],
            treatment: [
                "Surgical removal of core",
                "Antibiotic treatment",
                "Epsom salt soaks",
                "Bandaging",
                "Pain management"
            ],
            prevention: [
                "Smooth, clean perches",
                "Dry, clean environment",
                "Avoid sharp objects",
                "Proper perch height",
                "Regular foot inspections"
            ],
            contagious: false,
            reportable: false,
            affectedAge: "Adults",
            recoveryTime: "2-4 weeks",
            mortality: "Low with treatment",
            imageURL: "https://images.unsplash.com/photo-1594736797933-d0301ba2fe65?w=400&h=300&fit=crop"
        ),
        
        ChickenDisease(
            name: "Avian Influenza",
            category: .viral,
            severity: .fatal,
            description: "Avian influenza is a highly contagious viral disease that can affect chickens and other birds. Some strains can be transmitted to humans.",
            symptoms: [
                "Sudden death",
                "Respiratory distress",
                "Swollen head and neck",
                "Purple discoloration of wattles",
                "Drop in egg production",
                "Nervous system signs"
            ],
            causes: [
                "Influenza A virus",
                "Wild bird migration",
                "Contaminated equipment",
                "Human transmission"
            ],
            treatment: [
                "No treatment available",
                "Quarantine and culling",
                "Supportive care only",
                "Government intervention"
            ],
            prevention: [
                "Biosecurity measures",
                "Limit wild bird contact",
                "Disinfection protocols",
                "Quarantine new birds",
                "Report suspicious deaths"
            ],
            contagious: true,
            reportable: true,
            affectedAge: "All ages",
            recoveryTime: "Usually fatal",
            mortality: "Up to 100%",
            imageURL: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop"
        ),
        
        ChickenDisease(
            name: "Egg Binding",
            category: .reproductive,
            severity: .severe,
            description: "Egg binding occurs when a hen is unable to expel an egg from her reproductive tract. This is a medical emergency requiring immediate attention.",
            symptoms: [
                "Straining to lay egg",
                "Sitting on nest for extended periods",
                "Tail pumping motion",
                "Lethargy and weakness",
                "Loss of appetite",
                "Visible egg in vent"
            ],
            causes: [
                "Large or malformed eggs",
                "Calcium deficiency",
                "Stress",
                "Young or old hens",
                "Genetics",
                "Poor nutrition"
            ],
            treatment: [
                "Warm water bath",
                "Lubrication with oil",
                "Gentle massage",
                "Calcium supplementation",
                "Veterinary assistance",
                "Possible egg removal"
            ],
            prevention: [
                "Proper nutrition",
                "Adequate calcium",
                "Reduce stress",
                "Good lighting schedule",
                "Regular health checks"
            ],
            contagious: false,
            reportable: false,
            affectedAge: "Laying hens",
            recoveryTime: "24-48 hours",
            mortality: "High without treatment",
            imageURL: "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&h=300&fit=crop"
        ),
        
        ChickenDisease(
            name: "Fowl Pox",
            category: .viral,
            severity: .moderate,
            description: "Fowl pox is a viral disease that causes skin lesions and can affect the respiratory system. It spreads slowly and recovery provides immunity.",
            symptoms: [
                "Raised, wart-like lesions on comb and wattles",
                "Scabs on unfeathered areas",
                "Reduced egg production",
                "Respiratory symptoms (wet pox)",
                "Eye discharge",
                "Difficulty eating"
            ],
            causes: [
                "Fowl pox virus",
                "Mosquito transmission",
                "Direct contact",
                "Contaminated surfaces"
            ],
            treatment: [
                "No specific treatment",
                "Supportive care",
                "Prevent secondary infections",
                "Vitamin A supplementation",
                "Isolation of affected birds"
            ],
            prevention: [
                "Vaccination",
                "Mosquito control",
                "Good sanitation",
                "Quarantine new birds"
            ],
            contagious: true,
            reportable: false,
            affectedAge: "All ages",
            recoveryTime: "3-5 weeks",
            mortality: "Low (5-10%)",
            imageURL: "https://images.unsplash.com/photo-1519434026276-6c59a0b3b95b?w=400&h=300&fit=crop"
        ),
        
        ChickenDisease(
            name: "Respiratory Disease (CRD)",
            category: .respiratory,
            severity: .moderate,
            description: "Chronic Respiratory Disease is caused by Mycoplasma bacteria and affects the respiratory system, causing ongoing breathing problems.",
            symptoms: [
                "Coughing and sneezing",
                "Nasal discharge",
                "Swollen sinuses",
                "Reduced activity",
                "Poor growth",
                "Drop in egg production"
            ],
            causes: [
                "Mycoplasma gallisepticum",
                "Stress factors",
                "Poor ventilation",
                "Overcrowding",
                "Temperature fluctuations"
            ],
            treatment: [
                "Antibiotics (tylosin, erythromycin)",
                "Improved ventilation",
                "Stress reduction",
                "Supportive care"
            ],
            prevention: [
                "Good ventilation",
                "Reduce stress",
                "Avoid overcrowding",
                "Quarantine new birds",
                "Clean environment"
            ],
            contagious: true,
            reportable: false,
            affectedAge: "All ages",
            recoveryTime: "2-4 weeks",
            mortality: "Low with treatment",
            imageURL: "https://images.unsplash.com/photo-1553603227-2358aabe821e?w=400&h=300&fit=crop"
        ),
        
        ChickenDisease(
            name: "Vitamin A Deficiency",
            category: .nutritional,
            severity: .moderate,
            description: "Vitamin A deficiency affects the immune system and can cause respiratory and eye problems. It's common in chickens fed mainly corn-based diets.",
            symptoms: [
                "Eye discharge and swelling",
                "Respiratory infections",
                "Poor feather quality",
                "Reduced egg production",
                "White spots in mouth",
                "Poor growth in chicks"
            ],
            causes: [
                "Inadequate vitamin A in diet",
                "Poor quality feed",
                "Storage of feed too long",
                "Lack of green vegetables"
            ],
            treatment: [
                "Vitamin A supplementation",
                "Improved diet",
                "Fresh greens",
                "High-quality feed"
            ],
            prevention: [
                "Balanced commercial feed",
                "Fresh vegetables",
                "Proper feed storage",
                "Regular diet evaluation"
            ],
            contagious: false,
            reportable: false,
            affectedAge: "All ages",
            recoveryTime: "2-3 weeks",
            mortality: "Low",
            imageURL: "https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=400&h=300&fit=crop"
        ),
        
        ChickenDisease(
            name: "Scaly Leg Mites",
            category: .parasitic,
            severity: .mild,
            description: "Scaly leg mites burrow under the scales on chickens' legs and feet, causing them to lift and become crusty and deformed.",
            symptoms: [
                "Raised, crusty scales on legs",
                "Thickened, deformed legs",
                "White, crusty deposits",
                "Limping or lameness",
                "Itching and discomfort"
            ],
            causes: [
                "Knemidocoptes mutans mites",
                "Direct contact with infected birds",
                "Contaminated environment",
                "Poor sanitation"
            ],
            treatment: [
                "Petroleum jelly application",
                "Ivermectin treatment",
                "Soaking in warm soapy water",
                "Leg mite sprays"
            ],
            prevention: [
                "Regular leg inspections",
                "Good coop hygiene",
                "Quarantine new birds",
                "Avoid overcrowding"
            ],
            contagious: true,
            reportable: false,
            affectedAge: "Adults",
            recoveryTime: "4-8 weeks",
            mortality: "Very low",
            imageURL: "https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400&h=300&fit=crop"
        )
    ]
}

// MARK: - Sample Vaccination Data
extension ChickenVaccination {
    static let sampleVaccinations: [ChickenVaccination] = [
        ChickenVaccination(
            name: "Marek's Disease Vaccine",
            disease: "Marek's Disease",
            ageToVaccinate: "Day 1 (in hatchery)",
            method: "Injection (subcutaneous)",
            frequency: "Single dose",
            mandatory: true,
            description: "Essential vaccination that provides lifelong immunity against Marek's disease. Must be given before exposure to the virus.",
            sideEffects: ["Mild swelling at injection site", "Temporary lethargy"],
            cost: "$0.10-$0.25 per dose"
        ),
        
        ChickenVaccination(
            name: "Newcastle Disease Vaccine",
            disease: "Newcastle Disease",
            ageToVaccinate: "14-21 days, then 8-10 weeks",
            method: "Water or spray",
            frequency: "Initial + booster",
            mandatory: false,
            description: "Protects against Newcastle disease. Timing depends on maternal antibody levels and local disease pressure.",
            sideEffects: ["Mild respiratory signs", "Temporary egg drop"],
            cost: "$0.05-$0.15 per dose"
        ),
        
        ChickenVaccination(
            name: "Fowl Pox Vaccine",
            disease: "Fowl Pox",
            ageToVaccinate: "12-16 weeks",
            method: "Wing web puncture",
            frequency: "Single dose",
            mandatory: false,
            description: "Live vaccine that provides immunity against fowl pox. Should not be given to laying hens.",
            sideEffects: ["Small scab at vaccination site", "Temporary egg production drop"],
            cost: "$0.08-$0.20 per dose"
        ),
        
        ChickenVaccination(
            name: "Infectious Bronchitis Vaccine",
            disease: "Infectious Bronchitis",
            ageToVaccinate: "1-7 days, booster at 4-6 weeks",
            method: "Spray or water",
            frequency: "Primary + booster",
            mandatory: false,
            description: "Protects against respiratory disease. Multiple strains available depending on local prevalence.",
            sideEffects: ["Mild respiratory symptoms", "Temporary coughing"],
            cost: "$0.06-$0.12 per dose"
        ),
        
        ChickenVaccination(
            name: "Infectious Bursal Disease Vaccine",
            disease: "Gumboro Disease",
            ageToVaccinate: "14-21 days",
            method: "Water",
            frequency: "Single dose or series",
            mandatory: false,
            description: "Protects the immune system from IBD virus. Critical for maintaining overall health.",
            sideEffects: ["Mild depression", "Temporary reduced appetite"],
            cost: "$0.04-$0.10 per dose"
        )
    ]
}