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

struct MainView: View {
    @State var showCodeSheet: Bool = false
    @StateObject var codeConfig: CodeViewConfig = CodeViewConfig(title: "Title", description: "Description", swiftCode: Scripts.getNFTs, cadenceCode: Transactions.setupCollection)
    @State var nfts: [NFT] = []
    
    var body: some View {
        VStack {
            AcademyHeader()
            
            setupCollection
            
            mintNFTsView
            
            getNFTsView
            
            Spacer()
        }
        .sheet(isPresented: $showCodeSheet, onDismiss: { codeConfig.codeType = .swift }) {
            CodeSheet(codeType: $codeConfig.codeType, title: $codeConfig.title, description: $codeConfig.description, swiftCode: $codeConfig.swiftCode, cadenceCode: $codeConfig.cadenceCode)
        }
    }
    
    var setupCollection: some View {
        GroupBox(label: Text("1. Setup Your Collection"), content: {
            VStack {
                Text("In order to receive your NFTs you must first setup a collection.")
                    .multilineTextAlignment(.center)
                    .padding(.vertical)

                
                Button(action: {
                    updateCodeConfig(title: "setupCollection Transaction", description: "This is the FCL code that runs a transaction to setup a collection for the connected user.", swiftCode: SwiftCode.setupCollection, cadenceCode: Transactions.setupCollection)
                }, label: {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left.slash.chevron.right")
                            .font(.body)
                        Text("View Transaction")
                    }
                })
                .foregroundStyle(Color.eaPrimary)
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 3)
                
                ButtonView(title: "Setup Vault") {
                    Task {
                        do {
                            let id = try await fcl.mutate(cadence: Transactions.setupCollection.code)
                            
                            flowManager.subscribeTransaction(txId: id)
                        } catch {
                            print(error)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
            }
        })
    }
    
    var mintNFTsView: some View {
        GroupBox(label: Text("2. Mint NFTs to Your Account"), content: {
            Text("Time to go back to your terminal! Look for the scripts directory and execute the mint function.")
                .multilineTextAlignment(.center)
                .padding(.vertical)
        })
    }
    
    var getNFTsView: some View {
        GroupBox(label: Text("3. Get NFTs"), content: {
            VStack {
                Text("Now, we are going to run a script to get all the NFTs stored in your collection.")
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                
                Button(action: {
                    updateCodeConfig(title: "getNFTs Script", description: "This is the FCL code that runs a transaction to setup a vault for the connected user.", swiftCode: Transactions.transfer, cadenceCode: Transactions.setupCollection)
                }, label: {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left.slash.chevron.right")
                            .font(.body)
                        Text("View Script")
                    }
                })
                .foregroundStyle(Color.eaPrimary)
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 3)
                
                ButtonView(title: "Get Balance") {
                    Task {
                        await getNFTs()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
            }
        })
    }
    
    func getNFTs() async {
        do {
            let block = try await fcl.query {
                cadence {
                    Scripts.getNFTs.code
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
                flowManager.txError = error.localizedDescription
            }
        }
    }
    
    func setupAccount() async {
        do {
            let txId = try await fcl.mutate(cadence: Transactions.setupCollection.code)
            flowManager.subscribeTransaction(txId: txId)
        } catch {
            print(error)
        }
    }
    
    private func updateCodeConfig(title: String, description: String, swiftCode: CadenceCode, cadenceCode: CadenceCode) {
        codeConfig.title = title
        codeConfig.description = description
        codeConfig.swiftCode = swiftCode
        codeConfig.cadenceCode = cadenceCode
            
        self.showCodeSheet = true
    }
}
