//
//  ViewController.swift
//  ParallelBrutePassword
//
//  Created by Ilya Volkov on 27.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var button: UIButton!
    
    //MARK: - Properties
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    let passwordGuessing = PasswordGuessing()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordGuessing.bruteForce(passwordToUnlock: "1!gr")
        
    }
    
    //MARK: - Actions
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
}
