//
//  ViewController.swift
//  draftproj
//
//  Created by Dusty Payne on 4/4/19.
//  Copyright © 2019 Dusty Payne. All rights reserved.
//

import UIKit



import MTGSDKSwift

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let magic = Magic()
    
    var sendURL  = "https://mtgjson.com/json/WAR.json"
    
    
    let MF = manaFONT()
    
    let testData = ["WAR", "RNA", "GRN"]
    let testDataJSONS = ["https://mtgjson.com/json/WAR.json","https://mtgjson.com/json/RNA.json","https://mtgjson.com/json/GRN.json"]
    
    @IBOutlet weak var AppTitleLabel: UILabel!
    
    let testJSONgrab = mtgJSONDATA()
    
    var wantedCARDSET = [CARDS]()
    
    var cardforTest = Card()
    var packforTest = [Card]()
    var cardSetToPass = [Card]()
    
    let gf = GameFunctions()
    
    //setup for the pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return testData.count
    }
    
    //assigns titles to the pickerview
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return testData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sendURL = testDataJSONS[row]
    }
    
    //placeholder data object
    //pickerview variable
    @IBOutlet weak var setPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPickerView.dataSource = self
        setPickerView.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    /* Once generateSet works, this will call generateSet with the pickerView label string, and move to
       the pickingWheel VC. Right now it's just a one off with sauroform hybrid*/
    @IBAction func startGameButton(_ sender: Any) {
        
        
        testJSONgrab.getCards(url: sendURL) {json, error in
            
            DispatchQueue.main.async {
                self.wantedCARDSET = json
                self.performSegue(withIdentifier: "toGame", sender: self)
            }
        }
        
            }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let barVC = segue.destination as? UITabBarController {
            barVC.viewControllers?.forEach{
                if let vc = $0 as? PickingWheelViewController {
                    vc.cardRecieved = cardforTest
                    vc.packRecieved = packforTest
                    
                    vc.jsonSetRecieved = self.wantedCARDSET
                    draftCardPicks.basicLANDS = draftCardPicks.setBasicLands(commonset: self.wantedCARDSET)
                    
                    vc.packsOfRound = gf.generateJSONboosters(setRecieved: self.wantedCARDSET)
                    
                    
            }
        }
        
        
        
    }
 
}
    
    
    
    
    
    
    
    
    
    
}

