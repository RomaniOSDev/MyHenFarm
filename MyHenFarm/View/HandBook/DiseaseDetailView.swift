//
//  DiseaseDetailView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 09.08.2025.
//

import SwiftUI

struct DiseaseDetailView: View {
    let disease: ChickenDisease
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header with image and basic info
                    headerSection
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Overview
                        overviewSection
                        
                        Divider()
                        
                        // Symptoms
                        symptomsSection
                        
                        Divider()
                        
                        // Causes
                        causesSection
                        
                        Divider()
                        
                        // Treatment
                        treatmentSection
                        
                        Divider()
                        
                        // Prevention
                        preventionSection
                        
                        if !disease.treatment.isEmpty || !disease.prevention.isEmpty {
                            Divider()
                            
                            // Important notes
                            importantNotesSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(disease.name)
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
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Disease image
            AsyncImage(url: URL(string: disease.imageURL ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(16)
                case .failure(_):
                    // Show placeholder when image fails to load
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(disease.severity.color).opacity(0.2))
                            .frame(height: 200)
                        
                        VStack(spacing: 8) {
                            Image(systemName: disease.category.icon)
                                .font(.system(size: 50))
                                .foregroundColor(Color(disease.severity.color))
                            
                            Text("Image not available")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                case .empty:
                    // Show loading state
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(disease.severity.color).opacity(0.2))
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
                            .fill(Color(disease.severity.color).opacity(0.2))
                            .frame(height: 200)
                        
                        Image(systemName: disease.category.icon)
                            .font(.system(size: 60))
                            .foregroundColor(Color(disease.severity.color))
                    }
                }
            }
            .padding()
            
            // Key info badges
            HStack(spacing: 12) {
                InfoBadge(
                    title: "Severity",
                    value: disease.severity.displayName,
                    color: Color(disease.severity.color)
                )
                
                InfoBadge(
                    title: "Category",
                    value: disease.category.displayName,
                    color: Color("yellowApp")
                )
                
                if disease.contagious {
                    InfoBadge(
                        title: "Status",
                        value: "Contagious",
                        color: Color("redApp")
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .font(.headline)
                .foregroundColor(Color("yellowApp"))
            
            Text(disease.description)
                .font(.body)
                .foregroundColor(.primary)
            
            // Additional info grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                if !disease.affectedAge.isEmpty {
                    InfoRow(title: "Affected Age", value: disease.affectedAge)
                }
                
                if let recoveryTime = disease.recoveryTime {
                    InfoRow(title: "Recovery Time", value: recoveryTime)
                }
                
                if let mortality = disease.mortality {
                    InfoRow(title: "Mortality Rate", value: mortality)
                }
                
                InfoRow(title: "Reportable", value: disease.reportable ? "Yes" : "No")
            }
        }
    }
    
    // MARK: - Symptoms Section
    private var symptomsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Symptoms")
                .font(.headline)
                .foregroundColor(Color("yellowApp"))
            
            VStack(spacing: 8) {
                ForEach(disease.symptoms, id: \.self) { symptom in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "circle.fill")
                            .font(.caption2)
                            .foregroundColor(Color("redApp"))
                            .padding(.top, 4)
                        
                        Text(symptom)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("redApp").opacity(0.1))
                    )
                }
            }
        }
    }
    
    // MARK: - Causes Section
    private var causesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Causes")
                .font(.headline)
                .foregroundColor(Color("yellowApp"))
            
            VStack(spacing: 8) {
                ForEach(disease.causes, id: \.self) { cause in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption2)
                            .foregroundColor(Color("yellowApp"))
                            .padding(.top, 4)
                        
                        Text(cause)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("yellowApp").opacity(0.1))
                    )
                }
            }
        }
    }
    
    // MARK: - Treatment Section
    private var treatmentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Treatment")
                .font(.headline)
                .foregroundColor(Color("yellowApp"))
            
            if disease.treatment.isEmpty {
                Text("No specific treatment available")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                VStack(spacing: 8) {
                    ForEach(disease.treatment, id: \.self) { treatment in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "cross.case.fill")
                                .font(.caption2)
                                .foregroundColor(Color("greenApp"))
                                .padding(.top, 4)
                            
                            Text(treatment)
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("greenApp").opacity(0.1))
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Prevention Section
    private var preventionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Prevention")
                .font(.headline)
                .foregroundColor(Color("yellowApp"))
            
            VStack(spacing: 8) {
                ForEach(disease.prevention, id: \.self) { prevention in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "shield.fill")
                            .font(.caption2)
                            .foregroundColor(Color("greenApp"))
                            .padding(.top, 4)
                        
                        Text(prevention)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("greenApp").opacity(0.1))
                    )
                }
            }
        }
    }
    
    // MARK: - Important Notes Section
    private var importantNotesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Important Notes")
                .font(.headline)
                .foregroundColor(Color("yellowApp"))
            
            VStack(spacing: 12) {
                if disease.contagious {
                    ImportantNote(
                        icon: "person.2.fill",
                        title: "Highly Contagious",
                        description: "This disease spreads easily between birds. Isolate affected chickens immediately.",
                        color: Color("redApp")
                    )
                }
                
                if disease.reportable {
                    ImportantNote(
                        icon: "flag.fill",
                        title: "Reportable Disease",
                        description: "This disease must be reported to veterinary authorities in your area.",
                        color: Color("yellowApp")
                    )
                }
                
                if disease.severity == .fatal {
                    ImportantNote(
                        icon: "exclamationmark.triangle.fill",
                        title: "Emergency",
                        description: "This is a serious condition. Contact a veterinarian immediately if suspected.",
                        color: Color("redApp")
                    )
                }
            }
        }
    }
}

// MARK: - Supporting Views
struct InfoBadge: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(color)
                .cornerRadius(8)
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct ImportantNote: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    DiseaseDetailView(disease: ChickenDisease.sampleDiseases[0])
}