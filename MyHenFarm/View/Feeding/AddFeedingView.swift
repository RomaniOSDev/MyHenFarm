//
//  AddFeedingView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 03.08.2025.
//

import SwiftUI

struct AddFeedingView: View {
    @StateObject var vm: FeedingViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack{
            BackgroundView()
            Color.grayApp.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused = false
                }
            VStack {
                VStack {
                    HStack {
                        Text("Time")
                            .foregroundStyle(.black)
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                    }
                    CustomTimePicker(selectedDate: $vm.simpleDate)
                        .frame(maxHeight: 80)
                }
                
                //MARK: - type
                VStack{
                    HStack {
                        Text("Type of feed")
                            .foregroundStyle(.black)
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                    }
                    Menu {
                        ForEach(TypeofFeed.allCases, id: \.self) { type in
                            Button {
                                vm.simpleType = type
                            } label: {
                                Text(type.description)
                            }

                            
                        }
                    } label: {
                        HStack {
                            Text(vm.simpleType.description)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .foregroundStyle(.black)
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.opacityYellow, lineWidth: 2)
                        })
                        
                    }

                }
                
                //MARK: - Notes
                VStack{
                    HStack {
                        Text("Notes")
                            .foregroundStyle(.black)
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                    }
                    TextEditor(text: $vm.simpleNote)
                        .padding(10)
                        .foregroundStyle(.black)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.opacityYellow, lineWidth: 2)
                        })
                        .focused($isFocused)
                        .frame(minHeight: 150)
                }
                Spacer()
                
                //MARK: - Save Button
                Button {
                    vm.addFeeding()
                    dismiss()
                } label: {
                    GreenButtonView(title: "Save")
                }

            }
            .padding()
            .background(Color.grayApp.cornerRadius(20))
            .padding(30)
        }
    }
}

#Preview {
    AddFeedingView(vm: FeedingViewModel())
}
