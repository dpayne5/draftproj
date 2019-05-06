//
//  draftCardPicks.swift
//  draftproj
//
//  Created by Dusty Payne on 4/26/19.
//  Copyright © 2019 Dusty Payne. All rights reserved.
//

import Foundation
import MTGSDKSwift
import UIKit

/* Globals intended to be used to track all picks and sideboard choices
   This struct is intended to be used in the DraftPicksVC */
struct draftCardPicks {
    
    
    static var mainboardPicks = [CARDS]()
    static var sideboardPicks = [CARDS]()
    
    static var basicLANDS = [CARDS]()
    
    
    
    static var botPICKS = [[CARDS](),[CARDS](),[CARDS](),[CARDS](),[CARDS](),[CARDS](),[CARDS](), [CARDS]()] //removed one cardPACK
    
    
    static func addToMB(pickedCard: CARDS) {
        
        
        
        if !self.mainboardPicks.isEmpty {
            
            for index in 0 ... self.mainboardPicks.count - 1 {
                if (self.mainboardPicks[index].name == pickedCard.name) {
                    self.mainboardPicks[index].count = self.mainboardPicks[index].count! + 1
                    return
                }
            }
            
        }
        
        
        
        self.mainboardPicks.append(pickedCard)
    }
    
    static func addToSB(pickedCard: CARDS) {
        
        if !self.sideboardPicks.isEmpty {
            for index in 0 ... self.sideboardPicks.count - 1 {
                if (self.sideboardPicks[index].name == pickedCard.name) {
                    self.sideboardPicks[index].count = self.sideboardPicks[index].count! + 1
                    return
                }
            }
            
        }
        self.sideboardPicks.append(pickedCard)
        
    }
        
        
    
    static func addToBot(botNum: Int, pickedCard: CARDS) {
        self.botPICKS[botNum].append(pickedCard)
    }
    
    
    /* Sorts arrays by cost of cards*/
    static func sortbyCost() {
        
        
        self.mainboardPicks = self.mainboardPicks.sorted(by: {$0.convertedManaCost! < $1.convertedManaCost!})
        self.sideboardPicks = self.sideboardPicks.sorted(by: {$0.convertedManaCost! < $1.convertedManaCost!})
        
        
    }
    
    /* Clears decks, used on return to title screen*/
    static func clearDecks() {
        self.mainboardPicks = [CARDS]()
        self.sideboardPicks = [CARDS]()
        
        self.botPICKS = [[CARDS](),[CARDS](),[CARDS](),[CARDS](),[CARDS](),[CARDS](),[CARDS](), [CARDS]()]
    }
    
    /* Will need to be changed once I get the property settled for CARDS of cardCOUNT!*/
    static func totalDraftedCards() -> Int {
        var totalCount = 0
        
        for MBcard in mainboardPicks {
            totalCount = totalCount + MBcard.count!
        }
        
        for SBcard in sideboardPicks {
            totalCount = totalCount + SBcard.count!
        }
        return totalCount
        
        
    }
    
    static func totalMainDeck() -> Int {
        
        var totalCount = 0
        
        for MBcard in mainboardPicks {
            totalCount = totalCount + MBcard.count!
        }
        
        return totalCount
        
    }
    
    static func moveToSB(MBindex: Int) {
        
        if !cardIsInSB(card: mainboardPicks[MBindex]) { //needs to be if card not in SB, not if SB empty
            
            
            self.sideboardPicks.append(self.mainboardPicks[MBindex])
            self.sideboardPicks[self.sideboardPicks.count - 1].count = 1
            
            self.mainboardPicks[MBindex].count = self.mainboardPicks[MBindex].count! - 1
            
            if self.mainboardPicks[MBindex].count == 0 {
                self.mainboardPicks.remove(at: MBindex)
            }
            sortbyCost()
            
            return
            
        }
        
        else if cardIsInSB(card: mainboardPicks[MBindex]) {
            
            //let MBindex = self.mainboardPicks.firstIndex(where: {$0.name == cardFromMB.name})
            
            for index in 0 ... self.sideboardPicks.count - 1 {
                if self.sideboardPicks[index].name  == self.mainboardPicks[MBindex].name {
                    self.sideboardPicks[index].count = self.sideboardPicks[index].count! + 1
                    self.mainboardPicks[MBindex].count = self.mainboardPicks[MBindex].count! - 1
                    
                    if self.mainboardPicks[MBindex].count == 0 {
                        self.mainboardPicks.remove(at: MBindex)
                    }
                    return
                }
            }
            
        }
        
        
    }
    
    
    static func moveToMB(SBindex: Int) {
        
        if !cardIsInMB(card: self.sideboardPicks[SBindex]) {
            self.mainboardPicks.append(self.sideboardPicks[SBindex])
            self.mainboardPicks[self.mainboardPicks.count - 1].count = 1
            
            self.sideboardPicks[SBindex].count = self.sideboardPicks[SBindex].count! - 1
            
            if self.sideboardPicks[SBindex].count == 0 {
                self.sideboardPicks.remove(at: SBindex)
            }
            sortbyCost()
            return
            
        }
        
        else if cardIsInMB(card: self.sideboardPicks[SBindex]) {
            
            for index in 0 ... self.mainboardPicks.count - 1 {
                if self.mainboardPicks[index].name  == self.sideboardPicks[SBindex].name {
                    self.mainboardPicks[index].count = self.mainboardPicks[index].count! + 1
                    self.sideboardPicks[SBindex].count = self.sideboardPicks[SBindex].count! - 1
                    
                    if self.sideboardPicks[SBindex].count == 0 {
                        self.sideboardPicks.remove(at: SBindex)
                    }
                    return
                }
            }
            
            
            
            
        }
        
    }
    
    static func cardIsInMB(card: CARDS) -> Bool {
        if self.mainboardPicks.isEmpty {return false}
        
        for index in 0 ... self.mainboardPicks.count - 1{
            if card.name == self.mainboardPicks[index].name {
                return true
            }
        }
        
        return false
    }
    
    static func cardIsInSB(card: CARDS) -> Bool {
        if self.sideboardPicks.isEmpty {return false}
        
        for index in 0 ... self.sideboardPicks.count - 1 {
            
            if card.name == self.sideboardPicks[index].name {
                return true
            }
            
        }
        
        return false
        
    }
    
    /* Checks for nil values, returns empty string instead */
    static func displayVAL(info: String?) -> String {
        if info == nil {
            return ""
        }
        return info!
    }
    
    static func setBasicLands(commonset: [CARDS]) -> [CARDS] {
        
        var basicLands = [CARDS]()
        
        /* Bandaid fix since I can't figure out how to initialize the array to size 5*/
        for i in 0 ... 4 {
            basicLands.append(commonset[i])
        }
        
        
        for card in commonset {
            switch card.name {
            case "Plains":
                basicLands[0] = card
            case "Island":
                basicLands[1] = card
                
            case "Swamp":
                basicLands[2] = card
                
            case "Mountain":
                basicLands[3] = card
                
            case "Forest":
                basicLands[4] = card
                
            default:
                _ = 1
            }
        }
        
        return basicLands
    }
    
    
}
