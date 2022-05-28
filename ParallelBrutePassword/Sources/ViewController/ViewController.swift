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
    
    //Смена цвета вьюшек в зависимости от цвета супервью
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
    //Флаг говорящий о том что идет взлом или нет
    private var isBreaking = true
    
    //Флаг говорящий о том что взломан пароль или нет
    private var isPassCracked = false
    
    //Флаг конфигурирующий кнопку Crack/Stop
    private var isCrackButton: Bool = true {
        didSet {
            if isCrackButton {
                self.crackStopButton.setTitle("Crack", for: .normal)
                isBreaking = false
            } else {
                crackStopButton.setTitle("Stop", for: .normal)
                bruteForce(passwordToUnlock: passField.text ?? "")
                isBreaking = true
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
        
        //Если пароль взломан то взламывать уже нечего
        guard !isPassCracked else { return crackedPassLabel.text = "Password already cracked..." }
        
        //Если passField пустой то взламывать тоже нечего
        if !(passField.text?.isEmpty ?? false) {
            isCrackButton.toggle()
        } else {
            crackedPassLabel.text = "C'mon, enter password!"
        }
    }
    
    //Сгенерированный пароль отправляется в passField
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
    
    private func passwordNotCracked() {
        crackedPassLabel.text = "Password not cracked :("
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
    
    func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        
        var password: String = ""
        
        let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
        let mainQueue = DispatchQueue.main
        
        guard !isPassCracked else { return crackedPassLabel.text = "Password already cracked..." }
        
        concurrentQueue.async {
            while password != passwordToUnlock {
                
                //Взлом или остановка взлома
                if self.isBreaking {
                    password = self.passwordGuessing.generateBruteForce(password, fromArray: allowedCharacters)
                } else {
                    mainQueue.async {
                        self.passwordNotCracked()
                    }
                    return
                }
                mainQueue.async {
                    self.breakingPassword()
                    self.possiblePassLabel.text = password
                }
                print(password)
            }
            mainQueue.async {
                self.passwordCracked()
                self.crackedPassLabel.text = "Catched! \(password)"
            }
            self.isPassCracked = true
            print("Взломанный пароль: \(password)")
        }
    }
}
