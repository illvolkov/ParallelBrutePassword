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
                bruteForce(passwordToUnlock: passField.text ?? "")
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
        if !(passField.text?.isEmpty ?? false) {
            isCrackButton.toggle()
        } else {
            crackedPassLabel.text = "Введите пароль"
        }
    }
    
    @IBAction func pushPassToPassField(_ sender: Any) {
        passField.text = password.generateRandomPass()
        print("Сгенерированный пароль: \(passField.text ?? "")")
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
        hackMeImage.layer.cornerRadius = corner * 5
        hackMeImage.layer.masksToBounds = true
        
        generatePassButton.layer.cornerRadius = corner
        generatePassButton.layer.masksToBounds = true
        
        crackStopButton.layer.cornerRadius = corner
        crackStopButton.layer.masksToBounds = true
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        
        var password: String = ""

        let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
        let mainQueue = DispatchQueue.main
        
        concurrentQueue.async {
            while password != passwordToUnlock {
                password = self.passwordGuessing.generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
                mainQueue.async {
                    self.activityIndicator.startAnimating()
                    self.possiblePassLabel.text = password
                }
                print(password)
            }
            mainQueue.async {
                self.passField.isSecureTextEntry = false
                self.isCrackButton = true
                self.activityIndicator.stopAnimating()
                self.possiblePassLabel.text = ""
                self.crackedPassLabel.text = "Catched: \(password)"
            }
        }
    }
}
