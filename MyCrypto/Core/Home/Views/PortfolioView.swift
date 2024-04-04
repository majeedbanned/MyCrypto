//
//  PortfolioView.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/14/1403 AP.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm:HomeViewModel
    @State private var selectedCoin : CoinModel?=nil
    @State private var quantityText : String = "" ;
    @State private var showCheckMark : Bool = false;
 
    var body: some View {
        
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    
                    coinLogoList
                    if selectedCoin != nil{
                      PortfolioSection
                        
                        
                    }

                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading){
                    XMarkButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                   trailingNavBArButton
                }
                
            })
            .onChange(of: vm.searchText) { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }

            
            
           
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.HomeVm)
    }
}


extension PortfolioView{
    
    private var coinLogoList:some View{
        
        ScrollView(.horizontal,showsIndicators: true) {
            LazyHStack(spacing: 10){
              //  ForEach(vm.searchText.isEmpty ? vm.portfolioCoin : vm.allCoins){ coin in
                    ForEach( vm.allCoins){ coin in
                    CoinLogoView(coin:coin)
                        .frame(width: 75)
                        .onTapGesture {
                            withAnimation(.easeIn){
                                selectedCoin = coin
                            }
                        }
                        
                        .background(
                        
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ?
                                        Color.theme.green :
                                            Color.clear ,lineWidth: 1)
                                
                                            
                        )
                       
                        
                }
              
            }
            .frame(height: 120)
            .padding(.vertical , 4)
            .padding(.leading)
            
        }
    }
    
    private func updateSelectedCoinTextInput(coin:CoinModel){
        selectedCoin = coin
      if let portfolioCoin = vm.portfolioCoin.first(where : {$0.id == coin.id}),
         let amount = portfolioCoin.currentHoldings{
          quantityText = "\(amount)"
      }
        else
        {
            quantityText = ""
        }
    }
    
    private func getCoinValue() -> Double{
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var PortfolioSection :some View{
        VStack(spacing: 20){
            HStack{
                
                Text("Current Price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                
                Text("Amount Holding: \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                TextField("Ex: 1.4", text :$quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current Value")
                Spacer()
                Text(getCoinValue().asCurrencyWith6Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBArButton :some View{
        HStack{
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1 : 0)
           Button(action: {
               saveButtonPressed()
           }, label: {
               Text("save".uppercased())
               
           })
           .opacity((selectedCoin != nil && selectedCoin?.currentPrice != Double(quantityText)) ? 1 : 0)

            
        }
        .font(.headline) 
    }
    
    private func saveButtonPressed(){
        guard let coin = selectedCoin,
        let amount = Double(quantityText)
        else {return}
        
        //save portfolio
        
        vm.updatePortfolio(coin: coin, amount: amount)
        
        
        withAnimation(.easeIn){
            showCheckMark = true
            removeSelectedCoin()
        }
        // hide keyboard
        UIApplication.shared.endEditing()
        
        //hidecheckmark
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            withAnimation(.easeOut)
            {
                showCheckMark = false
            }
        }
        
    
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
    
}
