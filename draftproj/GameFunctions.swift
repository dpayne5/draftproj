//
//  GameFunctions.swift
//  draftproj
//
//  Created by Dusty Payne on 4/19/19.
//  Copyright © 2019 Dusty Payne. All rights reserved.
//

import Foundation

import MTGSDKSwift
import UIKit
import PromiseKit


class GameFunctions {
    
    var magic = Magic()
    
    let basicLands = ["Plains", "Island", "Swamp", "Mountain", "Forest"]
        
    
    func generateJSONboosters(setRecieved: [CARDS]) -> [[CARDS]] {
        var boosters = [[CARDS]]()
        var commons = [CARDS]()
        var uncommons = [CARDS]()
        var rares = [CARDS]()
        var mythics = [CARDS]()
        var lands = [CARDS]()
        
        /* seperate cards by rarity */
        for card in setRecieved {
            switch card.rarity {
            case "common":
                if (!(card.types?.isEmpty)! && card.types![0] == "Land") {
                    if (card.name?.count)! > 8 {
                        lands.append(card)
                    }
                    //lands.append(card)
                }
                else {
                    commons.append(card)
                }
            case "uncommon":
                uncommons.append(card)
            case "rare":
                rares.append(card)
            case "mythic":
                mythics.append(card)
            default:
                print("error assigning rarity")
                
            }
        }
        
        /* fill each booster with a the correct number of random cards from each pool */
        
        for i in 0 ... 7 {
            
            var newBooster = [CARDS]()
            
            newBooster.append(lands[Int.random(in: 0 ... lands.count - 1)])
            newBooster.append(contentsOf: generateJSONCommons(commonset: commons))
            newBooster.append(contentsOf: generateJSONUncommons(uncommonset: uncommons))
            newBooster.append(contentsOf: generateJSONRares(rareset: rares, mythicset: mythics))
            
            boosters.append(newBooster)
            
        }
        
        
        
        
        return boosters
    }
    
    
    /* returns an array of 8 pack from the set */
    func generateBoosters(setofCards: [Card]) -> [[Card]] {
        var boosters = [[Card]]()
        var commons = [Card]()
        var uncommons = [Card]()
        var rares = [Card]()
        var mythics = [Card]()
        
        
        
        /* Here seperate the set into commons, uncommons, rares
           This creates 3 seperate arrays*/
        
        for card in setofCards {
            
            switch card.rarity {
            case "Common":
                commons.append(card)
            case "Uncommon":
                if card.types![0] != "Planeswalker" {
                    uncommons.append(card)
                }
                else if card.originalText != nil {
                    uncommons.append(card)
                }
            case "Rare":
                if card.types![0] != "Planeswalker" {
                    rares.append(card)
                }
                else if card.originalText != nil {
                    rares.append(card)
                }
            case "Mythic":
                if card.types![0] != "Planeswalker" {
                    mythics.append(card)
                }
                else if card.originalText != nil {
                    mythics.append(card)
                }
            default:
                print("error assigning card rarity types")
                
            }
        }
        
        for _ in 1 ... 8 {
            var newBooster = [Card]()
            
            //need to append a land/gate card here
            newBooster.append(contentsOf: generateCommons(commonset: commons))
            newBooster.append(contentsOf: generateUncommons(uncommonset: uncommons))
            newBooster.append(contentsOf: generateRares(rareset: rares, mythicset: mythics))
            
            boosters.append(newBooster)
        }
        return boosters
    }
    
    /* Picks 10 commons from the set at random*/
    func generateCommons(commonset: [Card]) -> [Card] {
        let total = commonset.count
        var commonsOfPack = [Card]()
        
        for _ in 1 ... 11 {
            let number = Int.random(in: 0 ... 5000)
            commonsOfPack.append(commonset[number % total])
        }
        
        return commonsOfPack
    }
    
    func generateJSONCommons(commonset: [CARDS]) -> [CARDS] {
        let total = commonset.count
        var commonsOfPack = [CARDS]()
        
        while commonsOfPack.count != 10 {
            let number = Int.random(in: 0 ... 5000)
            
            if !cardInGeneratedPack(Qcard: commonset[number % total], pack: commonsOfPack) {
                commonsOfPack.append(commonset[number % total])
            }
            //check if the item is in the pack, if not add it
            
        }
        
        
        return commonsOfPack
    }
    
    /* Picks 3 uncommons from the set, passes them to the pack. */
    func generateUncommons(uncommonset: [Card]) -> [Card] {
        let total = uncommonset.count
        var uncommonsOfPack = [Card]()
        
        for _ in 1 ... 3 {
            let number = Int.random(in: 0 ... 5000)
            uncommonsOfPack.append(uncommonset[number % total])
        }
        
        return uncommonsOfPack
    }
    
