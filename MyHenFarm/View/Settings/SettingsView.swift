//
//  SettingsView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 04.08.2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    private let manager = MyHenFarmCoreDataManager.instance
    @State private var showAlert: Bool = false
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 30) {
                Button {
                    if let url = URL(string: "https://www.termsfeed.com/live/e2709bef-420f-4400-a43c-535be1539ded") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    GreenButtonView(title: "Policy")
                }
                Button {
                    SKStoreReviewController.requestReview()
                } label: {
                    GreenButtonView(title: "Rate us")
                }
                
                Button {
                    showAlert.toggle()
                } label: {
                    GreenButtonView(title: "Reset data")
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 4)
                                .foregroundStyle(.redApp)
                        }
                }

            }.padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Are you sure?"), message: Text("All data will be deleted"), primaryButton: .destructive(Text("Delete")) {
                self.manager.clearAllCoreData()
            }, secondaryButton: .cancel())
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
