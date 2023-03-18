//
//  NoteViewControllerDelegate.swift
//  Notes-CFT
//
//  Created by work on 13.03.2023.
//

import Foundation

// MARK: - NoteViewController Delegate

protocol NoteViewControllerDelegate: AnyObject {
    
    // MARK: - Public methods
    
    func getNote() -> Note
    func noteDidChange()
    
}
