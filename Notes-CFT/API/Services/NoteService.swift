//
//  NoteService.swift
//  Notes-CFT
//
//  Created by work on 12.03.2023.
//

import Foundation

// MARK: - NoteService

class NoteService {
    
    // MARK: - Static property
    
    static let shared = NoteService()
    
    // MARK: - Private initializer
    
    private init() {  }
    
    // MARK: - Properties
    
    private let defaults = UserDefaults.standard
    private let notesKey = "notes"
    
    // MARK: - Public methods
    
    func getNotes() -> [Note] {
        guard let encodedData = UserDefaults.standard.data(forKey: notesKey) else {
            return []
        }
        do {
            let notes = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(encodedData) as! [Note]
            return notes
        } catch {
            print("Error loading notes: \(error.localizedDescription)")
            return []
        }
    }
    
    func addNote(_ note: Note) {
        var notes = getNotes()
        notes.append(note)
        saveNotes(notes)
    }
    
    func addEmptyNote() {
        var notes = getNotes()
        notes.append(Note(text: NSAttributedString(string: String())))
        saveNotes(notes)
    }
    
    func saveNotes(_ notes: [Note]) {
        let operationQueue = OperationQueue()
        let saveNoteOperation = BlockOperation {
            do {
                let encodedData = try NSKeyedArchiver.archivedData(withRootObject: notes, requiringSecureCoding: false)
                UserDefaults.standard.set(encodedData, forKey: self.notesKey)
            } catch {
                print("Error saving notes: \(error.localizedDescription)")
            }
        }
        operationQueue.addOperation(saveNoteOperation)

    }
}
