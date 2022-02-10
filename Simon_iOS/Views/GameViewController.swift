//
//  GameViewController.swift
//  Simon_iOS
//
//  Created by Thibault BALSAMO on 08/02/2022.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var gameNumber: UILabel!
    
    @IBOutlet weak var stateStackView: UIStackView!
    
    var labelsSelection: [UILabel] = []
    
    var life: Int = 3
    var advancement: Int = 1
    
    var model: [Color] = []
    var userInput: [Color] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.redButton.layer.cornerRadius = 8
        self.greenButton.layer.cornerRadius = 8
        self.blueButton.layer.cornerRadius = 8
        self.clearButton.layer.cornerRadius = 8

        self.selectCombinaison()
    }

    @IBAction func pushRedButton(_ sender: Any) {
        self.userInput.append(.red)
        self.selectedColor(color: Color.red)
        
    }
    
    @IBAction func pushGreenButton(_ sender: Any) {
        self.userInput.append(.green)
        self.selectedColor(color: Color.green)
        
    }
    
    @IBAction func pushBlueButton(_ sender: Any) {
        self.userInput.append(.blue)
        self.selectedColor(color: Color.blue)
    }
    
    @IBAction func pushClearButton(_ sender: Any) {
        self.userInput.removeAll()
        for label in self.labelsSelection {
            self.stateStackView.removeArrangedSubview(label)
            label.removeFromSuperview()
           
        }
        self.labelsSelection.removeAll()
        for _ in 0..<self.model.count {
            self.clearViewSelection()
        }
    }
    
    func selectedColor(color: Color) {
        switch color {
            case .red:
            self.addLabel(string: "R", color: .init(named: "RedGame")!, emplacement: self.userInput.count - 1)
                break
            case .blue:
                self.addLabel(string: "B", color: .init(named: "Persian Blue")!, emplacement: self.userInput.count - 1)
                break
            case .green:
                self.addLabel(string: "V", color: .init(named: "GreenGame")!, emplacement: self.userInput.count - 1)
                break
        }
        
        if self.model.count == self.userInput.count {
            for i in 0..<self.userInput.count {
                if self.userInput[i] != self.model[i] {
                    print("BAD INPUT")
                    self.looseLife()
                    return
                }
            }
            print("GOOD INPUT")
            self.advancement += 1
            self.selectCombinaison()
        }
        
    }
    
    func addLabel(string: String, color: UIColor, emplacement: Int) {
        let label = self.labelsSelection[emplacement]
        label.text = string
        label.textColor = color
    }
    
    func looseLife() {
        self.life -= 1
        switch self.life {
        case 2:
            self.heart3.image = UIImage.init(named: "deadHeart")
            break
        case 1:
            self.heart2.image = UIImage.init(named: "deadHeart")
            break
        case 0:
            self.heart1.image = UIImage.init(named: "deadHeart")
            let viewController = EndGameViewController.newInstance(isWin: false)
            self.navigationController?.pushViewController(viewController, animated: true)
            break
        default:
            print("error life")
            break
        }
        self.selectCombinaison()
    }
    
    func selectCombinaison() {
        self.gameNumber.text = "\(self.advancement)/5"
        var colorNumber = 0
        self.model.removeAll()
        self.userInput.removeAll()
        for label in self.labelsSelection {
            self.stateStackView.removeArrangedSubview(label)
            label.removeFromSuperview()
        }
        self.labelsSelection.removeAll()
        switch self.advancement {
        case 1:
            colorNumber = 5
            let viewController = EndGameViewController.newInstance(isWin: false)
            self.navigationController?.pushViewController(viewController, animated: true)
            break
        case 2:
            colorNumber = 6
            break
        case 3:
            colorNumber = 7
            break
        case 4:
            colorNumber = 8
            break
        case 5:
            colorNumber = 10
            break
        case 6:
            // End of game
            let viewController = EndGameViewController.newInstance(isWin: true)
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            print("error color number")
            break
        }
        
        for _ in 0..<colorNumber {
            let randomColor = Int.random(in: 0...2)
            switch randomColor {
            case 0:
                self.model.append(.red)
                break
            case 1:
                self.model.append(.blue)
                break
            case 2:
                self.model.append(.green)
                break
            default:
                print("error select random color")
                break
            }
            self.clearViewSelection()
            print(self.model.last)
        }
    }
    
    func clearViewSelection() {
        let label = UILabel()
        label.text = "•"
        label.textColor = .black
        label.font = .init(name: "Upheaval TT -BRK-", size: 30)
        self.stateStackView.addArrangedSubview(label)
        self.labelsSelection.append(label)
    }
}
