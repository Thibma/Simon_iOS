//
//  EndGameViewController.swift
//  Simon_iOS
//
//  Created by Thibault BALSAMO on 09/02/2022.
//

import UIKit
import HomeKit
import AVFoundation

class EndGameViewController: UIViewController {
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var labelGame: UILabel!
    
    var isWin: Bool!
    var homeManager: HMHomeManager! = HMHomeManager()
    var home: HMHome!
    
    var player: AVAudioPlayer!
    
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
        
        if self.home == nil {
            print("home non trouvée")
        }
        
        
        if self.isWin == true {
            let characteristic = self.getPowerStateCharacteristic()
            guard let sound = Bundle.main.url(forResource: "Victory", withExtension: "mp3") else {
                return
            }
            
            guard let player = try? AVAudioPlayer(contentsOf: sound) else {
                return
            }
            
            player.volume = 1
            player.play()
            self.player = player
            characteristic?.writeValue(true, completionHandler: { err in
                print("open")
            })
            
        } else {
            guard let sound = Bundle.main.url(forResource: "GameOver", withExtension: "mp3") else {
                return
            }
            
            guard let player = try? AVAudioPlayer(contentsOf: sound) else {
                return
            }
            
            player.volume = 1
            player.play()
            self.player = player
            self.labelGame.text = "Echec, vous êtes coincés\ndans la pièce."
        }
    }
    
}
