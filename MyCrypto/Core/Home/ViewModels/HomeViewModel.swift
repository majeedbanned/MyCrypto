//
//  HomeViewModel.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/11/1403 AP.
//

import Foundation
import Combine

class HomeViewModel :ObservableObject{
    
    @Published var statestic:[StatesticModel] = []
    
    @Published var allCoins:[CoinModel]=[]
    @Published var portfolioCoin : [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MArketDataService()
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
//        coinDataService.$allCoins
//            .sink {[weak self] returnedCoins in
//                self?.allCoins = returnedCoins
//            }
//            .store(in: &cancellables)
        
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(FilterCoins)
            .sink{[weak self] (returnedValue) in
                self?.allCoins = returnedValue
            }
            .store(in: &cancellables)
        
        marketDataService.$MarketData
            .map(mapGlobalMarketData)
            .sink {[weak self] (returnedValue) in
                self?.statestic=returnedValue
            }
            .store(in: &cancellables)
        
        
    }
    private func FilterCoins(text:String ,coins: [CoinModel])->[CoinModel]{
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter{(coin)-> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?)->[StatesticModel]{
        var stats: [StatesticModel] = []
        guard let data = marketDataModel else {return stats}
        
        let marketCap = StatesticModel(title: "Market Cap", value: data.marketCap,perentage: data.marketCapChangePercentage24HUsd)
        let volume = StatesticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatesticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatesticModel(title: "Portfolio Value", value: "$0.00",perentage: 0)
        
        stats.append(contentsOf: [
        marketCap,
        volume,
        btcDominance,portfolio
        ])
        return stats
    }
}
