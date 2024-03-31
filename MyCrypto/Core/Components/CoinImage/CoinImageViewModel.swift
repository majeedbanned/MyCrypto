//
//  CoinImageViewModel.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/12/1403 AP.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject{
    @Published var image:UIImage? = nil
    @Published var isLoading:Bool = false
     
    private let coin :CoinModel
    private let dataService : CoinImageService 
    private var cancellable = Set<AnyCancellable>()
    
    init(coin:CoinModel){
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        assSubscribers()
        self.isLoading = true
    }
    private func assSubscribers(){
        dataService.$image
            .sink{[weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellable)
    }
}
