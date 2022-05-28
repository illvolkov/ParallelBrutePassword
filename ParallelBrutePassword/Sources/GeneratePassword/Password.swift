//
//  GeneratePassword.swift
//  ParallelBrutePassword
//
//  Created by Ilya Volkov on 28.05.2022.
//

struct Password {
    
    func generateRandomPass() -> String {
        let lenght = 4
        let letters = Strings.letters
        let randomPass = String((0..<lenght).compactMap { _ in letters.randomElement() })
        return randomPass
    }
}
