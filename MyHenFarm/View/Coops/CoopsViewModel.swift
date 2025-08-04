//
//  CoopsViewModel.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 04.08.2025.
//

import Foundation
import CoreData
import PhotosUI
import SwiftUI

final class CoopsViewModel: ObservableObject {
    let manager = MyHenFarmCoreDataManager.instance
    @Published var coops: [Coop] = []
    @Published var simpleTitleCoop: String = ""
    @Published var selectedImage: UIImage = .coopDefault
    
    init() {
        fetchCoops()
    }
    
    func addCoop(){
        let newCoop = Coop(context: manager.context)
        newCoop.titleCoop = simpleTitleCoop
        newCoop.image = convertImageToData(selectedImage)
        saveData()
    }
    
    func clearData(){
        simpleTitleCoop = ""
        selectedImage = .coopDefault
    }
    
    private func saveData(){
        coops.removeAll()
        manager.save()
        fetchCoops()
    }
    
    private func fetchCoops() {
        let fetchRequest: NSFetchRequest<Coop> = Coop.fetchRequest()
        do {
            coops = try manager.context.fetch(fetchRequest)
        }catch {
            print(error.localizedDescription)
        }
    }
    //MARK: - Converting data
    private func convertImageToData(_ image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 1.0)
    }
}
