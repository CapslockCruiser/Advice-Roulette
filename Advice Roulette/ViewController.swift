//
//  ViewController.swift
//  Advice Roulette
//
//  Created by William Choi on 12/18/19.
//  Copyright © 2019 William Choi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var currentAdvice: AdviceStruct? {
        didSet {
            DispatchQueue.main.async {
                // Do UI updates here
                self.adviceLabel.text = self.currentAdvice?.content
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if (currentAdvice == nil) {
            // TODO: Take care of scenario where current advice has not yet loaded
            let alertController = UIAlertController(title: "Loading", message: "We're still loading an advice!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Okay", style: .default, handler: {action in
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
    }
    
    
    @IBAction func viewSavedButton(_ sender: Any) {
        
        let savedAdivecVC = SavedAdviceViewController()
//        savedAdivecVC.modalPresentationStyle = .fullScreen
        present(savedAdivecVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var adviceLabel: UILabel!
    
    @IBAction func getNewButtonPressed(_ sender: Any) {
        getNewAdvice()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        navigationController?.setNavigationBarHidden(true, animated: false)
        adviceLabel.numberOfLines = 0
        
        getNewAdvice()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adviceLabel.numberOfLines = 0
    }

    private func getNewAdvice() {
        let success: (AdviceStruct) -> () = { (currentAdvice) in
                    DispatchQueue.main.async {
                        // Do UI updates here
        //                self.adviceLabel.text = currentAdvice.content
                        self.currentAdvice = currentAdvice
                    }
                }
        AdviceManager.shared.getRandom(success: success)
    }
}

