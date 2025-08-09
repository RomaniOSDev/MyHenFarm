//
//  ChickenAPIService.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 09.08.2025.
//

import Foundation

// MARK: - API Service for Chicken Data
class ChickenAPIService: ObservableObject {
    @Published var breeds: [ChickenBreed] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://chickenapi.com/api/v1"
    
    // MARK: - Fetch All Breeds
    func fetchBreeds() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            // Try to fetch from API first
            let breeds = try await fetchBreedsFromAPI()
            await MainActor.run {
                self.breeds = breeds
                self.isLoading = false
            }
        } catch {
            // Fallback to sample data if API is unavailable
            print("API unavailable, using sample data: \(error.localizedDescription)")
            await MainActor.run {
                self.breeds = ChickenBreed.sampleBreeds
                self.isLoading = false
                // Don't set error message since we have fallback data
            }
        }
    }
    
    // MARK: - Search Breeds
    func searchBreeds(query: String) -> [ChickenBreed] {
        if query.isEmpty {
            return breeds
        }
        
        return breeds.filter { breed in
            breed.name.localizedCaseInsensitiveContains(query) ||
            breed.origin?.localizedCaseInsensitiveContains(query) == true ||
            breed.purpose.localizedCaseInsensitiveContains(query) ||
            breed.description.localizedCaseInsensitiveContains(query) ||
            breed.characteristics.contains { $0.localizedCaseInsensitiveContains(query) }
        }
    }
    
    // MARK: - Filter by Purpose
    func filterBreeds(by purpose: String) -> [ChickenBreed] {
        if purpose == "all" {
            return breeds
        }
        
        return breeds.filter { $0.purpose == purpose }
    }
    
    // MARK: - Private API Methods
    private func fetchBreedsFromAPI() async throws -> [ChickenBreed] {
        // Since the actual API structure from chickenapi.com is not documented,
        // we'll implement a mock API call that would work with a real API
        
        guard let url = URL(string: "\(baseURL)/breeds") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let breeds = try JSONDecoder().decode([ChickenBreed].self, from: data)
        return breeds
    }
}

// MARK: - API Errors
enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Failed to decode data"
        }
    }
}