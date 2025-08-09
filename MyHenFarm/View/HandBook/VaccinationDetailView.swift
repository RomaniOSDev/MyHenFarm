//
//  VaccinationDetailView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 09.08.2025.
//

import SwiftUI

struct VaccinationDetailView: View {
    let vaccination: ChickenVaccination
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header with vaccine info
                    headerSection
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Overview
                        overviewSection
                        
                        Divider()
                        
                        // Administration details
                        administrationSection
                        
                        Divider()
                        
                        // Side effects
                        sideEffectsSection
                        
                        if let cost = vaccination.cost {
                            Divider()
                            
                            // Cost information
                            costSection(cost: cost)
                        }
                        
                        Divider()
                        
                        // Important reminders
                        remindersSection
                    }
                    .padding()
                }
            }
            .navigationTitle(vaccination.name)
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
            // Vaccine icon and status
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(vaccination.mandatory ? Color("redApp").opacity(0.2) : Color("greenApp").opacity(0.2))
                    .frame(height: 120)
                
                VStack(spacing: 12) {
                    Image(systemName: "syringe.fill")
                        .font(.system(size: 40))
                        .foregroundColor(vaccination.mandatory ? Color("redApp") : Color("greenApp"))
                    
                    Text(vaccination.mandatory ? "MANDATORY" : "OPTIONAL")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(vaccination.mandatory ? Color("redApp") : Color("greenApp"))
                }
            }
            .padding()
            
            // Key info badges
            HStack(spacing: 12) {
                InfoBadge(
                    title: "Target",
                    value: vaccination.disease,
                    color: Color("yellowApp")
                )
                
                InfoBadge(
                    title: "Method",
                    value: vaccination.method,
                    color: Color("greenApp")
                )
                
                InfoBadge(
                    title: "Age",
                    value: vaccination.ageToVaccinate,
                    color: Color("yellowApp")
                )
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About This Vaccine")
                .font(.headline)
                .foregroundColor(Color("yellowApp"))
            
            Text(vaccination.description)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
    
    // MARK: - Administration Section
    private var administrationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Administration Details")
                .font(.headline)
                .foregroundColor(Color("yellowApp"))
            
            VStack(spacing: 12) {
                VaccinationDetailRow(
                    icon: "calendar",
                    title: "Age to Vaccinate",
                    value: vaccination.ageToVaccinate,
                    color: Color("yellowApp")
                )
                
                VaccinationDetailRow(
                    icon: "syringe",
                    title: "Administration Method",
                    value: vaccination.method,
                    color: Color("greenApp")
                )
                
                VaccinationDetailRow(
                    icon: "arrow.clockwise",
                    title: "Frequency",
                    value: vaccination.frequency,
                    color: Color("yellowApp")
                )
                
                VaccinationDetailRow(
                    icon: vaccination.mandatory ? "exclamationmark.triangle.fill" : "checkmark.circle.fill",
                    title: "Status",
                    value: vaccination.mandatory ? "Mandatory" : "Optional",
                    color: vaccination.mandatory ? Color("redApp") : Color("greenApp")
                )
            }
        }
    }
    
    // MARK: - Side Effects Section
    private var sideEffectsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Possible Side Effects")
                .font(.headline)
                .foregroundColor(Color("yellowApp"))
            
            if vaccination.sideEffects.isEmpty {
                Text("No common side effects reported")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                VStack(spacing: 8) {
                    ForEach(vaccination.sideEffects, id: \.self) { sideEffect in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .font(.caption2)
                                .foregroundColor(Color("yellowApp"))
                                .padding(.top, 4)
                            
                            Text(sideEffect)
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
    }
    
    // MARK: - Cost Section
    private func costSection(cost: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cost Information")
                .font(.headline)
                .foregroundColor(Color("yellowApp"))
            
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color("greenApp"))
                
                VStack(alignment: .leading) {
                    Text("Estimated Cost")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(cost)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("greenApp").opacity(0.1))
            )
        }
    }
    
    // MARK: - Reminders Section
    private var remindersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Important Reminders")
                .font(.headline)
                .foregroundColor(Color("yellowApp"))
            
            VStack(spacing: 12) {
                ReminderCard(
                    icon: "person.fill.checkmark",
                    title: "Consult Your Veterinarian",
                    description: "Always consult with a poultry veterinarian before administering vaccines.",
                    color: Color("greenApp")
                )
                
                if vaccination.mandatory {
                    ReminderCard(
                        icon: "exclamationmark.triangle.fill",
                        title: "Mandatory Vaccination",
                        description: "This vaccine is essential for chicken health and may be required by law in your area.",
                        color: Color("redApp")
                    )
                }
                
                ReminderCard(
                    icon: "thermometer",
                    title: "Storage Requirements",
                    description: "Store vaccines according to manufacturer instructions, usually refrigerated.",
                    color: Color("yellowApp")
                )
                
                ReminderCard(
                    icon: "calendar.badge.clock",
                    title: "Timing Matters",
                    description: "Follow the recommended vaccination schedule for maximum effectiveness.",
                    color: Color("greenApp")
                )
            }
        }
    }
}

// MARK: - Supporting Views
struct VaccinationDetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

struct ReminderCard: View {
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
    VaccinationDetailView(vaccination: ChickenVaccination.sampleVaccinations[0])
}