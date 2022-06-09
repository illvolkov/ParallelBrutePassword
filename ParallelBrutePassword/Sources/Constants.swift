//
//  Constants.swift
//  ParallelBrutePassword
//
//  Created by Ilya Volkov on 29.05.2022.
//

import UIKit

enum Strings {
    
    //MARK: - CrackController
    static let crackButtonTitle: String = "Crack"
    static let stopButtonTitle: String = "Stop"
    static let alreadyCrackedTitle: String = "Password already cracked..."
    static let enterPassTitle: String = "C'mon, enter password!"
    static let notCrackedTitle: String = "Password not cracked :("
    static let concurrentLabel: String = "concurrentQueue"
    static let catchedTitle: String = "Catched!"
    static let crackedPassTitle: String = "Сracked password:"
    static let generatedPassTitle: String = "Generated password:"
    
    //MARK: - Password
    static let letters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    //MARK: - String+Extension
    static let digits: String = "0123456789"
    static let lowercase: String = "abcdefghijklmnopqrstuvwxyz"
    static let uppercase: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let punctuation: String = "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
}

enum Sizes {
    
    //MARK: - CrackController
    static let cornerRadius10: CGFloat = 10
    static let multiplierCornerRadius: CGFloat = 5
}
