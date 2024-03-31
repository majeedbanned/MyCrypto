//
//  HomeViewModel.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/11/1403 AP.
//

import Foundation
import Combine

class HomeViewModel :ObservableObject{
    
    @Published var allCoins:[CoinModel]=[]
    @Published var portfolioCoin : [CoinModel] = []
    
    private let dataService = CoinDataService()
    private var cancellables=Set<AnyCancellable>()
    
    init(){
//        DispatchQueue.main.asyncAfter(deadline: .now()+2){
//            self.allCoins.append(DeveloperPreview.instance.coin)
//            self.portfolioCoin.append(DeveloperPreview.instance.coin)
//        }
        addSubscribers()
    }
    
    func downloadData(){
        
    }
    func addSubscribers(){
        dataService.$allCoins
            .sink {[weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
}
