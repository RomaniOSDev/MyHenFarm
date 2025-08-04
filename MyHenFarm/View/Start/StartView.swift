//
//  StartView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 02.08.2025.
//

import SwiftUI

struct StartView: View {
    @StateObject var vm = LoadingViewModel()
    
    var body: some View {
        ZStack {
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            VStack {
                Image(.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(60)              
            }
            .fullScreenCover(isPresented: $vm.isLoaded) {
                MainView()
            }
            .fullScreenCover(isPresented: $vm.isOnboarding) {
                OnboardnigView()
            }
        }
    }
}

#Preview {
    StartView()
}
