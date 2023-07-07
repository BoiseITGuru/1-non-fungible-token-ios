//
//  FlowManager.swift
//  NonFungible Token
//
//  Created by BoiseITGuru on 7/6/23.
//

import FCL
import Flow
import Foundation
import UIKit

let testAccount = "YOUR TEST ACCOUNT"

class FlowManager: ObservableObject {
    static let shared = FlowManager()

    @Published var pendingTx: String? = nil
    
    @Published var txError: String? = nil
    
    func subscribeTransaction(txId: Flow.ID) {
        Task {
            do {
                DispatchQueue.main.async {
                    self.pendingTx = txId.hex
                }
                let tx = try await txId.onceSealed()
                await UIImpactFeedbackGenerator(style: .light).impactOccurred()
                print(tx)
                DispatchQueue.main.async {
                    if (tx.errorMessage != "") {
                        self.txError = tx.errorMessage
                    }
                    
                    self.pendingTx = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.pendingTx = nil
                    self.txError = error.localizedDescription
                }
            }
        }
    }

    func subscribeTransaction(txId: String) {
        let id = Flow.ID(hex: txId)
        self.subscribeTransaction(txId: id)
    }

    func setup() {
        let defaultProvider: FCL.Provider = .devWallet
        let defaultNetwork: Flow.ChainID = .emulator
        let accountProof = FCL.Metadata.AccountProofConfig(appIdentifier: "NonFungible Token")
        let walletConnect = FCL.Metadata.WalletConnectConfig(urlScheme: "nftDemo://", projectID: "482f2b2139f2983cb14bc23def87cec0")
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
}
