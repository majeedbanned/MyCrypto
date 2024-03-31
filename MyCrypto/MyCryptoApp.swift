//
//  MyCryptoApp.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/9/1403 AP.
//

import SwiftUI

@main
struct MyCryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
                    .environmentObject(vm)
            }
        }
    }
}
