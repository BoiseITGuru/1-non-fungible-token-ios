//
//  NFTView.swift
//  NonFungible Token
//
//  Created by BoiseITGuru on 7/6/23.
//

import SwiftUI
import FCL
import Flow

struct MainView: View {
    @State var nfts: [NFT] = []
    
    var body: some View {
        VStack {
            HStack(spacing: 6) {
                Image("ea-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                Text("Emerald Academy")
                    .font(.title)
                    .foregroundStyle(Color.defualtAccentColor)
            }
            
            ButtonView(title: "Get NFTs", action: { Task { await getNFTs() } })
                .padding(.bottom, 4)
            
            TabView {
                ForEach(nfts, id: \.id) { nft in
                    NFTView(nft: nft)
                }
            }
            .tabViewStyle(.page)
            
            Spacer()
            
            ButtonView(title: "Setup Account", action: { Task { await setupAccount() } })
            ButtonView(title: "Sign Out", action: { Task { try? await fcl.unauthenticate() } })
        }
    }
    
    func getNFTs() async {
        do {
            let block = try await fcl.query {
                cadence {
                    Scripts.getNFTs.rawValue
                }
                
                arguments {
                    [ .address(fcl.currentUser!.address) ]
                }

                gasLimit {
                    1000
                }
            }.decode([NFT].self)
            await MainActor.run {
                nfts = block
            }
        } catch {
            await MainActor.run {
                FlowManager.shared.txError = error.localizedDescription
            }
        }
    }
    
    func setupAccount() async {
        do {
            let txId = try await fcl.mutate(cadence: Transactions.setupCollection.rawValue)
            FlowManager.shared.subscribeTransaction(txId: txId)
        } catch {
            print(error)
        }
    }
}
