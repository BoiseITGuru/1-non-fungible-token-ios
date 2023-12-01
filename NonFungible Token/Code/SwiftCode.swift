//
//  SwiftCode.swift
//  NonFungible Token
//
//  Created by BoiseITGuru on 11/30/23.
//

import Foundation
import FlowComponents

enum SwiftCode: CadenceCode {
    case setupCollection
    
    var fileName: String {
        switch self {
        case .setupCollection:
            return "setupCollection.cdc"
        }
    }
    
    var code: String {
        switch self {
        case .setupCollection:
            return """
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
            """
        }
    }
}
