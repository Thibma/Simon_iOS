//
//  MenuViewController.swift
//  Simon_iOS
//
//  Created by Thibault BALSAMO on 07/02/2022.
//

import UIKit
import HomeKit

class MenuViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addAccessoriesButton: UIButton!
    @IBOutlet weak var labelAccessories: UILabel!
    
    var homeManager: HMHomeManager = HMHomeManager()
    var home: HMHome!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeManager.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.playButton.layer.cornerRadius = 8
        self.addAccessoriesButton.layer.cornerRadius = 8
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        var led: HMAccessory! = nil
        for accessory in self.home.accessories {
            print(accessory.model)
            if (accessory.model == "Raspberry-LED") {
                led = accessory
            }
        }
        
        if led == nil {
            let alert = UIAlertController.init(title: "LEDs non trouvées", message: "Merci d'ajouter des LEDS pour participer au jeu", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else {
            let vc = GameViewController.newInstance(led: led!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func addAccessories(_ sender: Any) {
        self.home.addAndSetupAccessories { err in
            if err == nil {
                self.labelAccessories.text = "\(((self.home?.rooms.first?.accessories.count)! + 1) ) accessoires connectés"
            }
            else {
                print("not good")
            }
        }
    }
    
}

extension MenuViewController: HMHomeManagerDelegate {

    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        for home in self.homeManager.homes {
            if home.name == "EscapeGame" {
                self.home = home
                break
            }
        }
        if self.home == nil {
            self.homeManager.addHome(withName: "EscapeGame") { home, err in
                self.home = home
                home?.addRoom(withName: "DarkRoom", completionHandler: { _, _ in
                    
                })
            }
        }
        
        self.labelAccessories.text = "\(home?.rooms.first?.accessories.count ?? 0) accessoires connectés"
    }
    
}
