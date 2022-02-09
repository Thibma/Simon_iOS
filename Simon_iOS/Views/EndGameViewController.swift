//
//  EndGameViewController.swift
//  Simon_iOS
//
//  Created by Thibault BALSAMO on 09/02/2022.
//

import UIKit

class EndGameViewController: UIViewController {
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var labelGame: UILabel!
    
    var isWin: Bool!
    
    class func newInstance(isWin: Bool) -> EndGameViewController {
        let viewController = EndGameViewController()
        viewController.isWin = isWin
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonBack.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
        
        if self.isWin == true {
            // Ouverture de la prise
        } else {
            self.labelGame.text = "Echec, vous êtes coincés\ndans la pièce."
        }
    }
    
    @IBAction func pushButtonBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
