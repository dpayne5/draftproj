//
//  ShowBotDeckViewController.swift
//  draftproj
//
//  Created by Dusty Payne on 5/4/19.
//  Copyright © 2019 Dusty Payne. All rights reserved.
//

import UIKit

class ShowBotDeckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let MF = manaFONT()
    
    var thisBotsPicks = [CARDS]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return thisBotsPicks.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BOTCARD") as? ShowBotDeckTableViewCell {
            
            cell.cardQty.text = String((thisBotsPicks[indexPath.row].count)!)
            cell.cardName.text = thisBotsPicks[indexPath.row].name
            cell.cardCost.text =  MF.STS(s: thisBotsPicks[indexPath.row].manaCost!)
            
            
            
            if draftCardPicks.displayVAL(info: thisBotsPicks[indexPath.row].power!) == "" {
                cell.cardPT.text = ""
            } else {
                cell.cardPT.text = thisBotsPicks[indexPath.row].power! + "/" + thisBotsPicks[indexPath.row].toughness!
            }
                        
            cell.cardType.text = thisBotsPicks[indexPath.row].types![0]
            
            cell.cardOracle.text = MF.STS(s: thisBotsPicks[indexPath.row].originalText!)
            
            
            //assign everything here
            return cell
            
            
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        thisBotsPicks[indexPath.row].open! = !(thisBotsPicks[indexPath.row].open!)
        
        ShowDeckTableView.beginUpdates()
        ShowDeckTableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  thisBotsPicks[indexPath.row].open! {
            //draftCardPicks.mainboardPicks[indexPath.row].open! { //perfect! can edit the rest later
            return 175.0
        }
        else {return 42.0}
    
    }
    
    
    @IBAction func toPrevButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var ShowDeckTableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ShowDeckTableView.dataSource = self
        ShowDeckTableView.delegate = self
        
        

        // Do any additional setup after loading the view.
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
