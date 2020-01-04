//
//  SavedAdvicesViewController.swift
//  Advice Roulette
//
//  Created by William Choi on 1/3/20.
//  Copyright © 2020 William Choi. All rights reserved.
//

import UIKit

final class SavedAdviceViewController: UIViewController {
    
    // MARK: UI elements
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitViewController), for: .touchDown)
        return button
    }()
    
    lazy private var advicesTableView: UITableView = {
        let uiTV = UITableView()
        uiTV.translatesAutoresizingMaskIntoConstraints = false
        uiTV.delegate = self
        return uiTV
    }()
    
    // MARK: Private properties
    private var savedAdvices: [AdviceStruct] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addUIElements()
        savedAdvices = AdviceManager.shared.loadAllSaved()
    }
    
    @objc private func exitViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    private func addUIElements() {
        addExitButton()
        addSavedAdviceTabelView()
    }
    
    private func addExitButton() {
        view.addSubview(exitButton)
        exitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        exitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    private func addSavedAdviceTabelView() {
        view.addSubview(advicesTableView)
        NSLayoutConstraint.activate([
        NSLayoutConstraint.init(item: advicesTableView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
            advicesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            advicesTableView.bottomAnchor.constraint(equalTo: exitButton.topAnchor, constant: 8)
        ])
    }
}

extension SavedAdviceViewController: UITableViewDelegate {
    
}
