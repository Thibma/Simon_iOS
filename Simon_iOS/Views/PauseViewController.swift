//
//  PauseViewController.swift
//  Simon_iOS
//
//  Created by Thibault BALSAMO on 14/02/2022.
//

import UIKit

class PauseViewController: UIViewController {
    @IBOutlet var viewPopup: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.80)
        //viewPopup.backgroundColor = UIColor.black.withAlphaComponent(0)
    }

    static func showPause(parentVC: UIViewController, timer: Int) {
        let viewController = PauseViewController()
        viewController.modalPresentationStyle = .custom
        viewController.modalTransitionStyle = .crossDissolve
        
        parentVC.present(viewController, animated: false, completion: nil)
        
        Timer.scheduledTimer(timeInterval: Double(timer), target: viewController, selector: #selector(dismissScreen), userInfo: nil, repeats: false)
        
    }
    
    @objc func dismissScreen() {
        self.dismiss(animated: false, completion: nil)
    }

}
