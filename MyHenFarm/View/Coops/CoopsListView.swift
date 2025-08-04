//
//  CoopsListView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 03.08.2025.
//

import SwiftUI

struct CoopsListView: View {
    @StateObject var vm = CoopsViewModel()
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            BackgroundView()
                .ignoresSafeArea()
            
            //MARK: - Coops list
            VStack {
                ScrollView {
                    if vm.coops.isEmpty {
                        HStack {
                            Spacer()
                            Text("No coops yet")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }else {
                    }
                    ForEach(vm.coops) { coop in
                        NavigationLink {
                            CoopInfoView(coop: coop)
                        } label: {
                            CoopCellView(coop: coop)
                        }
                    }
                    
                }
            }.padding()
            
            //MARK: - Plus button
            NavigationLink {
                AddCoopView(vm: vm)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.yellowApp)
            }
            .padding()
        }
        .navigationTitle("Coops")
    }
}

#Preview {
    NavigationStack {
        CoopsListView()
    }
}
