//
//  EggCountingview.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 03.08.2025.
//

import SwiftUI

struct EggCountingview: View {
    @StateObject var vm = EggCountViewModel()
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            BackgroundView()
            VStack{
                Menu {
                    ForEach(vm.coops) { coop in
                        Button {
                            vm.chooseCoop = coop
                        } label: {
                            Text(coop.titleCoop ?? "")
                        }
                        
                    }
                } label: {
                    HStack{
                        Text("\(vm.chooseCoop?.titleCoop ?? "Choose coop")")
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .foregroundStyle(.black)
                    .padding()
                    .background(Color.grayApp.cornerRadius(10))
                }
                .padding()
                
                ScrollView{
                    VStack{
                        HStack{
                            Text("Date")
                            Spacer()
                            Text("Quantity")
                            Spacer()
                            Text("Coop")
                        }
                        .foregroundStyle(.black)
                        .font(.system(size: 20, weight: .bold))
    
                        ForEach(vm.sortPost) { post in
                            Rectangle()
                                .frame( height: 1)
                            PostCellView(post: post)
                                .padding(.vertical, 5)
                            
                        }
                    }
                    .padding()
                    .background(Color.grayApp.cornerRadius(10))
                    
                    
                    Spacer()
                }.padding()
            }
            //MARK: - Plus button
            NavigationLink {
                AddAPostView(vm: vm)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.yellowApp)
            }
            .padding()
        }
        .navigationTitle("Egg counting")
    }
}

#Preview {
    NavigationStack {
        EggCountingview()
    }
}
