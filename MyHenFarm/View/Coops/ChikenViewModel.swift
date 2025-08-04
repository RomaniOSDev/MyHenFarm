//
//  ChikenViewModel.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 04.08.2025.
//

import Foundation
import CoreData

final class ChikenViewModel: ObservableObject {
    let manager = MyHenFarmCoreDataManager.instance
    let coop: Coop
    
    init(coop: Coop) {
        self.coop = coop
    }
    
    @Published var simpleName: String = ""
    @Published var simpleBreed: String = ""
    @Published var simpleAge: String = ""
    @Published var simpleNote: String = ""
    
    func saveData(){
        let newchiken = Chicken(context: manager.context)
        newchiken.name = simpleName
        newchiken.bread = simpleBreed
        newchiken.age = Int16(simpleAge) ?? 0
        newchiken.noes = simpleNote
        newchiken.coop = coop
        manager.save()
    }
    
    func clearData(){
        simpleName = ""
        simpleBreed = ""
        simpleAge = ""
        simpleNote = ""
    }
}
