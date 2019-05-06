//
//  PickingWheelViewController.swift
//  draftproj
//
//  Created by Dusty Payne on 4/16/19.
//  Copyright © 2019 Dusty Payne. All rights reserved.
//

import UIKit

import iCarousel

import MTGSDKSwift

import SDWebImage

class PickingWheelViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    var cardSet = [Card]()
    
    let scry = scryData()
    
    
    /* Game functionality */
    var GF = GameFunctions()
    
    var roundNUMBER = 1
    var CARDTOTAL = 0
    
    
    var draftOver = false
    
    var jsonSetRecieved = [CARDS]()
    

    /* Array of all the packs for the round */
    var packsOfRound = [[CARDS]]()
    
    
    var cardRecieved: Card?
    var packRecieved: [Card]?
    var pack: [Int] = []
    var cardPack: [Card] = []
    var magic = Magic()
    
    @IBOutlet var carousel: iCarousel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //just to get 15 cards as a placeholder
        
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return packsOfRound[0].count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIImageView
        var backgroundView: UIImageView

        
        if let view = view as? UIImageView {
            itemView = view
            
            label = itemView.viewWithTag(1) as! UILabel
        } else {
            
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
            //backgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
            //loadImage(itemview: itemView, urlString: (cardRecieved?.imageUrl)!)
            
            
            scry.callScryCard(scryID: packsOfRound[0][index].scryfallId!) {cardImage, error in
                
                DispatchQueue.main.async {
                    //imageURL = cardImage
                    //itemView.translatesAutoresizingMaskIntoConstraints = false
                    itemView.contentMode = .scaleAspectFit
                    self.loadImage(itemview: itemView, urlString: cardImage)
                    
                    
                }
            }
            
            
            //loadImage(itemview: itemView, urlString: packRecieved![index].imageUrl!)
            
            itemView.contentMode = .center
            //itemView.backgroundColor = .red
            //backgroundView.backgroundColor = .blue
            //itemView.insertSubview(backgroundView, aboveSubview: itemView)
            label = UILabel(frame: itemView.bounds)
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = label.font.withSize(20)
            label.tag = 1
            itemView.addSubview(label)
            //label.text = packsOfRound[0][index].name
        }
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        //pick an item, add it to the players total picks, remove the card from the pack, play the next pack
              
        print(packsOfRound[0].count, " is the size of the pack being picked from")
        /* Pick the card, needs to be redone so ordering is correct*/
        draftCardPicks.addToMB(pickedCard: (packsOfRound[0].remove(at: index)))
        
        for i in 1 ... 7 {
            draftCardPicks.botPICKS[i].append(packsOfRound[i].remove(at: GF.cardAIPick(botNum: i, cardPack: packsOfRound[i])))
        }
        
        
        
        
        
        
        
        if !isEndOfDraft() {
            
            
            
            if draftCardPicks.totalDraftedCards() % 15 == 0 {
                packsOfRound = GF.generateJSONboosters(setRecieved: jsonSetRecieved)
                roundNUMBER = roundNUMBER + 1
            }
            
            else {
                if GF.isLeftPass(roundNumber: roundNUMBER) {
                    packsOfRound = GF.passLeft(gamepacks: packsOfRound)
                }
                    
                else {
                    packsOfRound = GF.passRight(gamepacks: packsOfRound)
                }
                
            }
            
            
        }
        else {
            endDraft()
        }
        
        
        
        carousel.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //type of carousel
        carousel.type = .cylinder
        
    }
    
    func loadImage(itemview: UIImageView, urlString: String) {
        let imageURL = URL(string: urlString)
        itemview.sd_setShowActivityIndicatorView(true)
        itemview.sd_setIndicatorStyle(.gray)
        itemview.sd_setImage(with: imageURL)
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func endDraft() {
        //packsOfRound = [[CARDS]]()
        let alert = UIAlertController(title: "Round 3 Complete", message: "Finish building your deck!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func isEndOfDraft() -> Bool {
        if draftCardPicks.totalDraftedCards() == 45 {return true}
        
        return false
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
