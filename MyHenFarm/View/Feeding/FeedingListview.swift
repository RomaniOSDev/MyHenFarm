//
//  FeedingListview.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 03.08.2025.
//

import SwiftUI

struct FeedingListview: View {
    @StateObject var vm = FeedingViewModel()
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            BackgroundView()
            ScrollView{
                VStack {
                    HStack {
                        Text("Time")
                            .foregroundStyle(.black)
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                    }
                    if vm.feedings.isEmpty {
                        Text("No data")
                            .foregroundStyle(.black)
                            .font(.system(size: 20, weight: .bold))
                    }else {
                        ForEach(vm.feedings) { fedding in
                            FeedingCellView(feeding: fedding)
                            Divider()
                        }
                    }
                }
                .padding()
                .background {
                    Color.grayApp.cornerRadius(20)
                }
                .padding()
            }
            NavigationLink {
                AddFeedingView(vm: vm)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.yellowApp)
            }
            .padding()

        }
        .navigationTitle(Text("Feeding"))
    }
}

#Preview {
    NavigationStack {
        FeedingListview()
    }
}
