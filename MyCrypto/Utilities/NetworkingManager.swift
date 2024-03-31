//
//  NetworkingManager.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/12/1403 AP.
//

import Foundation
import Combine
class NetworkingManager{
   
    enum NetworkingError : LocalizedError{
        case badUrlResponse(url: URL)
        case unknow
        
        var errorDescription: String?{
            switch self {
            case .badUrlResponse(url :let url) : return " Bad Response From URL.URL:\(url)"
            case .unknow : return "Unknow error occured."
            }
        }
    }
    
    
    // with creating static func . its not nessessary to create an instance of class, just call networkingManager.download
    static func download(url:URL)->
    AnyPublisher<Data, any Error>
    {
        
    return  URLSession.shared.dataTaskPublisher(for: url)
           .subscribe(on: DispatchQueue.global(qos: .default))
           .tryMap({try handleUrlREsponse(output:$0 ,url: url)})
//           .tryMap { (output) -> Data in
//
//               guard let response = output.response as? HTTPURLResponse,
//                     response.statusCode>=200 && response.statusCode < 300 else {
//                   throw URLError(.badServerResponse )
//               }
//               return output.data
//
//           }
           .receive(on: DispatchQueue.main)
           .eraseToAnyPublisher()
    }
    
    static func handleUrlREsponse(output: URLSession.DataTaskPublisher.Output,url:URL) throws -> Data{
        
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode>=200 && response.statusCode < 300 else {
            throw NetworkingError.badUrlResponse(url: url)
        }
        return output.data
    }
    
    static func handleComplition (completion:Subscribers.Completion<Error>){
        
        switch completion{
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
