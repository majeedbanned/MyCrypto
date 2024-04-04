//
//  PortfolioDataService.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/15/1403 AP.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container : NSPersistentContainer
    private let containerName : String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntites :[PortfolioEntity] = []
    init(){
        container = NSPersistentContainer(name:containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            
            
            self.getPortfolio()
        }
        
    }
    
    // MARK :Public
    func updatePortfolio(coin:CoinModel,amount:Double)
    {
        if let entity=savedEntites.first(where:{$0.coinId == coin.id}){
            
            if amount > 0 {
                 update(entity: entity, amount: amount)
            }else
            {
                delete(entity: entity)
            }
            
        }else{
            add(coin: coin, amoint: amount)
        
        }
        
    }
    
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do{
          savedEntites =  try container.viewContext.fetch(request)
        } catch let error{
            print("Error fetching Portfolio Entities \(error)")
        }
    }
    
    private func add(coin:CoinModel, amoint:Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amoint
        applyChanges()
    }
    
    private func update(entity:PortfolioEntity , amount :Double)
    {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    private func save(){
        do{
            try container.viewContext.save()
        }catch let error{
            print(" error saving to core Data: \(error)")
        }
    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
    
    
}
