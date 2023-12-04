//
//  NFTView.swift
//  NonFungible Token
//
//  Created by BoiseITGuru on 7/6/23.
//

import SwiftUI
import FCL
import Flow
import FlowComponents
import ecDAO

struct NFTSheetView: View {
    @Environment(AppProperties.self) private var appProps
    @Binding var NFTs: [NFT]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                Text("Your NFT Collection")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                
                if appProps.isiPad {
                    HStack {
                        ForEach(NFTs) { nft in
                            NFTView(nft: nft)
                        }
                    }
                } else {
                    TabView {
                        ForEach(NFTs) { nft in
                            NFTView(nft: nft)
                                .tag(nft.id)
                        }
                    }
                    .tabViewStyle(.page)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct NFTView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(FlowManager.self) private var flowManager
    @State var nft: NFT
    @State var transferAddress: String = ""
    
    
    var body: some View {
        VStack {
            Text(nft.name)
                .font(.title2)
            
            Text(nft.description)
                .font(.caption)
                .multilineTextAlignment(.center)
                .frame(minHeight: 30)
            
            IPFSImage(cid: nft.thumbnail["url"] ?? "")
                .frame(width: 200)
            
            TextField("Transfer To Address", text: $transferAddress)
                .submitLabel(.send)
                .foregroundStyle(Color.white)
                .onSubmit {
                    guard transferAddress.isEmpty == false else { return }
                    Task { await transferNFT() }
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .padding(3)
                .background(colorScheme == .dark ? Color.black.opacity(0.4) : Color.white.opacity(0.4))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.eaPrimary, lineWidth: 3)
                )
                .padding(.bottom, 4)
            
            ButtonView(title: "Transfer", action: { Task { await transferNFT() } })
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    func transferNFT() async {
        await flowManager.mutate(cadence: Transactions.transfer.code, args: [.address(Flow.Address(hex: transferAddress)), .uint64(nft.id)])
        await MainActor.run {
            self.transferAddress = ""
        }
    }
}
