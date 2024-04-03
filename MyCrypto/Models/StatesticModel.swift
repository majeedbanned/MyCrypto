//
//  StatesticModel.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/13/1403 AP.
//

import Foundation

struct StatesticModel:Identifiable{
    let id = UUID().uuidString
    let title:String
    let value:String
    let perentage:Double?
    init(title:String, value:String,perentage :Double?=nil){
        
        self.title=title
        self.value = value
        self.perentage = perentage
    }
    
}

