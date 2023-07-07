//
//  WaitingView.swift
//  NonFungible Token
//
//  Created by BoiseITGuru on 7/6/23.
//

import SwiftUI

struct WaitingView: View {
    var label: String
    
    var body: some View {
        VStack(spacing: 5) {
            ProgressView()
            Text(label)
                .font(.title2)
                .foregroundStyle(Color.white)
        }
        .frame(width: 200, height: 200)
        .background(Color.secondaryAccentColor)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.defualtAccentColor, lineWidth: 3)
        )
    }
}
