//
//  splashView.swift
//  Delphi
//
//  Created by Kelsey Larson on 12/27/23.
//

import SwiftUI

struct splashView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.container)
            Image("delphi")
                .resizable()
                .scaledToFit()
                
        }
        .background(.black)
    }
}

#Preview {
    splashView()
}
