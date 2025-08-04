//
//  AddAPostView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 04.08.2025.
//

import SwiftUI

struct AddAPostView: View {
    @StateObject var vm: EggCountViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 30){
                
                //MARK: - Date
                VStack{
                    HStack{
                        Text("Date")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.black)
                        
                        Spacer()
                        Image(systemName: "calendar")
                        
                    }.foregroundColor(.black)
                    DatePicker("Enter date", selection: $vm.simpleDate, displayedComponents: .date)
                }
                
                //MARK: - Quantity
                VStack{
                    HStack{
                        Text("Quantity")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    HStack{
                        Button {
                            vm.tapMinus()
                        } label: {
                            Image(systemName: "minus.square.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.redApp)
                        }
                        
                        Spacer()
                        
                        Text("\(vm.simpleQuantity)")
                            .font(.system(size: 28, weight: .bold))
                        
                        Spacer()
                        
                        Button {
                            vm.tapPlus()
                        } label: {
                            Image(systemName: "plus.square.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.greenApp)
                        }
                    }
                }
                
                //MARK: - Coop
                VStack{
                    HStack{
                        Text("Coop")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    Menu {
                        ForEach(vm.coops) { coop in
                            Button {
                                vm.simpleCoop = coop
                            } label: {
                                Text(coop.titleCoop ?? "")
                            }

                        }
                    } label: {
                        HStack{
                            Text("\(vm.simpleCoop?.titleCoop ?? "Choose coop")")
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .foregroundStyle(.black)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                }
                
                Spacer()
                
                Button {
                    vm.addPost()
                    dismiss()
                } label: {
                    GreenButtonView(title: "Save")
                }

            }
            .padding()
            .background(Color.grayApp.cornerRadius(10))
            .padding(30)
        }
        .onDisappear {
            vm.clearData()
        }
    }
}

#Preview {
    NavigationStack {
        AddAPostView(vm: EggCountViewModel())
    }
}
