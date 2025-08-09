//
//  HealthAPIService.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 09.08.2025.
//

import Foundation

// MARK: - Health API Service
class HealthAPIService: ObservableObject {
    @Published var diseases: [ChickenDisease] = []
    @Published var vaccinations: [ChickenVaccination] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://poultrydvm.com/api/v1"
    
    // MARK: - Fetch All Health Data
    func fetchHealthData() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            // Try to fetch from API first
            async let diseasesTask = fetchDiseasesFromAPI()
            async let vaccinationsTask = fetchVaccinationsFromAPI()
            
            let (diseases, vaccinations) = try await (diseasesTask, vaccinationsTask)
            
            await MainActor.run {
                self.diseases = diseases
                self.vaccinations = vaccinations
                self.isLoading = false
            }
        } catch {
            // Fallback to sample data if API is unavailable
            print("Health API unavailable, using sample data: \(error.localizedDescription)")
            await MainActor.run {
                self.diseases = ChickenDisease.sampleDiseases
                self.vaccinations = ChickenVaccination.sampleVaccinations
                self.isLoading = false
                // Don't set error message since we have fallback data
            }
        }
    }
    
    // MARK: - Search Functions
    func searchDiseases(query: String, category: DiseaseCategory? = nil, severity: DiseaseSeverity? = nil) -> [ChickenDisease] {
        var filteredDiseases = diseases
        
        // Filter by category
        if let category = category {
            filteredDiseases = filteredDiseases.filter { $0.category == category }
        }
        
        // Filter by severity
        if let severity = severity {
            filteredDiseases = filteredDiseases.filter { $0.severity == severity }
        }
        
        // Filter by search query
        if !query.isEmpty {
            filteredDiseases = filteredDiseases.filter { disease in
                disease.name.localizedCaseInsensitiveContains(query) ||
                disease.description.localizedCaseInsensitiveContains(query) ||
                disease.symptoms.contains { $0.localizedCaseInsensitiveContains(query) } ||
                disease.causes.contains { $0.localizedCaseInsensitiveContains(query) }
            }
        }
        
        return filteredDiseases
    }
    
    func filterDiseasesByCategory(_ category: DiseaseCategory) -> [ChickenDisease] {
        return diseases.filter { $0.category == category }
    }
    
    func getContagiousDiseases() -> [ChickenDisease] {
        return diseases.filter { $0.contagious }
    }
    
    func getReportableDiseases() -> [ChickenDisease] {
        return diseases.filter { $0.reportable }
    }
    
    func getEmergencyDiseases() -> [ChickenDisease] {
        return diseases.filter { $0.severity == .fatal || $0.severity == .severe }
    }
    
    // MARK: - Vaccination Functions
    func getMandatoryVaccinations() -> [ChickenVaccination] {
        return vaccinations.filter { $0.mandatory }
    }
    
    func getVaccinationsByAge() -> [String: [ChickenVaccination]] {
        var groupedVaccinations: [String: [ChickenVaccination]] = [:]
        
        for vaccination in vaccinations {
            let key = vaccination.ageToVaccinate
            if groupedVaccinations[key] == nil {
                groupedVaccinations[key] = []
            }
            groupedVaccinations[key]?.append(vaccination)
        }
        
        return groupedVaccinations
    }
    
    // MARK: - Private API Methods
    private func fetchDiseasesFromAPI() async throws -> [ChickenDisease] {
        guard let url = URL(string: "\(baseURL)/diseases") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let diseases = try JSONDecoder().decode([ChickenDisease].self, from: data)
        return diseases
    }
    
    private func fetchVaccinationsFromAPI() async throws -> [ChickenVaccination] {
        guard let url = URL(string: "\(baseURL)/vaccinations") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let vaccinations = try JSONDecoder().decode([ChickenVaccination].self, from: data)
        return vaccinations
    }
}

// MARK: - Health Statistics
extension HealthAPIService {
    func getHealthStatistics() -> HealthStatistics {
        let totalDiseases = diseases.count
        let contagiousCount = diseases.filter { $0.contagious }.count
        let fatalCount = diseases.filter { $0.severity == .fatal }.count
        let preventableCount = diseases.filter { !$0.prevention.isEmpty }.count
        
        let categoryStats = DiseaseCategory.allCases.map { category in
            CategoryStat(
                category: category,
                count: diseases.filter { $0.category == category }.count
            )
        }.sorted { $0.count > $1.count }
        
        return HealthStatistics(
            totalDiseases: totalDiseases,
            contagiousDiseases: contagiousCount,
            fatalDiseases: fatalCount,
            preventableDiseases: preventableCount,
            categoryBreakdown: categoryStats
        )
    }
}

// MARK: - Health Statistics Model
struct HealthStatistics {
    let totalDiseases: Int
    let contagiousDiseases: Int
    let fatalDiseases: Int
    let preventableDiseases: Int
    let categoryBreakdown: [CategoryStat]
}

struct CategoryStat {
    let category: DiseaseCategory
    let count: Int
}