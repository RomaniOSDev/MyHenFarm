//
//  ChikenCellView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 04.08.2025.
//

import SwiftUI

struct ChikenCellView: View {
    let chiken: Chicken
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text("\(chiken.name ?? "Chiken")")
                    .font(.system(size: 24, weight: .bold))
                Text("\(chiken.bread ?? "Small")")
            }
            .foregroundStyle(.black)
            Spacer()
            Text("\(chiken.age) years")
        }
        .padding(20)
        .background(Color.whiteApp.cornerRadius(10))
    }
}

#Preview {
    ZStack {
        Color.black
        ChikenCellView(chiken: Chicken(context: MyHenFarmCoreDataManager.instance.context))
    }
}
