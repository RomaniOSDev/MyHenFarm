//
//  StatisticViewModel.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 04.08.2025.
//

import Foundation
import CoreData
import SwiftUI

enum StatisticPeriod: CaseIterable {
    case today
    case week
    case month
}

struct ChartDataPoint {
    let date: Date
    let quantity: Int
}

final class StatisticViewModel: ObservableObject {
    let manager = MyHenFarmCoreDataManager.instance
    
    @Published var selectedPeriod: StatisticPeriod = .today {
        didSet {
            updateData()
        }
    }
    
    @Published var chartData: [ChartDataPoint] = []
    @Published var totalEggs: Int = 0
    @Published var averageEggsPerDay: Double = 0.0
    @Published var eggPrice: String = "50" // Price per egg in rubles
    @Published var totalProfit: Double = 0.0
    
    private var allPosts: [PostCounting] = []
    
    init() {
        loadData()
    }
    
    func loadData() {
        fetchAllPosts()
        updateData()
    }
    
    func updatePrice() {
        calculateProfit()
    }
    
    private func fetchAllPosts() {
        let request: NSFetchRequest<PostCounting> = PostCounting.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PostCounting.date, ascending: true)]
        
        do {
            allPosts = try manager.context.fetch(request)
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }
    
    private func updateData() {
        let filteredPosts = filterPostsByPeriod()
        chartData = createChartData(from: filteredPosts)
        calculateStatistics(from: filteredPosts)
        calculateProfit()
    }
    
    private func filterPostsByPeriod() -> [PostCounting] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .today:
            let startOfDay = calendar.startOfDay(for: now)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            return allPosts.filter { post in
                guard let postDate = post.date else { return false }
                return postDate >= startOfDay && postDate < endOfDay
            }
            
        case .week:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            let endOfWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)!
            return allPosts.filter { post in
                guard let postDate = post.date else { return false }
                return postDate >= startOfWeek && postDate < endOfWeek
            }
            
        case .month:
            let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
            let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            return allPosts.filter { post in
                guard let postDate = post.date else { return false }
                return postDate >= startOfMonth && postDate < endOfMonth
            }
        }
    }
    
    private func createChartData(from posts: [PostCounting]) -> [ChartDataPoint] {
        let calendar = Calendar.current
        var dataPoints: [ChartDataPoint] = []
        
        // Группируем по дням
        var dailyData: [Date: Int] = [:]
        
        for post in posts {
            guard let postDate = post.date else { continue }
            let dayStart = calendar.startOfDay(for: postDate)
            dailyData[dayStart, default: 0] += Int(post.quantity)
        }
        
        // Создаем точки данных для графика
        for (date, quantity) in dailyData.sorted(by: { $0.key < $1.key }) {
            dataPoints.append(ChartDataPoint(date: date, quantity: quantity))
        }
        
        return dataPoints
    }
    
    private func calculateStatistics(from posts: [PostCounting]) {
        totalEggs = posts.reduce(0) { $0 + Int($1.quantity) }
        
        let calendar = Calendar.current
        let now = Date()
        
        let daysCount: Int
        switch selectedPeriod {
        case .today:
            daysCount = 1
        case .week:
            daysCount = 7
        case .month:
            daysCount = calendar.range(of: .day, in: .month, for: now)?.count ?? 30
        }
        
        averageEggsPerDay = daysCount > 0 ? Double(totalEggs) / Double(daysCount) : 0.0
    }
    
    private func calculateProfit() {
        guard let price = Double(eggPrice) else {
            totalProfit = 0.0
            return
        }
        totalProfit = Double(totalEggs) * price
    }
} 