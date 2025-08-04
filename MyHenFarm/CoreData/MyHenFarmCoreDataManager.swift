//
//  MyHenFarmCoreDataManager.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 03.08.2025.
//
import Foundation
import CoreData

final class MyHenFarmCoreDataManager {
    static let instance = MyHenFarmCoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "MyHenFarm")
        container.loadPersistentStores { descption, error in
            if let error = error{
                print("Error looading core data\(error)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        }catch let error {
            print("Save data erroe \(error.localizedDescription)")
        }
        
    }
}
