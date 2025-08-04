//
//  LoadingViewModel.swift
//  FreshFarm
//
//  Created by Роман Главацкий on 20.06.2025.
//

import Foundation
import SwiftUI
import Combine

final class LoadingViewModel: ObservableObject {
    @AppStorage("firstLaunch") var firstLaunch: Bool?
    @Published var isLoaded: Bool = false
    @Published var isOnboarding: Bool = false
    private var progress: Int = 0
    
    private var cancellables: AnyCancellable?
    
    init(){
        startLoading()
    }
    
    private func startLoading() {
        progress = 0
         cancellables = Timer
            .publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.progress < 100 {
                    progress += 2
                }else{
                    self.chooseCoverView()
                    self.cancellables?.cancel()
                }
            }
    }
    private func chooseCoverView(){
        if firstLaunch ?? true{
            isOnboarding = true
        }else{
            isLoaded = true
        }
    }
}
