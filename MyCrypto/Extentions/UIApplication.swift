//
//  UIApplication.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/12/1403 AP.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
