//
//  GameViewController.swift
//  Simon_iOS
//
//  Created by Thibault BALSAMO on 08/02/2022.
//

import UIKit
import HomeKit
import AVFoundation

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
    
    var led: HMAccessory!
    
    var arrayHomeBridge: String = ""
    
    var playerSound: AVAudioPlayer!
    var playerMusicPreparation: AVAudioPlayer!
    var playerMusicGame: AVAudioPlayer!
    
    class func newInstance(led: HMAccessory) -> GameViewController {
        let viewController = GameViewController()
        viewController.led = led
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.redButton.layer.cornerRadius = 8
        self.greenButton.layer.cornerRadius = 8
        self.blueButton.layer.cornerRadius = 8
        self.clearButton.layer.cornerRadius = 8
        
        guard let sound = Bundle.main.url(forResource: "Preparation", withExtension: "mp3") else {
            return
        }
        
        guard let player = try? AVAudioPlayer(contentsOf: sound) else {
            return
        }
        
        player.volume = 1
        self.playerMusicPreparation = player

        
        guard let sound2 = Bundle.main.url(forResource: "Game", withExtension: "mp3") else {
            return
        }
        
        guard let player2 = try? AVAudioPlayer(contentsOf: sound2) else {
            return
        }
        
        player2.volume = 1
        player2.numberOfLoops = .max
        self.playerMusicGame = player2
        
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
                    guard let sound = Bundle.main.url(forResource: "Wrong", withExtension: "mp3") else {
                        return
                    }
                    
                    guard let player = try? AVAudioPlayer(contentsOf: sound) else {
                        return
                    }
                    
                    player.volume = 1
                    player.play()
                    self.playerSound = player
                    return
                }
            }
            print("GOOD INPUT")
            self.advancement += 1
            self.selectCombinaison()
            guard let sound = Bundle.main.url(forResource: "Correct", withExtension: "mp3") else {
                return
            }
            
            guard let player = try? AVAudioPlayer(contentsOf: sound) else {
                return
            }
            
            player.volume = 1
            player.play()
            self.playerSound = player
        }
        
    }
    
    func addLabel(string: String, color: UIColor, emplacement: Int) {
        let label = self.labelsSelection[emplacement]
        label.font = .init(name: "Upheaval TT -BRK-", size: 20)
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
            self.playerMusicGame.stop()
            self.playerMusicPreparation.stop()
            let viewController = EndGameViewController.newInstance(isWin: false)
            self.navigationController?.pushViewController(viewController, animated: true)
            return
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
            colorNumber = 2
            break
        case 2:
            colorNumber = 3
            break
        case 3:
            colorNumber = 4
            break
        case 4:
            colorNumber = 5
            break
        case 5:
            colorNumber = 6
            break
        case 6:
            // End of game
            self.playerMusicGame.stop()
            self.playerMusicPreparation.stop()
            let viewController = EndGameViewController.newInstance(isWin: true)
            self.navigationController?.pushViewController(viewController, animated: true)
            return
        default:
            print("error color number")
            break
        }
        
        var array: [String] = []
        for _ in 0..<colorNumber {
            let randomColor = Int.random(in: 0...2)
            switch randomColor {
            case 0:
                self.model.append(.red)
                array.append("RED")
                break
            case 1:
                self.model.append(.blue)
                array.append("BLUE")
                break
            case 2:
                self.model.append(.green)
                array.append("GREEN")
                break
            default:
                print("error select random color")
                break
            }
            self.arrayHomeBridge = array.joined(separator: ",")
            self.clearViewSelection()
        }
        print(self.model)
        for service in self.led.services {
            for charac in service.characteristics {
                if charac.characteristicType == "000000CE-0000-1000-8000-0026ABCDEF03" {
                    charac.writeValue(self.arrayHomeBridge) { err in
                        print(err)
                    }
                    self.playerMusicPreparation.play()
                    self.playerMusicGame.pause()
                    PauseViewController.showPause(parentVC: self, timer: self.model.count)
                    
                }
            }
        }
    }
    
    func clearViewSelection() {
        let label = UILabel()
        label.text = "???"
        label.textColor = .black
        label.font = .init(name: "Upheaval TT -BRK-", size: 30)
        self.stateStackView.addArrangedSubview(label)
        self.labelsSelection.append(label)
    }
}


extension GameViewController: PauseViewControllerDelegate {
    
    
    func dismissScreen() {
        self.playerMusicPreparation.pause()
        self.playerMusicGame.play()
    }
    
    
}
