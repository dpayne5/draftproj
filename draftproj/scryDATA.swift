//
//  scryDATA.swift
//  draftproj
//
//  Created by Dusty Payne on 5/2/19.
//  Copyright © 2019 Dusty Payne. All rights reserved.
//

import Foundation

let urlString = "https://api.scryfall.com/cards/"

struct scryDATA : Decodable {
    
    
    let image_uris : imageURIS?
    /*
    private enum Codingkeys: String, CodingKey {case image_uris }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Codingkeys.self)
        image_uris = try! container.decodeIfPresent(imageURIS.self, forKey: .image_uris)
    }*/
    
}

struct imageURIS : Decodable {
    let small : String?
    let normal : String?
    let large : String?
    let png : String?
}

class scryData {
    
    func callScryCard(scryID:String, completionHandler: @escaping (String, Error?)-> Void) {
        //need soemthing for the image url here
        let cardURL = urlString + scryID
        
        
        
        
        guard let url = URL(string: cardURL) else {return}
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error == nil {
                guard let data = data else {return}
                do {
                    let decoded = try JSONDecoder().decode(scryDATA.self, from: data)
                    DispatchQueue.main.async {
                        var cardImageUrl : String
                        cardImageUrl = (decoded.image_uris?.normal)!
                        
                        completionHandler(cardImageUrl, nil)
                    }
                } catch let jsonError {
                    print("Error serializing JSON: ", jsonError)
                }
            }
        })
        task.resume()
        
    }
}
