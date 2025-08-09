//
//  HealthSectionView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 09.08.2025.
//

import SwiftUI

struct HealthSectionView: View {
    @ObservedObject var healthService: HealthAPIService
    @State private var searchText = ""
    @State private var selectedCategory: DiseaseCategory?
    @State private var selectedSeverity: DiseaseSeverity?
    @State private var selectedDisease: ChickenDisease?
    @State private var selectedVaccination: ChickenVaccination?
    @State private var showingVaccinations = false
    
    private var filteredDiseases: [ChickenDisease] {
        healthService.searchDiseases(
            query: searchText,
            category: selectedCategory,
            severity: selectedSeverity
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with navigation
            headerSection
            
            if healthService.isLoading {
                Spacer()
                ProgressView("Loading health data...")
                    .scaleEffect(1.2)
                Spacer()
            } else {
                if showingVaccinations {
                    vaccinationsView
                } else {
                    diseasesView
                }
            }
        }
        .sheet(item: $selectedDisease) { disease in
            DiseaseDetailView(disease: disease)
        }
        .sheet(item: $selectedVaccination) { vaccination in
            VaccinationDetailView(vaccination: vaccination)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            // Toggle between diseases and vaccinations
            HStack(spacing: 20) {
                Button(action: { showingVaccinations = false }) {
                    VStack(spacing: 4) {
                        Image(systemName: "cross.case.fill")
                            .font(.title2)
                        Text("Diseases")
                            .font(.caption)
                    }
                    .foregroundColor(showingVaccinations ? .gray : Color("yellowApp"))
                }
                
                Button(action: { showingVaccinations = true }) {
                    VStack(spacing: 4) {
                        Image(systemName: "syringe.fill")
                            .font(.title2)
                        Text("Vaccines")
                            .font(.caption)
                    }
                    .foregroundColor(showingVaccinations ? Color("yellowApp") : .gray)
                }
                
                Spacer()
                
                // Emergency button
                Button(action: {
                    // Show emergency diseases
                    selectedSeverity = .fatal
                    showingVaccinations = false
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title2)
                        Text("Emergency")
                            .font(.caption)
                    }
                    .foregroundColor(Color("redApp"))
                }
            }
            .padding()
            
            if !showingVaccinations {
                // Search bar for diseases
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search diseases, symptoms...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                // Category filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button("All") {
                            selectedCategory = nil
                            selectedSeverity = nil
                        }
                        .buttonStyle(FilterButtonStyle(isSelected: selectedCategory == nil && selectedSeverity == nil))
                        
                        ForEach(DiseaseCategory.allCases, id: \.self) { category in
                            Button(category.displayName) {
                                selectedCategory = selectedCategory == category ? nil : category
                                selectedSeverity = nil
                            }
                            .buttonStyle(FilterButtonStyle(isSelected: selectedCategory == category))
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(Color("grayApp").opacity(0.1))
    }
    
    // MARK: - Diseases View
    private var diseasesView: some View {
        VStack {
            if filteredDiseases.isEmpty && !searchText.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "cross.case")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No diseases found")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("Try adjusting your search criteria")
                        .foregroundColor(.gray)
                }
                Spacer()
            } else {
                List(filteredDiseases) { disease in
                    DiseaseRowView(disease: disease) {
                        selectedDisease = disease
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
        }
    }
    
    // MARK: - Vaccinations View
    private var vaccinationsView: some View {
        VStack {
            // Quick stats
            HStack(spacing: 20) {
                StatCard(
                    title: "Total",
                    value: "\(healthService.vaccinations.count)",
                    color: Color("yellowApp")
                )
                
                StatCard(
                    title: "Mandatory",
                    value: "\(healthService.getMandatoryVaccinations().count)",
                    color: Color("redApp")
                )
                
                Spacer()
            }
            .padding()
            
            List(healthService.vaccinations) { vaccination in
                VaccinationRowView(vaccination: vaccination) {
                    selectedVaccination = vaccination
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
        }
    }
}

// MARK: - Disease Row View
struct DiseaseRowView: View {
    let disease: ChickenDisease
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Disease category icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(disease.severity.color).opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: disease.category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(Color(disease.severity.color))
                }
                
                // Disease info
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(disease.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Severity badge
                        Text(disease.severity.displayName)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(disease.severity.color))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Text(disease.category.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(disease.description)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    HStack {
                        if disease.contagious {
                            Label("Contagious", systemImage: "person.2.fill")
                                .font(.caption2)
                                .foregroundColor(Color("redApp"))
                        }
                        
                        if disease.reportable {
                            Label("Reportable", systemImage: "flag.fill")
                                .font(.caption2)
                                .foregroundColor(Color("yellowApp"))
                        }
                        
                        Spacer()
                    }
                }
                
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
}

// MARK: - Vaccination Row View
struct VaccinationRowView: View {
    let vaccination: ChickenVaccination
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Vaccine icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(vaccination.mandatory ? Color("redApp").opacity(0.2) : Color("greenApp").opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "syringe.fill")
                        .font(.system(size: 24))
                        .foregroundColor(vaccination.mandatory ? Color("redApp") : Color("greenApp"))
                }
                
                // Vaccination info
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(vaccination.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if vaccination.mandatory {
                            Text("Required")
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color("redApp"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    
                    Text("Against: \(vaccination.disease)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Age: \(vaccination.ageToVaccinate)")
                        .font(.caption)
                        .foregroundColor(.primary)
                    
                    Text("Method: \(vaccination.method)")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                
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
}

// MARK: - Supporting Views
struct FilterButtonStyle: ButtonStyle {
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                isSelected ? Color("yellowApp") : Color.gray.opacity(0.2)
            )
            .foregroundColor(
                isSelected ? .white : .primary
            )
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

#Preview {
    HealthSectionView(healthService: HealthAPIService())
}