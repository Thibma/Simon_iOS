//
//  EndGameViewController.swift
//  Simon_iOS
//
//  Created by Thibault BALSAMO on 09/02/2022.
//

import UIKit
import HomeKit

class EndGameViewController: UIViewController {
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var labelGame: UILabel!
    
    var isWin: Bool!
    var homeManager: HMHomeManager! = HMHomeManager()
    var home: HMHome!
    
    class func newInstance(isWin: Bool) -> EndGameViewController {
        let viewController = EndGameViewController()
        viewController.isWin = isWin
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeManager.delegate = self
        self.buttonBack.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
        
        if self.isWin == true {
            let characteristic = self.getPowerStateCharacteristic()
            characteristic?.writeValue(true, completionHandler: { err in
                print("open")
            })
            
        } else {
            self.labelGame.text = "Echec, vous êtes coincés\ndans la pièce."
        }
    }
    
    @IBAction func pushButtonBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func getPowerStateCharacteristic() -> HMCharacteristic? {
        var accessory: HMAccessory! = nil
        for access in self.home.accessories {
            if access.model!.contains("Eve Energy") {
                accessory = access
            }
        }
        
        guard (accessory != nil) else {
            return nil
        }
        
        for service in accessory.services {
            for characteristic in service.characteristics {
                if characteristic.characteristicType == HMCharacteristicTypePowerState {
                    return characteristic
                }
            }
        }
        return nil
    }
    
}

extension EndGameViewController: HMHomeManagerDelegate {
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        for home in self.homeManager.homes {
            if home.name == "EscapeGame" {
                self.home = home
                break
            }
        }
        
        let characteristic = self.getPowerStateCharacteristic()
        let isWritable = characteristic?.properties.firstIndex(where: { props in
            return props == HMCharacteristicPropertyWritable
        }) ?? -1
    }
    
}
