//
//  Theme.swift
//  cs193p2017Assignment
//
//  Created by klioop on 2021/07/16.
//

import Foundation

enum Theme: String {
    case face
    case halloween
    case construction
    
    func returnEmojiSet() -> [String] {
        switch self {
        case .face:
            return EmojiCollection.faceEmojis
        case .halloween:
            return EmojiCollection.hallowinEmojis
        case .construction:
            return EmojiCollection.constructionEmojis
        }
    }
}

struct EmojiCollection {
    static var faceEmojis = ["🤐", "😵‍💫", "🤢", "🤮", "🤧", "😷", "👺", "🤑"]
    static var hallowinEmojis = ["👻", "👺", "👽", "💀", "☠️", "👹", "🎃"]
    static var constructionEmojis = ["👷🏻‍♀️", "🧱", "🪓", "🔧", "🔨", "🔩", "⛏", "🚜", "🛠"]
}
