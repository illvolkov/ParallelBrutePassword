//
//  String+Extension.swift
//  ParallelBrutePassword
//
//  Created by Ilya Volkov on 28.05.2022.
//

extension String {
    var digits: String { return Strings.digits }
    var lowercase: String { return Strings.lowercase }
    var uppercase: String { return Strings.uppercase }
    var punctuation: String { return Strings.punctuation }
    var letters: String { return lowercase + uppercase }
    var printable: String { return digits + letters + punctuation }
    
    
    
    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}
