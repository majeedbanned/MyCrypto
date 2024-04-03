//
//  CoinDataService.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/11/1403 AP.
//

import Foundation

import Combine
class MArketDataService {
    @Published var MarketData:MarketDataModel? = nil
    var MarketDataSubscribtion: AnyCancellable?
    
    init(){
        getData  ()
    }
    
    private func getData(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else
        {return}
        
        //combine:
        MarketDataSubscribtion = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: {[weak self] (returnedGlobalData) in
                self?.MarketData = returnedGlobalData.data
                self?.MarketDataSubscribtion?.cancel()
            })
            
       

        
        
    }
    
}
