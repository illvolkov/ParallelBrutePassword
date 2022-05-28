//
//  ViewController.swift
//  ParallelBrutePassword
//
//  Created by Ilya Volkov on 27.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var hackMeImage: UIImageView!
    @IBOutlet weak var viewColorButton: UIButton!
    @IBOutlet weak var crackedPassLabel: UILabel!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var generatePassButton: UIButton!
    @IBOutlet weak var crackStopButton: UIButton!
    @IBOutlet weak var possiblePassLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    //MARK: - Properties
    
    private var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
                generatePassButton.tintColor = .black
                crackStopButton.tintColor = .black
                changeViewsColor(to: .white)
            } else {
                self.view.backgroundColor = .white
                generatePassButton.tintColor = .white
                crackStopButton.tintColor = .white
                changeViewsColor(to: .black)
            }
        }
    }
    
    private var isCrackButton: Bool = true {
        didSet {
            if isCrackButton {
                crackStopButton.setTitle("Crack", for: .normal)
            } else {
                crackStopButton.setTitle("Stop", for: .normal)
            }
        }
    }
    
    private let passwordGuessing = PasswordGuessing()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        passwordGuessing.bruteForce(passwordToUnlock: "1!gr")
        
    }
    
    //MARK: - Settings
    
    private func setupView() {
        setCornerRadiusForView(10)
        passField.isSecureTextEntry = true
    }
    
    //MARK: - Actions
    
    @IBAction func changeViewColor(_ sender: Any) {
        isBlack.toggle()
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        passField.resignFirstResponder()
    }
    @IBAction func changeCrackStopButtonState(_ sender: Any) {
        isCrackButton.toggle()
    }
    
    
    //MARK: - Functions
    private func changeViewsColor(to color: UIColor) {
        viewColorButton.tintColor = color
        possiblePassLabel.textColor = color
        crackedPassLabel.textColor = color
        generatePassButton.backgroundColor = color
        crackStopButton.backgroundColor = color
        doneButton.tintColor = color
    }
    
    private func setCornerRadiusForView( _ corner: CGFloat) {
        hackMeImage.layer.cornerRadius = corner * 5
        hackMeImage.layer.masksToBounds = true
        
        generatePassButton.layer.cornerRadius = corner
        generatePassButton.layer.masksToBounds = true
        
        crackStopButton.layer.cornerRadius = corner
        crackStopButton.layer.masksToBounds = true
    }
}
