//
//  OnboardnigView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 02.08.2025.
//

import SwiftUI

struct OnboardnigView: View {
    
    @StateObject var vm = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
             VStack {
                 Image(vm.getImage())
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .padding(20)
                 Text(vm.currentPageTitle)
                     .foregroundStyle(.white)
                     .font(.system(size: 32, weight: .bold, design: .default))
                 Spacer()
                 Button {
                     vm.nextPage()
                 } label: {
                     GreenButtonView(title: "Next")
                 }                     
             }.padding()
        }
        .fullScreenCover(isPresented: $vm.isOnboardingCompleted) {
            MainView()
        }
    }
}

#Preview {
    OnboardnigView()
}
