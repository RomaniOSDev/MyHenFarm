//
//  FeedingViewModel.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 03.08.2025.
//

import Foundation
import CoreData

enum TypeofFeed: CaseIterable {
    case compound
    case freshgrass
    case cereals
    
    var description: String {
        switch self {
        case .compound:
            return "Compound "
        case .freshgrass:
            return "Fresh grass "
        case .cereals:
            return "Сereals"
        }
    }
}

final class FeedingViewModel:ObservableObject {
    let manager = MyHenFarmCoreDataManager.instance
    
    @Published var feedings:[Feeding] = []
    @Published var simpleDate: Date = Date()
    @Published var simpleType: TypeofFeed = .compound
    @Published var simpleNote: String = ""
    
    init(){
        fetchFeedings()
    }
    
    func fetchFeedings() {
        let request = NSFetchRequest<Feeding>(entityName: "Feeding")
        do {
            feedings = try manager.context.fetch(request)
        }catch let error as NSError {
            print("error fetching feedings\(error.localizedDescription)")
        }
    }
    
    func addFeeding() {
        let newFeeding = Feeding(context: manager.context)
        newFeeding.date = simpleDate
        newFeeding.type = simpleType.description
        newFeeding.nate = simpleNote
        saveContext()
        clearData()
    }
    
    private func saveContext() {
        feedings.removeAll()
        manager.save()
        fetchFeedings( )
    }
    
    func clearData() {
        simpleDate = Date()
        simpleType = .compound
        simpleNote = ""
    }
}
