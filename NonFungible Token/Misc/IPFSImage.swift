//
//  IPFSImage.swift
//  FLOAT
//
//  Created by BoiseITGuru on 8/28/22.
//

import SwiftUI
import CachedAsyncImage

struct IPFSImage: View {
    @State var cid: String
    
    var body: some View {
        CachedAsyncImage(url: URL(string: "https://nftstorage.link/ipfs/\(cid)")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if phase.error != nil {
                Image(systemName: "exclamationmark.triangle.fill")
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
}
