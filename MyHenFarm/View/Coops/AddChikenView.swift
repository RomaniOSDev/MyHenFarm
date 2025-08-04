//
//  AddChikenView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 04.08.2025.
//

import SwiftUI

struct AddChikenView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: ChikenViewModel
    @FocusState var isFocused: Bool
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    Text("Add chiken")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.black)
                            
                    }

                }
                ScrollView {
                    VStack{
                        HStack {
                            Text( "New chiken")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        TextField("Name", text: $vm.simpleName)
                            .padding()
                            .focused($isFocused)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(.gray)
                                
                            }
                        TextField("Breed", text: $vm.simpleBreed)
                            .padding()
                            .focused($isFocused)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(.gray)
                                
                            }
                        TextField("Age", text: $vm.simpleAge)
                            .padding()
                            .focused($isFocused)
                            .keyboardType(.numberPad)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundStyle(.gray)
                                
                            }
                        
                        VStack(alignment: .leading){
                            Text("Notes")
                                .foregroundStyle(.black)
                            TextEditor(text: $vm.simpleNote)
                                .cornerRadius(10)
                                .frame(height: 150)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .foregroundStyle(.gray)
                                    
                                }
                        }
                        
                        Button {
                            vm.saveData()
                            dismiss()
                        } label: {
                            GreenButtonView(title: "Save")
                                .opacity(vm.simpleName.isEmpty ? 0.5 : 1)
                        }.disabled(vm.simpleName.isEmpty)
                        
                    }
                    .padding()
                    .background {
                        Color.grayApp.cornerRadius(20)
                            .onTapGesture {
                                isFocused = false
                            }
                    }
                }
                Spacer()
            }.padding()
        }
        .navigationBarBackButtonHidden()
        .onTapGesture {
            isFocused = false
        }
    }
}

#Preview {
    AddChikenView(vm: ChikenViewModel(coop: Coop(context: MyHenFarmCoreDataManager.instance.context)))
}
