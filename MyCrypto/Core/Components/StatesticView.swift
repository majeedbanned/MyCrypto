//
//  StatesticView.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/13/1403 AP.
//

import SwiftUI

struct StatesticView: View {
    let stat:StatesticModel
    var body: some View {
        VStack(alignment:.leading,spacing: 4){
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption)
                    .rotationEffect(Angle(degrees:
                                            (stat.perentage ?? 0) >= 0 ? 0 : 180
                                         
                                         ))
                Text(stat.perentage?.asPercentString() ?? "")
                    .font(.caption)
                .bold()
                
               
                    
            }
            .foregroundColor( (stat.perentage ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.perentage == nil ? 0 : 1)
            
        }
    }
}

struct StatesticView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group{
            StatesticView(stat:dev.state1)
                .previewLayout(.sizeThatFits)
            StatesticView(stat:dev.state2)
                .previewLayout(.sizeThatFits)
            StatesticView(stat:dev.state3)
                .previewLayout(.sizeThatFits)
        }
    }
}
