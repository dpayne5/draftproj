//
//  DraftPicksViewController.swift
//  draftproj
//
//  Created by Dusty Payne on 4/4/19.
//  Copyright © 2019 Dusty Payne. All rights reserved.
//

import UIKit
import SwipeCellKit
import MTGSDKSwift
import ObjectiveC

//extension to add background colors, will use an extra function or maybe a dictionary to track the color patterns I want for specific colors
private var AssociatedObejctHandle: UInt8 = 0


extension Card {
    
    var open: Bool {
        get {
            return objc_getAssociatedObject(self,  &AssociatedObejctHandle) as? Bool ?? false
            
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObejctHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            
        }
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
    }
}




class DraftPicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let MF = manaFONT()
    
    
    
    //struct to hold cellData for exapansion on choose
    
    
    @IBOutlet weak var mainBoardTableView: UITableView!
    @IBOutlet weak var sideBoardTableView: UITableView!
    
    
    //Visual SETUP
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if the table is
        if tableView.tag == 0 {
            
            if !draftCardPicks.mainboardPicks.isEmpty{
                //return phArray.count
                return draftCardPicks.mainboardPicks.count
            }

        }
        
        else if tableView.tag == 1 {
            if !draftCardPicks.sideboardPicks.isEmpty {
                return draftCardPicks.sideboardPicks.count
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //this is editing the height of the row??
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == 0 {
            
            if draftCardPicks.mainboardPicks[indexPath.row].open! { //perfect! can edit the rest later
                return 175.0
            }
            else {return 42.0}
        }
        
        else if tableView.tag == 1 {
            
            if draftCardPicks.sideboardPicks[indexPath.row].open! {
                return 175.0
            }
            else {return 42.0}
            
        }
        return 42.0
    }
 
    @IBOutlet weak var mbHeaderLabel: UILabel!
    
    
    //this function is where the actual cell information is added
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MB") as? MainBoardTableViewCell {
            
            if !draftCardPicks.mainboardPicks.isEmpty {
                
                mbHeaderLabel.text = "Mainboard: \(draftCardPicks.totalMainDeck())/40"
                
                cell.cardNameLabel.text = draftCardPicks.displayVAL(info: draftCardPicks.mainboardPicks[indexPath.row].name)
                
                cell.cardCountLabel.text = String( (draftCardPicks.mainboardPicks[indexPath.row].count)!)
                
                
                
                cell.cardTypeLabel.text = draftCardPicks.displayVAL(info: draftCardPicks.mainboardPicks[indexPath.row].types![0])
                    
                
                
                if draftCardPicks.displayVAL(info: draftCardPicks.mainboardPicks[indexPath.row].power!) == "" {
                    cell.cardPTvalLabel.text = ""
                } else {
                    cell.cardPTvalLabel.text = draftCardPicks.mainboardPicks[indexPath.row].power! + "/" + draftCardPicks.mainboardPicks[indexPath.row].toughness!
                }
                
                
                cell.cardCostLabel.text = MF.STS(s: draftCardPicks.mainboardPicks[indexPath.row].manaCost!)
                    
                    
                    
                    //draftCardPicks.displayVAL(info: draftCardPicks.mainboardPicks[indexPath.row].manaCost)
                    
                    
                
                cell.cardOracleText.text = MF.STS(s: draftCardPicks.mainboardPicks[indexPath.row].originalText!)
                    
                    
                    //draftCardPicks.displayVAL(info: draftCardPicks.mainboardPicks[indexPath.row].originalText)
                    
                
                return cell
                
            }
        }
            
        else if let cell = tableView.dequeueReusableCell(withIdentifier: "SB") as? SideBoardTableViewCell {
            
            if !draftCardPicks.sideboardPicks.isEmpty {
                mbHeaderLabel.text = "Mainboard: \(draftCardPicks.totalMainDeck())/40"
                
                cell.cardNameLabel.text = draftCardPicks.displayVAL(info: draftCardPicks.sideboardPicks[indexPath.row].name)
                
                cell.cardCountLabel.text = String( (draftCardPicks.sideboardPicks[indexPath.row].count)!)
                
                
                
                cell.cardTypeLabel.text = draftCardPicks.displayVAL(info: draftCardPicks.sideboardPicks[indexPath.row].types![0])
                
                
                
                if draftCardPicks.displayVAL(info: draftCardPicks.sideboardPicks[indexPath.row].power!) == "" {
                    cell.cardPTvalLabel.text = ""
                } else {
                    cell.cardPTvalLabel.text = draftCardPicks.sideboardPicks[indexPath.row].power! + "/" + draftCardPicks.sideboardPicks[indexPath.row].toughness!
                }
                
                
                cell.cardCostLabel.text = MF.STS(s: draftCardPicks.sideboardPicks[indexPath.row].manaCost!)
                    
                    
                    //draftCardPicks.displayVAL(info: draftCardPicks.sideboardPicks[indexPath.row].manaCost)
                
                
                
                cell.cardOracleText.text = MF.STS(s: draftCardPicks.sideboardPicks[indexPath.row].originalText!)
                    
                    
                    //draftCardPicks.displayVAL(info: draftCardPicks.sideboardPicks[indexPath.row].originalText)
                
                
                return cell
                
                
                
            }
            
        }
        return UITableViewCell()
    }
    
    //this will be for making the cell expand
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            
            
            draftCardPicks.mainboardPicks[indexPath.row].open = !draftCardPicks.mainboardPicks[indexPath.row].open!
            
            self.mainBoardTableView.beginUpdates()
            self.mainBoardTableView.endUpdates()
            
        }
        
        else if tableView.tag == 1 {
            draftCardPicks.sideboardPicks[indexPath.row].open = !draftCardPicks.sideboardPicks[indexPath.row].open!
            self.sideBoardTableView.beginUpdates()
            self.sideBoardTableView.endUpdates()
            //self.sideBoardTableView.reloadData()
            
        }
        
        
    }
 
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if tableView.tag == 1 {
            let toMB = UIContextualAction(style: .normal, title: "toMB") { (action, view, nil) in
                

                draftCardPicks.moveToMB(SBindex: indexPath.row)
                //draftCardPicks.mainboardPicks.append(draftCardPicks.sideboardPicks.remove(at: indexPath.row))
                self.mbHeaderLabel.text = "Mainboard: \(draftCardPicks.totalMainDeck())/40"
                self.mainBoardTableView.reloadData()
                self.sideBoardTableView.reloadData()

            }
            return UISwipeActionsConfiguration(actions: [toMB])
            
        }
        return UISwipeActionsConfiguration()
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if tableView.tag == 0 {
            
            let delete = UIContextualAction(style: .normal, title: "toSB") { (action, view, nil) in
                
                draftCardPicks.moveToSB(MBindex: indexPath.row)
                
                
                //self.phSideArray.append(self.phArray[indexPath.section])
                //self.phArray.remove(at: indexPath.section)
                self.mbHeaderLabel.text = "Mainboard: \(draftCardPicks.totalMainDeck())/40"
                self.mainBoardTableView.reloadData()
                self.sideBoardTableView.reloadData()
            }
            
            
            return UISwipeActionsConfiguration(actions: [delete])

        }
        
        return UISwipeActionsConfiguration()
  
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //phArray = [phCardC, phCardD, phCardE, phCardF]
        
        mainBoardTableView.dataSource = self
        mainBoardTableView.delegate = self
        sideBoardTableView.dataSource = self
        sideBoardTableView.delegate = self
        
        //didfetchData(url: "https://api.scryfall.com/cards/named?fuzzy=sauroform+hybrid")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        draftCardPicks.sortbyCost()
        //updateObjArr()
        mainBoardTableView.reloadData()
        sideBoardTableView.reloadData()
        
    }
    
    
    
    @IBAction func addLandButton(_ sender: UIButton) {
        
        if draftCardPicks.totalDraftedCards() <= 44 {
            let alert = UIAlertController(title: "You can't do that yet!", message: "Add lands after you've finished all 3 rounds of the draft", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        switch sender.tag {
            
        case 0:
            draftCardPicks.addToMB(pickedCard: draftCardPicks.basicLANDS[0])
            
        case 1:
            draftCardPicks.addToMB(pickedCard: draftCardPicks.basicLANDS[1])
            
        case 2:
            draftCardPicks.addToMB(pickedCard: draftCardPicks.basicLANDS[2])
            
        case 3:
            draftCardPicks.addToMB(pickedCard: draftCardPicks.basicLANDS[3])
            
        case 4:
            draftCardPicks.addToMB(pickedCard: draftCardPicks.basicLANDS[4])
            
        default:
            _ = 1
        }
        
        mainBoardTableView.reloadData()
        sideBoardTableView.reloadData()
        
        
    }
    
    
    @IBAction func toEndButton(_ sender: Any) {
        
        if draftCardPicks.totalMainDeck() < 40 { // needs to be replaced by the actual function
            
            let alert = UIAlertController(title: "Unable to submit", message: "Your deck must be at least 40 cards", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
            performSegue(withIdentifier: "toEnd", sender: self)
            
        }
        else {
            performSegue(withIdentifier: "toEnd", sender: self)
            
        }
        
        //performSegue(withIdentifier: "toEnd", sender: self)
        
        
        
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var totalPicks = [[CARDS]]()
        
        totalPicks.append(draftCardPicks.mainboardPicks)
        for pack in draftCardPicks.botPICKS {
            totalPicks.append(pack)
        }
        
        
        let dest = segue.destination as? FinalSubmitViewController
        
        
        dest?.finalPicks = totalPicks
        
        
        
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 
    
    
    
    
    
    //this is placeholder location for The scryfall card objects, I'll have to move this elsewhere in the code eventually. These are in the scryData file
    
    struct SData: Decodable {
        let obj : String?
        let name: String?
        let uri : String?
        let scryfall_uri : String?
        let image_uris: ImageURIS
        
        let mana_cost : String?
        let cmc : Double?
        let type_line : String?
        
        let oracle_text : String?
        //let colors: String? need to figure out what these are....
        //let color_identity: String? need to figure out what these are.....
        
        let set : String?
        let set_name: String?
    }
    
    struct ImageURIS : Decodable {
        let small : String?
        let normal : String?
        let large : String?
        let png : String?
        let art_crop : String?
        let border_crop : String?
        
    }
    

    

}
