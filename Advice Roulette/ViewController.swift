//
//  ViewController.swift
//  Advice Roulette
//
//  Created by William Choi on 12/18/19.
//  Copyright © 2019 William Choi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var currentAdvice: AdviceStruct? = nil
    
    @IBOutlet weak var adviceLabel: UILabel!
    
    @IBAction func getNewButtonPressed(_ sender: Any) {
        let success: (AdviceStruct) -> () = { (currentAdvice) in
            DispatchQueue.main.async {
                // Do UI updates here
                self.adviceLabel.text = currentAdvice.content
            }
        }
        AdviceManager.shared.getRandom(success: success)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        navigationController?.setNavigationBarHidden(true, animated: false)
        adviceLabel.numberOfLines = 0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adviceLabel.numberOfLines = 0
    }

    
}

