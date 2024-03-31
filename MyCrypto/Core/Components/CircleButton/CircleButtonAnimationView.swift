//
//  CircleButtonAnimationView.swift
//  MyCrypto
//
//  Created by majid ghasemi on 1/10/1403 AP.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animate:Bool
    var body: some View {
       Circle()
            .stroke(lineWidth: 5)
            .scale(animate ? 1 : 0)
            .opacity(animate ? 0 : 1)
            .animation(animate ? Animation.easeOut(duration: 1) : .none)
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
    }
}
