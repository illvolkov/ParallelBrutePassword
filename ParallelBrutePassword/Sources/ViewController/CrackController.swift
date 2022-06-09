//
//  ViewController.swift
//  ParallelBrutePassword
//
//  Created by Ilya Volkov on 27.05.2022.
//

import UIKit

class CrackController: UIViewController {
    
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
    
    //Change the color of the subview depending on the color of the view
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
    
    //Flag indicating whether hacking is in progress or not
    private var isBreaking = true
    
    //Flag indicating that the password has been cracked or not
    private var isPassCracked = false
    
    //Flag configuring the Crack/Stop button
    private var isCrackButton: Bool = true {
        didSet {
            if isCrackButton {
                crackStopButton.setTitle(Strings.crackButtonTitle, for: .normal)
                isBreaking = false
                passField.isEnabled = true
                generatePassButton.isUserInteractionEnabled = true
            } else {
                crackStopButton.setTitle(Strings.stopButtonTitle, for: .normal)
                bruteForce(passwordToUnlock: passField.text ?? "")
                isBreaking = true
                isPassCracked = false
                passField.isEnabled = false
                generatePassButton.isUserInteractionEnabled = false
            }
        }
    }
    
    private let passwordGuessing = PasswordGuessing()
    private let password = Password()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        passField.isSecureTextEntry = true
    }
    
    //MARK: - Settings
    
    private func setupView() {
        setCornerRadiusForView(Sizes.cornerRadius10)
    }
    
    //MARK: - Actions
    
    @IBAction func changeViewColor(_ sender: Any) {
        isBlack.toggle()
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        passField.resignFirstResponder()
    }
    
    @IBAction func changeCrackStopButtonState(_ sender: Any) {
        
        //If passField is empty, then there is nothing to hack either
        if !(passField.text?.isEmpty ?? false) {
            isCrackButton.toggle()
        } else {
            crackedPassLabel.text = Strings.enterPassTitle
        }
    }
    
    //The generated password is sent to passField
    @IBAction func pushPassToPassField(_ sender: Any) {
        passField.isSecureTextEntry = true
        passField.text = password.generateRandomPass()
        print("\(Strings.generatedPassTitle) \(passField.text ?? "")")
    }
    
    
    //MARK: - Functions
    
    private func changeViewsColor(to color: UIColor) {
        viewColorButton.tintColor = color
        possiblePassLabel.textColor = color
        crackedPassLabel.textColor = color
        generatePassButton.backgroundColor = color
        crackStopButton.backgroundColor = color
        doneButton.tintColor = color
        activityIndicator.color = color
    }
    
    private func setCornerRadiusForView( _ corner: CGFloat) {
        hackMeImage.layer.cornerRadius = corner * Sizes.multiplierCornerRadius
        hackMeImage.layer.masksToBounds = true
        
        generatePassButton.layer.cornerRadius = corner
        generatePassButton.layer.masksToBounds = true
        
        crackStopButton.layer.cornerRadius = corner
        crackStopButton.layer.masksToBounds = true
    }
    
    private func passwordNotCracked() {
        crackedPassLabel.text = Strings.notCrackedTitle
        possiblePassLabel.text = ""
        activityIndicator.stopAnimating()
    }
    
    private func breakingPassword() {
        activityIndicator.startAnimating()
        crackedPassLabel.text = ""
    }
    
    private func passwordCracked() {
        passField.isSecureTextEntry = false
        isCrackButton = true
        activityIndicator.stopAnimating()
        possiblePassLabel.text = ""
    }
        
    private func hackStateChange(with password: String) {
        
        if !isPassCracked {
            breakingPassword()
            possiblePassLabel.text = password
        } else {
            passwordCracked()
            crackedPassLabel.text = "\(Strings.catchedTitle) \(password)"
        }
    }
    
    private func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        
        var password: String = ""
        
        let hackQueue = DispatchQueue(label: "hackQueue")
        
        hackQueue.async {
            while password != passwordToUnlock {
                
                guard self.isBreaking && !self.isPassCracked else {
                    DispatchQueue.main.async {
                        self.passwordNotCracked()
                    }
                    return
                }
                
                password = self.passwordGuessing.generateBruteForce(password, fromArray: allowedCharacters)
                print(password)
                DispatchQueue.main.async {
                    self.hackStateChange(with: password)
                }
            }
            self.isPassCracked = true
            print("\(Strings.crackedPassTitle) \(password)")
        }
    }
}
