//
//  Album.swift
//  ItunesAPI
//
//  Created by Marcus Larson on 16/10/16.
//  Copyright © 2016 IVaE. All rights reserved.
//

import Foundation

struct Album {
    let title : String
    let price : String
    let thumbnailImageURL : String
    let largeImageURL : String
    let itemURL : String
    let artistURL : String
    let collectionId: Int
    
    init(name: String, price: String, thumbnailImageURL: String, largeImageURL:String, itemURL:String, artistURL:String, collectionId: Int){
        self.title = name
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
        self.collectionId = collectionId
    }
    
    static func albumsWithJSON(results:NSArray) -> [Album] {
        var albums = [Album]()
        
        if results.count>0 {
            for result in results as! [NSDictionary] {
                var name = result["trackName"]  as? String
                if name == nil {
                    name = result["collectionName"] as? String
                }
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string.
                var price = result["formattedPrice"] as? String
                if price == nil {
                    let priceFloat: Float? = result["collectionPrice"] as? Float
                    let nf: NumberFormatter = NumberFormatter()
                    nf.maximumFractionDigits = 2
                    if priceFloat != nil {
                        price  = "$\(nf.string(from: NSNumber(value: priceFloat!))!)"
                    }
                }
                
                let thumbnailURL = result["artworkUrl60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String
                }
                
                if let collectionId = result["collectionId"] as? Int {
                    let newAlbum = Album(name: name!,
                                     price: price!,
                                     thumbnailImageURL: thumbnailURL,
                                     largeImageURL: imageURL,
                                     itemURL: itemURL!,
                                     artistURL: artistURL,
                                     collectionId: collectionId)
                    albums.append(newAlbum)
                }
                
            }
        }
        return albums
        
    }

}


