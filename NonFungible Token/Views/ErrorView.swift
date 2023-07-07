//
//  ErrorView.swift
//  NonFungible Token
//
//  Created by BoiseITGuru on 7/6/23.
//

import SwiftUI

struct ErrorView: View {
    @State var error: String
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            Text(error)
                .foregroundStyle(Color.red)
                .padding(.horizontal, 15)
        }
    }
}
