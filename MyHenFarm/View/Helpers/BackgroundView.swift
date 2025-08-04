//
//  BackgroundView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 02.08.2025.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            Color.white
                .ignoresSafeArea()
                .opacity(0.3)
        }
    }
}

#Preview {
    BackgroundView()
}
