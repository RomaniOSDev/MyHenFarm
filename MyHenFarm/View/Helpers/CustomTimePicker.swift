//
//  CustomTimePicker.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 03.08.2025.
//

import SwiftUI

struct CustomTimePicker: View {
    @State private var selectedHour = 12
    @State private var selectedMinute = 0
    @State private var isAM = true
    @Binding var selectedDate: Date
    
    let hours = Array(1...12)
    let minutes = Array(0...59)
    
    var body: some View {
        HStack(spacing: 20) {
            // Выбор времени (часы:минуты)
            HStack(spacing: 5) {
                // Часы
                Picker("Hour", selection: $selectedHour) {
                    ForEach(hours, id: \.self) { hour in
                        Text("\(hour)")
                            .font(.title)
                            .tag(hour)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 80)
                .background(content: {
                    Color.purple.opacity(0.3)
                        .cornerRadius(8)
                        .frame(width: 60)
                })
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(width: 60, height: 60)
                )
                .onChange(of: selectedHour) { _ in updateDate() }
                
                Text(":")
                    .font(.largeTitle)
                    .padding(.horizontal, -5)
                
                // Минуты
                Picker("Minute", selection: $selectedMinute) {
                    ForEach(minutes, id: \.self) { minute in
                        Text(String(format: "%02d", minute))
                            .font(.title)
                            .tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 80)
                .background(content: {
                    Color.purple.opacity(0.3)
                        .cornerRadius(8)
                        .frame(width: 60)
                })
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(width: 60, height: 60)
                )
                .onChange(of: selectedMinute) { _ in updateDate() }
            }
            .frame(height: 100)
            
            // Выбор AM/PM
            VStack(spacing: 0) {
                Button {
                    isAM = true
                } label: {
                    ZStack {
                        Color.pink.opacity(isAM ? 0.6 : 0.3)
                        Text("AM")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundStyle(.black)
                            .padding(10)
                            .minimumScaleFactor(0.5)
                    }
                }
                Button {
                    isAM = false
                } label: {
                    ZStack {
                        Color.purple.opacity(!isAM ? 0.6 : 0.3)
                            
                        Text("PM")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundStyle(.black)
                            .padding(10)
                            .minimumScaleFactor(0.5)
                    }
                    
                }

            }
            .frame(maxWidth: 60)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
        }
        
        .onAppear {
            updateDate() // Инициализация при первом появлении
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: selectedDate)
    }
    
    private func updateDate() {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        // Конвертация 12-часового формата в 24-часовой
        var hour24 = selectedHour
        if !isAM && hour24 != 12 {
            hour24 += 12
        } else if isAM && hour24 == 12 {
            hour24 = 0
        }
        
        components.hour = hour24
        components.minute = selectedMinute
        components.second = 0
        
        if let newDate = Calendar.current.date(from: components) {
            selectedDate = newDate
        }
    }
}
