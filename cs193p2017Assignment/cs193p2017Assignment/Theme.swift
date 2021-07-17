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
}

struct EmojiCollection {
    static var faceEmojis = ["🤐", "😵‍💫", "🤢", "🤮", "🤧", "😷", "👺", "🤑"]
    static var hallowinEmojis = ["👻", "👺", "👽", "💀", "☠️", "👹", "🎃"]
    static var constructionEmojis = ["👷🏻‍♀️", "🧱", "🪓", "🔧", "🔨", "🔩", "⛏", "🚜", "🛠"]
    
    static func returnEmojiSet(for theme: Theme) -> [String] {
        switch theme {
        case .face:
            return EmojiCollection.faceEmojis
        case .halloween:
            return EmojiCollection.hallowinEmojis
        case .construction:
            return EmojiCollection.constructionEmojis
        }
    }
    
    static func returnRandomEmojiSet() -> [String]{
        let themes = [Theme.face, Theme.halloween, Theme.construction]
        let themeChosen = themes.randomElement() ?? Theme.face
        
        return returnEmojiSet(for: themeChosen)
    }
    
}
