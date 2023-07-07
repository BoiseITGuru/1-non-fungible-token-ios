//
//  SignInView.swift
//  NonFungible Token
//
//  Created by BoiseITGuru on 7/6/23.
//

import SwiftUI
import FCL

struct SignInView: View {
    var body: some View {
        VStack {
            Text("NONFUNGIBLE-TOKEN")
                .font(.largeTitle)
                .foregroundColor(.defualtAccentColor)
                .padding(.bottom, 20)
            
            Image("ea-logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 100)
            
            Button {
                fcl.openDiscovery()
            } label: {
                Text("Log In")
                    .font(.title2)
                    .foregroundColor(.defaultTextColor)
            }
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(Color.defualtAccentColor)
                .cornerRadius(15)
                .buttonStyle(PlainButtonStyle())

                
        }
    }
}
