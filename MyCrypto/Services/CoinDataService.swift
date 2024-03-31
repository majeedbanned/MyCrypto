//
//  CoinDataService.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/11/1403 AP.
//

import Foundation

import Combine
class CoinDataService {
    @Published var allCoins:[CoinModel]=[]
    var coinSubscribtion: AnyCancellable?
    
    init(){
        getCoin()
    }
    
    private func getCoin(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=true&price_change_percentage=24h") else
        {return}
        
        //combine:
        coinSubscribtion = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: {[weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscribtion?.cancel()
            })
            
       

        
        
    }
    
}
