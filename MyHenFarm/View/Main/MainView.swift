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
            ScrollView{
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
                    
                    //Handbook of Chkens
                    NavigationLink {
                        HandBookView()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.redApp)
                            HStack{
                                Image(systemName: "book.fill")
                                Text("Handbook of Chikens")
                            }
                            .padding()
                            .foregroundStyle(.black)
                            .font(.system(size: 20, weight: .bold))
                        }
                        .padding(10)
                    }
                    .padding()
                    
                    //MARK: - Settings
                    NavigationLink {
                        StatisticView()
                    } label: {
                        Image(.eggProduction)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 60 , height: 60)
                            .foregroundStyle(.redApp)
                            .shadow(radius: 5)
                    }
                    .padding()
                    
                   

                }.padding()
            }
            }
        .navigationTitle("Today")
        }
    }
}

#Preview {
    MainView()
}
