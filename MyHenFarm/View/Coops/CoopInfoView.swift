//
//  CoopInfoView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 04.08.2025.
//

import SwiftUI

struct CoopInfoView: View {
    @StateObject var coop: Coop
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            BackgroundView()
            VStack{
                if let chickens = coop.chken?.allObjects as? [Chicken]{
                    if chickens.isEmpty{
                        HStack {
                            Spacer()
                            Text("No chickens")
                                .foregroundStyle(.white)
                                .font(.title)
                            Spacer()
                        }
                    }
                    ScrollView {
                        ForEach(chickens) { ciken in
                            ChikenCellView(chiken: ciken)
                        }
                    }
                }
                
            }.padding()
            
            //MARK: - Plus button
            NavigationLink {
                AddChikenView(vm: ChikenViewModel(coop: coop))
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.yellowApp)
            }
            .padding()
        }
        .navigationTitle(coop.titleCoop ?? "Coop")
    }
}

#Preview {
    NavigationStack {
        CoopInfoView(coop: Coop(context: MyHenFarmCoreDataManager.instance.context))
    }
}
