//
//  NonFungible_TokenApp.swift
//  NonFungible Token
//
//  Created by BoiseITGuru on 7/6/23.
//

import SwiftUI
import FCL
import Flow
import FlowComponents
import ecDAO

@main
struct NonFungible_TokenApp: App {
    let testAccount = "YOUR_TESTNET_ACCOUNT"
    let walletConnectID = "482f2b2139f2983cb14bc23def87cec0"
    @State private var title = "NonFungible Token"
    @State private var description = "A DApp that lets users create an empty collection, mint some pre-loaded NFTs, and transfer them to another account on Flow testnet."
    
    init() {
        let defaultProvider: FCL.Provider = .devWallet
        let defaultNetwork: Flow.ChainID = .emulator
        let accountProof = FCL.Metadata.AccountProofConfig(appIdentifier: title)
        let walletConnect = FCL.Metadata.WalletConnectConfig(urlScheme: "nftDemo://", projectID: walletConnectID)
        let metadata = FCL.Metadata(appName: "NonFungible Token",
                                    appDescription: "NonFungible Token Demo App for Emerald Academy",
                                    appIcon: URL(string: "https://academy.ecdao.org/ea-logo.png")!,
                                    location: URL(string: "https://academy.ecdao.org/")!,
                                    accountProof: accountProof,
                                    walletConnectConfig: walletConnect)
        fcl.config(metadata: metadata,
                   env: defaultNetwork,
                   provider: defaultProvider)

        fcl.config
            .put("0xDeployer", value: fcl.currentEnv == .emulator ? "0xf8d6e0586b0a20c7" : testAccount)
            .put("0xStandard", value: fcl.currentEnv == .emulator ? "0xf8d6e0586b0a20c7" : "0x631e88ae7f1d7c20")
    }
    
    var body: some Scene {
        WindowGroup {
            FlowApp {
                RouterView(title: $title, desc: $description) {
                    MainView()
                }
            }
            .ecDAOinit()
        }
    }
}
