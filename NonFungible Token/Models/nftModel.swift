//
//  nftModel.swift
//  NonFungible Token
//
//  Created by BoiseITGuru on 7/6/23.
//

struct NFT: Identifiable, Codable {
    let id: UInt64
    let name: String
    let description: String
    let thumbnail: [String: String]
}
