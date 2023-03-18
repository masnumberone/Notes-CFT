//
//  ViewController.swift
//  Notes-CFT
//
//  Created by work on 12.03.2023.
//

import UIKit

// MARK: - MainViewController

class MainViewController: UIViewController {
    
    // MARK: - Private properties

    private let tableView = UITableView(frame: CGRectZero, style: .insetGrouped)
    private let notesService = NoteService.shared
    private var notes: [Note]!
    private var selectNote: IndexPath?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Заметки"
        notes = notesService.getNotes()
        if notes.count == 0 { addGreetingNote() }
        configureTableView()
        configureToolBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: false)
        guard let selectNote = selectNote else { return }
        tableView.deselectRow(at: selectNote, animated: true)
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        tableView.register(NoteCell.self, forCellReuseIdentifier: "noteCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    private func configureToolBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addEmptyNote))
        setToolbarItems([.flexibleSpace(), addButton], animated: true)
    }
    
    private func addGreetingNote() {
        let greetingNote = Note(text: NSAttributedString(string: "Привет!👋 Это твоя первая заметка\nЭто приложение позволяет создавать, удалять, редактировать заметки. А еще тут можно форматировать текст и вставлять картинки!", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]))
        notes.append(greetingNote)
        notesService.addNote(greetingNote)
    }
    
    // MARK: - Actions
    
    @objc private func addEmptyNote() {
        let note = Note(text: NSAttributedString(string: ""))
        notesService.addNote(note)
        notes.append(note)
        selectNote = IndexPath(row: notes.count - 1, section: 0)
        tableView.selectRow(at: selectNote, animated: true, scrollPosition: .none)
        
        let vc = NoteViewContoller(delegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Table View Data Source

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
        var lines = notes[indexPath.row].text.string.components(separatedBy: "\n")
        var title: String? = nil
        var subtitle: String? = nil
        
        if let titleIndex = lines.firstIndex(where: { !$0.isEmpty && $0 != " " }) {
            title = lines.remove(at: titleIndex)
            if title == "\u{0000fffc}" { title = "Изображение" }
        }
        if let subtitleIndex = lines.firstIndex(where: { !$0.isEmpty && $0 != " " }) {
            subtitle = lines.remove(at: subtitleIndex)
            if subtitle == "\u{0000fffc}" { subtitle = "Изображение" }
        }
        cell.configure(title: title, subtitle: subtitle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
}

// MARK: - Table View Delegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectNote = indexPath
        let vc = NoteViewContoller(delegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, view, completion in
            self.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.notesService.saveNotes(self.notes)
            completion(true)
        }
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20)))
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

// MARK: - Note Delegate

extension MainViewController: NoteViewControllerDelegate {
    func getNote() -> Note {
        notes[selectNote!.row]
    }
    
    func noteDidChange() {
        tableView.reloadData()
        notesService.saveNotes(notes)
    }
}


