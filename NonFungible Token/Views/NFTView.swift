//
//  NFTView.swift
//  NonFungible Token
//
//  Created by BoiseITGuru on 7/6/23.
//

import SwiftUI
import FCL
import Flow

struct NFTView: View {
    @State var nft: NFT
    @State var transferAddress: String = ""
    
    
    var body: some View {
        VStack {
            HStack {
                Text(nft.name)
                    .foregroundStyle(Color.white)
                Spacer()
                Text("\(nft.id)")
                    .foregroundStyle(Color.white)
            }
            
            Text(nft.description)
                .foregroundStyle(Color.white)
            
            IPFSImage(cid: nft.thumbnail["url"] ?? "")
                .frame(width: 300)
            
            TextField("Transfer To Address", text: $transferAddress)
                .submitLabel(.send)
                .foregroundStyle(Color.white)
                .onSubmit {
                    guard transferAddress.isEmpty == false else { return }
                    Task { await transferNFT() }
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color.secondaryAccentColor)
                .cornerRadius(15)
                .padding(3)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.defualtAccentColor, lineWidth: 3)
                )
                .padding(.bottom, 4)
            
            ButtonView(title: "Transfer", action: { Task { await transferNFT() } })
        }
    }
    
    func transferNFT() async {
        do {
            let txId = try await fcl.mutate(cadence: Transactions.transfer.rawValue, args: [.address(Flow.Address(hex: transferAddress)), .uint64(nft.id)])
            await MainActor.run {
                self.transferAddress = ""
            }
            FlowManager.shared.subscribeTransaction(txId: txId)
        } catch {
            print(error)
        }
    }
}
