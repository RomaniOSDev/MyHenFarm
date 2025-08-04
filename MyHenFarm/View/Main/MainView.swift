//
//  MainView.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 03.08.2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack{
        ZStack{
            BackgroundView()
            
                VStack{
                   HStack{
                       //MARK: - Collect eggs
                       NavigationLink {
                           EggCountingview()
                       } label: {
                           ZStack{
                              RoundedRectangle(cornerRadius: 10)
                                   .foregroundStyle(.grayApp)
                               VStack{
                                   Image(.egg)
                                       .resizable()
                                       .aspectRatio(contentMode: .fit)
                                   
                                   Text("Collected eggs")
                                       .foregroundStyle(.black)
                                       .font(.system(size: 20, weight: .bold))
                                       .multilineTextAlignment(.center)
                                       
                               }
                               .padding()
                          }
                           .padding()
                       }

                        
                       //MARK: - Coops
                       NavigationLink {
                           CoopsListView()
                       } label: {
                           ZStack{
                              RoundedRectangle(cornerRadius: 10)
                                   .foregroundStyle(.grayApp)
                               VStack{
                                   Image(systemName: "checkmark.circle.fill")
                                       .resizable()
                                       .foregroundStyle(.greenApp)
                                       .frame(width: 60, height: 60)
                                   Text("Coops")
                                       .foregroundStyle(.black)
                                       .font(.system(size: 20, weight: .bold))
                                       .multilineTextAlignment(.center)
                                       
                               }
                               .padding(10)
                          }
                           .padding()
                       }

                       
                    }
                   .frame(height: 200)
                    HStack{
                        NavigationLink {
                            AddAPostView(vm: EggCountViewModel())
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.yellowApp)
                                HStack{
                                    Image(systemName: "plus")
                                    Text("Add eggs")
                                }
                                .foregroundStyle(.black)
                                .font(.system(size: 20, weight: .bold))
                            }
                            .padding(10)
                        }

                        
                        NavigationLink {
                            FeedingListview()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.greenApp)
                               
                                    Text("Feeding")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20, weight: .bold))
                                
                            }
                            .padding(10)
                        }

                        
                    }
                    .frame(height: 80)
                    Image(.eggProduction)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                }.padding()
            }
        .navigationTitle("Today")
        }
    }
}

#Preview {
    MainView()
}
