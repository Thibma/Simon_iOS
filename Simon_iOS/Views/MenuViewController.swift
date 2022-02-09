//
//  MenuViewController.swift
//  Simon_iOS
//
//  Created by Thibault BALSAMO on 07/02/2022.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.playButton.layer.cornerRadius = 8
        

    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        self.navigationController?.pushViewController(GameViewController(), animated: true)
    }
    
}
