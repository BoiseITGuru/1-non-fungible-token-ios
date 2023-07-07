//
//  RouterView.swift
//  NonFungible Token
//
//  Created by BoiseITGuru on 7/6/23.
//

import SwiftUI
import FCL

struct RouterView: View {
    @State var loggedIn: Bool = false
    @State var pendingTx: Bool = false
    @State var showErrorView: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            Group {
                if !loggedIn {
                    SignInView()
                } else {
                    MainView()
                }
            }
            .padding(.horizontal, 20)
            
            if pendingTx {
                WaitingView(label: "Processing Transaction")
            }
        }
        .sheet(isPresented: $showErrorView, onDismiss: { FlowManager.shared.txError = nil }, content: {
            ErrorView(error: FlowManager.shared.txError ?? "")
        })
        .onReceive(fcl.$currentUser) { user in
            self.loggedIn = (user != nil)
        }
        .onReceive(FlowManager.shared.$pendingTx) { tx in
            self.pendingTx = (tx != nil)
        }
        .onReceive(FlowManager.shared.$txError) { error in
            self.showErrorView = (error != nil)
        }
    }
}
