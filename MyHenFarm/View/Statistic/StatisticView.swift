//
//  StatisticView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 04.08.2025.
//

import SwiftUI
#if canImport(Charts)
import Charts
#endif

struct StatisticView: View {
    @StateObject private var viewModel = StatisticViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    periodButtonsView
                    chartView
                    statisticsView
                    Spacer()
                }
            }
        }
        .navigationTitle("Statistic")
        .onAppear {
            viewModel.loadData()
        }
    }
    
    // MARK: - Subviews
    
    
    
    private var periodButtonsView: some View {
        HStack(spacing: 15) {
            PeriodButton(
                title: "Today",
                isSelected: viewModel.selectedPeriod == .today,
                action: { viewModel.selectedPeriod = .today }
            )
            
            PeriodButton(
                title: "Week",
                isSelected: viewModel.selectedPeriod == .week,
                action: { viewModel.selectedPeriod = .week }
            )
            
            PeriodButton(
                title: "Month",
                isSelected: viewModel.selectedPeriod == .month,
                action: { viewModel.selectedPeriod = .month }
            )
        }
        .padding(.horizontal, 20)
    }
    
    private var chartView: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            
            chartContentView
        }
    }
    
    private var chartContentView: some View {
        Group {
            if #available(iOS 16.0, *) {
                Chart {
                    ForEach(viewModel.chartData, id: \.date) { dataPoint in
                                                        BarMark(
                                    x: .value("Date", dataPoint.date, unit: .day),
                                    y: .value("Quantity", dataPoint.quantity)
                                )
                        .foregroundStyle(.yellowApp)
                        .cornerRadius(4)
                    }
                }
            } else {
                fallbackChartView
            }
        }
        .frame(height: 200)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.whiteApp.opacity(0.7))
        )
        .padding(.horizontal, 20)
    }
    
    private var fallbackChartView: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.chartData, id: \.date) { dataPoint in
                HStack {
                    Text(formatDate(dataPoint.date))
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    
                    Spacer()
                    
                                                        Text("\(dataPoint.quantity) eggs")
                                        .foregroundColor(.yellowApp)
                                        .font(.system(size: 14, weight: .semibold))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.05))
                )
            }
            
                                        if viewModel.chartData.isEmpty {
                                Text("No data to display")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.system(size: 16))
                            }
        }
    }
    
    private var statisticsView: some View {
        VStack(spacing: 15) {
            StatisticCard(
                title: "Total Eggs",
                value: "\(viewModel.totalEggs)",
                icon: .egg
            )
            
            StatisticCard(
                title: "Average per Day",
                value: String(format: "%.1f", viewModel.averageEggsPerDay),
                icon: .egg
            )
            
            priceInputView
            profitCardView
        }
        .padding(.horizontal, 20)
    }
    
    private var priceInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Price per Egg")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            HStack {
                TextField("", text: $viewModel.eggPrice, prompt: Text("50").foregroundColor(.white.opacity(0.6)))
                    .keyboardType(.decimalPad)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.2))
                    )
                    .foregroundColor(.white)
                    .onChange(of: viewModel.eggPrice) { _ in
                        viewModel.updatePrice()
                    }
                
                Image(.coin)
                    .resizable()
                    .frame(width: 18, height: 18)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var profitCardView: some View {
        StatisticCard(
            title: "Total Profit",
            value: String(format: "%.0f ", viewModel.totalProfit),
            icon: .coin
        )
    }
}

// MARK: - Supporting Views

struct PeriodButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .yellowApp)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(buttonBackground)
        }
    }
    
    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(isSelected ? Color.yellowApp : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.yellowApp, lineWidth: 1)
            )
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: ImageResource
    
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .frame(width: 50, height: 50)
            
            HStack() {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.8))
                
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.grayApp.opacity(0.7))
        )
    }
}

// MARK: - Helper Functions

private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM"
    return formatter.string(from: date)
}

#Preview {
    StatisticView()
}
