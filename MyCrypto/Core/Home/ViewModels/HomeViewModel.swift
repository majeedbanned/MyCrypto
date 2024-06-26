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
    private let portfolioDataService = PortfolioDataService()
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
        
        
        //update portfolio Coins
       $allCoins
            .combineLatest(portfolioDataService.$savedEntites)
            .map{(CoinModel ,PortfolioEntity)-> [CoinModel] in
                
                CoinModel.compactMap{(coin)->CoinModel? in
                    
                    
                    guard let entity = PortfolioEntity.first(where: {$0.coinId == coin.id}) else {
                        return nil
                    }
                    return coin.updateHoldings(amount: entity.amount)
                    
                }
            }
            .sink {[weak self] (returnedCoin) in
                self?.portfolioCoin = returnedCoin
            }
            .store(in: &cancellables)
        
        
        marketDataService.$MarketData
            .combineLatest($portfolioCoin)
            .map(mapGlobalMarketData)
            .sink {[weak self] (returnedValue) in
                self?.statestic=returnedValue
            }
            .store(in: &cancellables)
        
     
        
        
    }
    
    
    func updatePortfolio(coin: CoinModel,amount: Double){
        portfolioDataService.updatePortfolio(coin:coin  , amount: amount)
        
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
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel? , portfolioCoin : [CoinModel] )->[StatesticModel]{
        var stats: [StatesticModel] = []
        guard let data = marketDataModel else {return stats}
        
        let marketCap = StatesticModel(title: "Market Cap", value: data.marketCap,perentage: data.marketCapChangePercentage24HUsd)
        let volume = StatesticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatesticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoin
            .map({$0.currentHoldingsValue})
            .reduce(0,+)
        
        let perivioasValue =
            portfolioCoin
            .map{ (coin) -> Double in
                let currentValue=coin.currentHoldingsValue
                let persentChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currentValue / (1 + persentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let persentageChange = ((portfolioValue - perivioasValue)/perivioasValue) * 1000
        
        let portfolio = StatesticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(),perentage: persentageChange)
        
        stats.append(contentsOf: [
        marketCap,
        volume,
        btcDominance,portfolio
        ])
        return stats
    }
}
