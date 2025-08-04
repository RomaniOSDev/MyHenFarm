//
//  OnboardingViewMOdel.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 02.08.2025.
//

import Foundation
import SwiftUI

struct OnboardingPage {
    let title: String
    let image: ImageResource
}

final class OnboardingViewModel: ObservableObject {
    @Published var isOnboardingCompleted: Bool = false
    @Published var currentPageTitle: String = ""
    @AppStorage("firstLaunch") var firstLaunch: Bool?
    
    private var currentPage: Int = 0
    private var pages: [OnboardingPage] = [OnboardingPage(title: "Welcom to My hen farm", image: .onBoardimage1),
                                           OnboardingPage(title: "Add a chicken coop", image: .onBoardimage2),
                                           OnboardingPage(title: "Keep a record of the eggs", image: .onBoardimage3)]
    
    
    init(){
        currentPageTitle = getTitle()
    }
    
    func nextPage() {
        if currentPage < pages.count - 1 {
            currentPage += 1
            currentPageTitle = getTitle()
        } else {
            isOnboardingCompleted = true
            firstLaunch = false
        }
    }
    
    func getImage() -> ImageResource {
        guard pages.indices.contains(currentPage) else {
            return pages.last?.image ?? .default // или обработать ошибку
        }
        return pages[currentPage].image
    }

    func getTitle() -> String {
        guard pages.indices.contains(currentPage) else {
            return pages.last?.title ?? "" // или обработать ошибку
        }
        return pages[currentPage].title
    }
}
