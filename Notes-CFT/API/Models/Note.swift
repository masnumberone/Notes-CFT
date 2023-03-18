//
//  Note.swift
//  Notes-CFT
//
//  Created by work on 12.03.2023.
//

import Foundation

// MARK: - Note

class Note: NSObject, NSCoding {
    
    // MARK: - Properties
    
    var text: NSAttributedString
    private let textKey = "text"
    
    // MARK: - Initializers
    
    init(text: NSAttributedString) {
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        guard let text = coder.decodeObject(forKey: textKey) as? NSAttributedString else {
            return nil
        }
        self.text = text
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(text, forKey: textKey)
    }
}
