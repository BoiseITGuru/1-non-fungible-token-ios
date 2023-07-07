//
//  NonFungible_TokenApp.swift
//  NonFungible Token
//
//  Created by BoiseITGuru on 7/6/23.
//

import SwiftUI

@main
struct NonFungible_TokenApp: App {
    
    init() {
        FlowManager.shared.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            RouterView()
        }
    }
}
