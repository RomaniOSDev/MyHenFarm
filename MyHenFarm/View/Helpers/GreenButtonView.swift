//
//  GreenButtonView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 03.08.2025.
//

import SwiftUI

struct GreenButtonView: View {
    let title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.greenApp)
            Text(title)
                .foregroundStyle(.white)
                .font(.system(size: 20))
        }.frame(width: 280, height: 50)
    }
}

#Preview {
    GreenButtonView(title: "Save")
}
