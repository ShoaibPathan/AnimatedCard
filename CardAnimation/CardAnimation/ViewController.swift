//
//  ViewController.swift
//  CardAnimation
//
//  Created by Jordan Christensen on 9/21/20.
//

import UIKit

class ViewController: UIViewController {
    var cardView: CardView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        cardView = CardView(origin: CGPoint(x: 16, y: 16), width: view.bounds.width - 32)
        
        view.addSubview(cardView)
    }
    
    @IBAction func flip(_ sender: Any) {
        cardView.flipCard()
    }
}

