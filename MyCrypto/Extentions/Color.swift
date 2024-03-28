//
//  Color.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/9/1403 AP.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = ColorTheme()
    
}

struct ColorTheme{
    
    let accent=Color("AccentColor")
    let background = Color("BackgroundColor")
    let green=Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText=Color("SecondaryTextColor")
}
