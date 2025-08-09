//
//  HandBookView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 09.08.2025.
//

import SwiftUI

struct HandBookView: View {
    @StateObject private var apiService = ChickenAPIService()
    @StateObject private var healthService = HealthAPIService()
    @State private var searchText = ""
    @State private var selectedPurpose = "all"
    @State private var selectedBreed: ChickenBreed?
    @State private var selectedSection = 0 // 0 = Breeds, 1 = Health
    
    private let purposes = ["all", "eggs", "meat", "dual-purpose", "exhibition"]
    
    private var filteredBreeds: [ChickenBreed] {
        let purposeFiltered = apiService.filterBreeds(by: selectedPurpose)
        return apiService.searchBreeds(query: searchText).filter { breed in
            selectedPurpose == "all" || breed.purpose == selectedPurpose
        }
    }
    
    var body: some View {
        
            ZStack {
                 BackgroundView()
                VStack(spacing: 0) {
                    // Section picker
                    Picker("Section", selection: $selectedSection) {
                        Text("Breeds").tag(0)
                        Text("Health").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    if selectedSection == 0 {
                        breedsSection
                    } else {
                        healthSection
                    }
                }
                .navigationTitle("Handbook")
                .navigationBarTitleDisplayMode(.large)
                .task {
                    await apiService.fetchBreeds()
                    await healthService.fetchHealthData()
                }
            }
        
        .sheet(item: $selectedBreed) { breed in
            BreedDetailView(breed: breed)
        }
    }
    
    // MARK: - Breeds Section
    private var breedsSection: some View {
        VStack(spacing: 0) {
            // Header with search and filter
            VStack(spacing: 12) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search chicken breeds...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                // Purpose filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(purposes, id: \.self) { purpose in
                            Button(action: {
                                selectedPurpose = purpose
                            }) {
                                Text(purposeDisplayName(purpose))
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        selectedPurpose == purpose ?
                                        Color("yellowApp") : Color.gray.opacity(0.2)
                                    )
                                    .foregroundColor(
                                        selectedPurpose == purpose ? .white : .primary
                                    )
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
            .background(Color("grayApp").opacity(0.1))
            
            // Breeds list
            if apiService.isLoading {
                Spacer()
                ProgressView("Loading breeds...")
                    .scaleEffect(1.2)
                Spacer()
            } else if filteredBreeds.isEmpty && !searchText.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No breeds found")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("Try changing your search criteria")
                        .foregroundColor(.gray)
                }
                Spacer()
            } else {
                List(filteredBreeds) { breed in
                    BreedRowView(breed: breed) {
                        selectedBreed = breed
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
        }
    }
    
    // MARK: - Health Section
    private var healthSection: some View {
        HealthSectionView(healthService: healthService)
    }
    
    private func purposeDisplayName(_ purpose: String) -> String {
        switch purpose {
        case "all": return "All"
        case "eggs": return "Egg Layers"
        case "meat": return "Meat"
        case "dual-purpose": return "Dual Purpose"
        case "exhibition": return "Exhibition"
        default: return purpose
        }
    }
}

// MARK: - Breed Row View
struct BreedRowView: View {
    let breed: ChickenBreed
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Breed image
                AsyncImage(url: URL(string: breed.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(12)
                } placeholder: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("yellowApp").opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "bird.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color("yellowApp"))
                        ProgressView()
                    }
                }
                
                // Breed info
                VStack(alignment: .leading, spacing: 6) {
                    Text(breed.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    if let origin = breed.origin {
                        Text("Origin: \(origin)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label(purposeDisplayName(breed.purpose), systemImage: purposeIcon(breed.purpose))
                            .font(.caption)
                            .foregroundColor(Color("yellowApp"))
                        
                        Spacer()
                        
                        if let eggsPerYear = breed.eggsPerYear {
                            Label("\(eggsPerYear)/year", systemImage: "circle.fill")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                    
                    if let eggColor = breed.eggColor {
                        Text("Egg color: \(eggColorDisplayName(eggColor))")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.6))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func purposeDisplayName(_ purpose: String) -> String {
        switch purpose {
        case "eggs": return "Egg Layers"
        case "meat": return "Meat"
        case "dual-purpose": return "Dual Purpose"
        case "exhibition": return "Exhibition"
        default: return purpose
        }
    }
    
    private func purposeIcon(_ purpose: String) -> String {
        switch purpose {
        case "eggs": return "oval.fill"
        case "meat": return "house.fill"
        case "dual-purpose": return "star.fill"
        case "exhibition": return "crown.fill"
        default: return "circle.fill"
        }
    }
    
    private func eggColorDisplayName(_ color: String) -> String {
        switch color {
        case "white": return "White"
        case "brown": return "Brown"
        case "blue": return "Blue"
        case "cream": return "Cream"
        case "dark brown": return "Dark Brown"
        default: return color
        }
    }
}

// MARK: - Breed Detail View
struct BreedDetailView: View {
    let breed: ChickenBreed
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header image
                    AsyncImage(url: URL(string: breed.imageURL ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(16)
                        case .failure(_):
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("yellowApp").opacity(0.2))
                                    .frame(height: 200)
                                
                                VStack(spacing: 8) {
                                    Image(systemName: "bird.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(Color("yellowApp"))
                                    
                                    Text("Image not available")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        case .empty:
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("yellowApp").opacity(0.2))
                                    .frame(height: 200)
                                
                                VStack(spacing: 8) {
                                    ProgressView()
                                        .scaleEffect(1.2)
                                    
                                    Text("Loading image...")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        @unknown default:
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("yellowApp").opacity(0.2))
                                    .frame(height: 200)
                                
                                Image(systemName: "bird.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(Color("yellowApp"))
                            }
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Basic info
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Basic Information")
                                .font(.headline)
                                .foregroundColor(Color("yellowApp"))
                            
                            InfohelpRow(title: "Origin", value: breed.origin ?? "Unknown")
                            InfohelpRow(title: "Purpose", value: purposeDisplayName(breed.purpose))
                            InfohelpRow(title: "Size", value: sizeDisplayName(breed.size))
                            InfohelpRow(title: "Comb Type", value: combDisplayName(breed.combType))
                            InfohelpRow(title: "APA Recognized", value: breed.isAPARecognized ? "Yes" : "No")
                        }
                        
                        Divider()
                        
                        // Egg production
                        if breed.purpose == "eggs" || breed.purpose == "dual-purpose" {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Egg Production")
                                    .font(.headline)
                                    .foregroundColor(Color("yellowApp"))
                                
                                if let eggsPerYear = breed.eggsPerYear {
                                    InfohelpRow(title: "Eggs per Year", value: "\(eggsPerYear)")
                                }
                                
                                if let eggSize = breed.eggSize {
                                    InfohelpRow(title: "Egg Size", value: eggSizeDisplayName(eggSize))
                                }
                                
                                if let eggColor = breed.eggColor {
                                    InfohelpRow(title: "Egg Color", value: eggColorDisplayName(eggColor))
                                }
                            }
                            
                            Divider()
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(Color("yellowApp"))
                            
                            Text(breed.description)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                        
                        // Characteristics
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Characteristics")
                                .font(.headline)
                                .foregroundColor(Color("yellowApp"))
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 8) {
                                ForEach(breed.characteristics, id: \.self) { characteristic in
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Color("greenApp"))
                                            .font(.caption)
                                        
                                        Text(characteristic)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.1))
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(breed.name)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color("yellowApp"))
                }
            }
        }
    }
    
    private func purposeDisplayName(_ purpose: String) -> String {
        switch purpose {
        case "eggs": return "Egg Layers"
        case "meat": return "Meat"
        case "dual-purpose": return "Dual Purpose"
        case "exhibition": return "Exhibition"
        default: return purpose
        }
    }
    
    private func sizeDisplayName(_ size: String) -> String {
        switch size {
        case "small": return "Small"
        case "medium": return "Medium"
        case "large": return "Large"
        default: return size
        }
    }
    
    private func combDisplayName(_ combType: String) -> String {
        switch combType {
        case "single": return "Single"
        case "rose": return "Rose"
        case "pea": return "Pea"
        case "v-shaped": return "V-shaped"
        case "walnut": return "Walnut"
        default: return combType
        }
    }
    
    private func eggSizeDisplayName(_ size: String) -> String {
        switch size {
        case "small": return "Small"
        case "medium": return "Medium"
        case "large": return "Large"
        default: return size
        }
    }
    
    private func eggColorDisplayName(_ color: String) -> String {
        switch color {
        case "white": return "White"
        case "brown": return "Brown"
        case "blue": return "Blue"
        case "cream": return "Cream"
        case "dark brown": return "Dark Brown"
        default: return color
        }
    }
}

// MARK: - Info Row Helper View
struct InfohelpRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    HandBookView()
}
