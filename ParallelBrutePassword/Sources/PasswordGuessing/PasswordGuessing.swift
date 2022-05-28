//
//  PasswordGuessing.swift
//  ParallelBrutePassword
//
//  Created by Ilya Volkov on 28.05.2022.
//


struct PasswordGuessing {
        
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character)) ?? 0
    }

    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index]) : Character("")
    }

    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        } else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last ?? Character(""), array) + 1) % array.count, array))

            if indexOf(character: str.last ?? Character(""), array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last ?? Character(""))
            }
        }

        return str
    }
}
