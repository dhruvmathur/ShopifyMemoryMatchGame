//
//  CompleteWinViewController.swift
//  Shopify
//
//  Created by Dhruv Mathur on 2019-09-16.
//  Copyright © 2019 Dhruv Mathur. All rights reserved.
//

import Foundation
import UIKit

class CompleteWinViewController: UIViewController {
    
    var score: Int = 0
    var flips: Int = 0
    
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var flipLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func newGameTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: .newGameNotif, object: nil)
    }
    
    override func viewDidLoad() {
        parentView.layer.cornerRadius = 8
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        
        scoreLabel.text = "Your score is \(score)"
        flipLabel.text = "You flipped \(flips) times"
        
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    func updateScores() {
        scoreLabel.text = "Your score is \(score)"
        flipLabel.text = "You flipped \(flips) times"

    }
}
