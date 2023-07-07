//
//  Transactions.swift
//  NonFungible Token
//
//  Created by BoiseITGuru on 8/27/22.
//

import Foundation

enum Transactions: String {
    case mintNFT =
        """
        import ExampleNFT from 0xDeployer
        import NonFungibleToken from 0xStandard

        transaction(name: String, description: String, thumbnail: String, recipient: Address) {
          let RecipientCollection: &ExampleNFT.Collection{NonFungibleToken.CollectionPublic}
          
          prepare(signer: AuthAccount) {
            self.RecipientCollection = getAccount(recipient).getCapability(ExampleNFT.CollectionPublicPath)
                                        .borrow<&ExampleNFT.Collection{NonFungibleToken.CollectionPublic}>()
                                        ?? panic("The recipient has not set up an ExampleNFT Collection yet.")
          }

          execute {
            ExampleNFT.mintNFT(recipient: self.RecipientCollection, name: name, description: description, thumbnail: thumbnail)
          }
        }
        """
    
    case mintNFTs =
        """
        import ExampleNFT from 0xDeployer
        import NonFungibleToken from 0xStandard

        transaction(names: [String], descriptions: [String], thumbnails: [String], recipient: Address) {
          let RecipientCollection: &ExampleNFT.Collection{NonFungibleToken.CollectionPublic}
          
          prepare(signer: AuthAccount) {
            self.RecipientCollection = getAccount(recipient).getCapability(ExampleNFT.CollectionPublicPath)
                                        .borrow<&ExampleNFT.Collection{NonFungibleToken.CollectionPublic}>()
                                        ?? panic("The recipient has not set up an ExampleNFT Collection yet.")
          }

          execute {
            var i = 0
            while i < names.length {
              ExampleNFT.mintNFT(recipient: self.RecipientCollection, name: names[i], description: descriptions[i], thumbnail: thumbnails[i])
              i = i + 1
            }
          }
        }
        """
    
    case setupCollection =
        """
        import ExampleNFT from 0xDeployer
        import NonFungibleToken from 0xStandard
        import MetadataViews from 0xStandard

        transaction() {
          
          prepare(signer: AuthAccount) {
            /*
              NOTE: In any normal DApp, you would NOT DO these next 2 lines. You would never want to destroy
              someone's collection if it's already set up. The only reason we do this for the
              tutorial is because there's a chance that, on testnet, someone already has
              a collection here and it will mess with the tutorial.
            */
            destroy signer.load<@NonFungibleToken.Collection>(from: ExampleNFT.CollectionStoragePath)
            signer.unlink(ExampleNFT.CollectionPublicPath)

            // This is the only part you would have.
            if signer.borrow<&ExampleNFT.Collection>(from: ExampleNFT.CollectionStoragePath) == nil {
              signer.save(<- ExampleNFT.createEmptyCollection(), to: ExampleNFT.CollectionStoragePath)
              signer.link<&ExampleNFT.Collection{NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>(ExampleNFT.CollectionPublicPath, target: ExampleNFT.CollectionStoragePath)
            }
          }

          execute {
            
          }
        }
        """
    
    case transfer =
        """
        import ExampleNFT from 0xDeployer
        import NonFungibleToken from 0xStandard

        transaction(recipient: Address, withdrawID: UInt64) {
          let ProviderCollection: &ExampleNFT.Collection{NonFungibleToken.Provider}
          let RecipientCollection: &ExampleNFT.Collection{NonFungibleToken.CollectionPublic}
          
          prepare(signer: AuthAccount) {
            self.ProviderCollection = signer.borrow<&ExampleNFT.Collection{NonFungibleToken.Provider}>(from: ExampleNFT.CollectionStoragePath)
                                        ?? panic("This user does not have a Collection.")

            self.RecipientCollection = getAccount(recipient).getCapability(ExampleNFT.CollectionPublicPath)
                                        .borrow<&ExampleNFT.Collection{NonFungibleToken.CollectionPublic}>()!
          }

          execute {
            self.RecipientCollection.deposit(token: <- self.ProviderCollection.withdraw(withdrawID: withdrawID))
          }
        }
        """
}
