//
//  CoinImageService.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/12/1403 AP.
//

import Foundation
import SwiftUI
import Combine
class CoinImageService{
    
    @Published var image:UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private let coin :CoinModel
    private let fileManager=LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName :String
    
    init(coin :CoinModel){
        self.coin=coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName:imageName, folderName: folderName){
            image = savedImage
        }
        else
            
        {
            DownloadCoinImage()
        }
    }
    private func DownloadCoinImage(){
        
        guard let url = URL(string: coin.image) else
        {return}
        
        //combine:
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data)-> UIImage?  in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: {[weak self] (returnedImage) in
                guard let self = self , let downlodedImage = returnedImage else {return}
                self.image = downlodedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downlodedImage, imageName: self.imageName, folderName: self.folderName)
            })
            
    }
}