    func generateJSONUncommons(uncommonset: [CARDS]) -> [CARDS] {
        let total = uncommonset.count
        var uncommonsOfPack = [CARDS]()
        
        while uncommonsOfPack.count != 3 {
            let number = Int.random(in: 0 ... 5000)
            
            if !cardInGeneratedPack(Qcard: uncommonset[number % total], pack: uncommonsOfPack) {
                uncommonsOfPack.append(uncommonset[number % total])
            }
            
        }
        
        
        return uncommonsOfPack
    }
    /* Picks a rare 7/8ths of the time, a mythic 1/8th of the time.*/
    func generateRares(rareset: [Card], mythicset: [Card]) -> [Card] {
        var rareOfPack = [Card]()
        //need to check if every set has a mythic to make sure im not passing nil
        let isMythic = Int.random(in: 1 ... 9)
        if isMythic == 8 {
            rareOfPack.append(mythicset[Int.random(in: 0 ... mythicset.count)])
        }
        else {
            rareOfPack.append(rareset[Int.random(in: 0 ... rareset.count)])
        }
        return rareOfPack
    }
    
    func generateJSONRares(rareset: [CARDS], mythicset: [CARDS]) -> [CARDS] {
        var rareOfPack = [CARDS]()
        //need to check if every set has a mythic to make sure im not passing nil
        let isMythic = Int.random(in: 1 ... 9)
        if isMythic == 8 {
            rareOfPack.append(mythicset[Int.random(in: 0 ... mythicset.count - 1)])
        }
        else {
            rareOfPack.append(rareset[Int.random(in: 0 ... rareset.count - 1)])
        }
        return rareOfPack
    }
    
    /* Passes pack to left */
    func passRight(gamepacks: [[CARDS]]) -> [[CARDS]] {
        var passedRight = Array<[CARDS]>(repeating: [CARDS](), count: 8)
        let firstEl = gamepacks[gamepacks.count - 1]
        //passedRight.append(firstEl)
        
        for i in 0 ... gamepacks.count - 2 {
            passedRight[i+1] = gamepacks[i]
            
        }
        passedRight[0] = firstEl
        
        return passedRight
    }
    /* Passes pack to right */
    func passLeft(gamepacks: [[CARDS]]) -> [[CARDS]] {
        var passedLeft = Array<[CARDS]>(repeating: [CARDS](), count: 8)
        
        let lastElement = gamepacks[0]
        //passedLeft[7] = gamepacks[0]
        
        for i in stride(from: gamepacks.count - 1, through: 1, by: -1) {
            passedLeft[i-1] = gamepacks[i]
        }
        
        passedLeft[passedLeft.count - 1] = lastElement
        return passedLeft
    }
    
    /* Checks to see what the */
    func isLeftPass(roundNumber: Int) -> Bool {
        
        if roundNumber % 2 == 0 {
            return false
        }
        
        return true
    }
    
    func cardAIPick(botNum: Int, cardPack: [CARDS]) -> Int {
        
        if !draftCardPicks.botPICKS[botNum].isEmpty {
            let colorToPick = mainColor(picksSoFar: draftCardPicks.botPICKS[botNum])
            return pickBasedOnColor(primaryColor: colorToPick, cardPack: cardPack)
            
        }
        return Int.random(in: 0 ... cardPack.count - 1)
      
    }
    
    func mainColor(picksSoFar: [CARDS]) -> String {
        
        
        var colorCount = ["U":0, "G":0, "B":0, "R":0, "W":0]
        
        //iterate through each card
        for card in picksSoFar {
            //accumulate the total colors of picks so far
            for colorID in card.colorIdentity! {
                switch colorID {
                case "G":
                    colorCount["G"] = colorCount["G"]! + 1
                case "R":
                    colorCount["R"] = colorCount["R"]! + 1
                case "W":
                    colorCount["W"] = colorCount["W"]! + 1
                case "B":
                    colorCount["B"] = colorCount["B"]! + 1
                case "U":
                    colorCount["U"] = colorCount["U"]! + 1
                default:
                    print("no colorID")
                }
            }
            
        }
        let mainCOLOR = colorCount.max {a,b in a.value < b.value}

        return mainCOLOR?.key ?? ""
    }
    
    
    func pickBasedOnColor (primaryColor: String, cardPack: [CARDS]) -> Int {
        
        let nonPickableTypes = ["Artifact", "Land"]
        
        
        for index in 0 ... cardPack.count - 1 {
            
            
            if !(cardPack[index].colorIdentity?.isEmpty)! {
                if !nonPickableTypes.contains(cardPack[index].types![0]) {
                    do {
                        if cardPack[index].colorIdentity![0] == primaryColor {
                            return index
                        }
                    }
                }
                
            }
     }
        return Int.random(in: 0 ... cardPack.count - 1)
        
    }
    
    
    func cardInGeneratedPack(Qcard: CARDS, pack: [CARDS]) -> Bool {
        
        if pack.isEmpty {return false}
        
        for card in pack {
            if card.name == Qcard.name {
                return true
            }
        }
        return false
        
    }
    
    
}
