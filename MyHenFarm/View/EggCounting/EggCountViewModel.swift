//
//  EggCountViewModel.swift
//  MyHenFarm
//
//  Created by Роман Главацкий on 04.08.2025.
//

import Foundation
import CoreData
import Combine

final class EggCountViewModel: ObservableObject {
    let manager = MyHenFarmCoreDataManager.instance
    
    @Published var simpleDate: Date = Date()
    @Published var simpleQuantity: Int16 = 0
    @Published var simpleCoop: Coop?
    
    @Published var coops: [Coop] = []
    @Published var chooseCoop: Coop? {
        didSet{
            updateSortesPosts()
        }
    }
    
    @Published var sortPost: [PostCounting] = []
    
    private var allPosts: [PostCounting] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchCoops()
        fetchAllPosts()
    }
    
    func addPost() {
        let newPost = PostCounting(context: manager.context)
        newPost.date = simpleDate
        newPost.quantity = simpleQuantity
        newPost.coop = simpleCoop
        saveData()
    }
    func clearData() {
        simpleDate = Date()
        simpleQuantity = 0
        simpleCoop = nil
        
    }
    
    private func saveData() {
        allPosts.removeAll()
        manager.save()
        fetchAllPosts()
        updateSortesPosts()
    }
    
    func tapMinus() {
        guard simpleQuantity > 0 else { return }
        simpleQuantity -= 1
    }
    
    func tapPlus() {
        simpleQuantity += 1
    }
    
    private func setupBindings() {
        $chooseCoop
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateSortesPosts()
            })
            .store(in: &cancellables)
    }
    
    private func updateSortesPosts() {
        if let selectedCoop = chooseCoop {
            sortPost = allPosts.filter {$0.coop == selectedCoop}
        }else{
            sortPost = allPosts
        }
    }
    
    private func fetchAllPosts() {
        let request: NSFetchRequest<PostCounting> = PostCounting.fetchRequest()
        do {
            allPosts = try manager.context.fetch(request)
            sortPost = allPosts
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fetchCoops() {
        let fetchRequest: NSFetchRequest<Coop> = Coop.fetchRequest()
        do {
            coops = try manager.context.fetch(fetchRequest)
        }catch {
            print(error.localizedDescription)
        }
    }
}
