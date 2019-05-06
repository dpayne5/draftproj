//
//  mtgJSONDATA.swift
//  
//
//  Created by Dusty Payne on 5/1/19.
//

import Foundation
import UIKit

struct mtgJSON : Decodable {
    let baseSetSize : Int?
    let block : String?
    //let boosterV3 : [String]?
    let cards : [CARDS]?
}

struct CARDS : Decodable {
    let colorIdentity : [String]?
    let convertedManaCost : Double?
    let manaCost : String?
    let name : String?
    let originalText : String?
    let originalType : String?
    let power : String?
    let rarity : String?
    let scryfallId : String?
    let scryfallIllustrationId : String?
    let toughness : String?
    let types : [String]?
    var open : Bool?
    var count : Int?
    
    private enum Codingkeys: String, CodingKey {case colorIdentity, convertedManaCost, manaCost, name, originalText, originalType, power, rarity, scryfallId, scryfallIllustrationId, toughness, types, open, count }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Codingkeys.self)
        colorIdentity = try container.decodeIfPresent([String].self, forKey: .colorIdentity) ?? [""]
        convertedManaCost = try container.decodeIfPresent(Double.self, forKey: .convertedManaCost) ?? 0.0
        manaCost = try container.decodeIfPresent(String.self, forKey: .manaCost) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        originalText = try container.decodeIfPresent(String.self, forKey: .originalText) ?? ""
        originalType = try container.decodeIfPresent(String.self, forKey: .originalType) ?? ""
        power = try container.decodeIfPresent(String.self, forKey: .power) ?? ""
        rarity = try container.decodeIfPresent(String.self, forKey: .rarity) ?? ""
        scryfallId = try container.decodeIfPresent(String.self, forKey: .scryfallId) ?? ""
        scryfallIllustrationId = try container.decodeIfPresent(String.self, forKey: .scryfallIllustrationId) ?? ""
        toughness = try container.decodeIfPresent(String.self, forKey: .toughness) ?? ""
        types = try container.decodeIfPresent([String].self, forKey: .types) ?? [""]
        open = false
        count = 1
    }
    
    mutating func incrementCount() {
        count = count! + 1
        
    }
    
    mutating func decrementCount() {
        
        count = count! - 1
    }
   
}

class mtgJSONDATA {
    func getCards(url: String, completionHandler: @escaping ([CARDS], Error?)-> Void) {
        
        var cardSet = [CARDS]()
        guard let url = URL(string:url) else {return}
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error == nil {
                guard let data = data else {return}
                do {
                    let decoded = try JSONDecoder().decode(mtgJSON.self, from: data)
                    DispatchQueue.main.async {
                        for item in decoded.cards! {
                            cardSet.append(item)
                        }
                        completionHandler(cardSet, nil)
                    }
                } catch let jsonError {
                    print("Error serializing JSON: ", jsonError)
                }
            }
        })
        task.resume()
    }
    
    
    
    
    
    
   
    
    
    
}



