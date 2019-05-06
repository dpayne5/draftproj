//
//  FinalSubmitViewController.swift
//  draftproj
//
//  Created by Dusty Payne on 4/30/19.
//  Copyright © 2019 Dusty Payne. All rights reserved.
//

import UIKit
import MTGSDKSwift


class FinalSubmitViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var indexPassed : Int?
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FinalSubmitCell", for: indexPath) as? FinalSubmitCollectionViewCell {
            //here the cell tag comes through
            cell.finalSubCell.backgroundColor = deckImageColor(cardPicks: finalPicks[indexPath.row])
            cell.finalSubCellLabel.text = players[indexPath.row]
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        self.indexPassed = indexPath.row
        
        if self.indexPassed! >= 1 {
            self.indexPassed = self.indexPassed! + 1
        }
        
        
        
        performSegue(withIdentifier: "showList", sender: self)
        
        
    }
    
    
    @IBAction func unwindButton(_ sender: Any) {
        
        //self.performSegue(withIdentifier: "unwindToStart", sender: self)
        
        draftCardPicks.clearDecks()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

    }
    
    
    /* final picks of all the packs */
    var finalPicks = [[CARDS]]()
    
    /* Player titles for the colletion view*/
    let players = ["Player","Bot1","Bot2","Bot3","Bot4","Bot5","Bot6","Bot7"]
    
    /* Pick array to pass, for clarity*/
    var picksToPass = [CARDS]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        finalSubmitCollectionView.delegate = self
        finalSubmitCollectionView.dataSource = self
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var finalSubmitCollectionView: UICollectionView!
    
    /* restart the draft using the same set*/

    
    
    
    
    /* this is a function to the the background color of the deck based on the cards inside */
    func deckImageColor(cardPicks: [CARDS]) -> UIColor{
        
        
        
        
        return .clear
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dest = segue.destination as? ShowBotDeckViewController
        
        dest?.thisBotsPicks = finalPicks[indexPassed!]
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
