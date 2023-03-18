//
//  NoteCell.swift
//  Notes-CFT
//
//  Created by work on 16.03.2023.
//

import Foundation
import UIKit

// MARK: - NoteCell

class NoteCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11).isActive = true
        title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        contentView.trailingAnchor.constraint(equalTo: title.trailingAnchor, constant: 20).isActive = true
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
                
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        subtitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        contentView.trailingAnchor.constraint(equalTo: subtitle.trailingAnchor, constant: 20).isActive = true
        contentView.bottomAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 11).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public methods
    
    func configure(title titleString: String?, subtitle subtitleString: String?) {
        self.title.text = titleString ?? "Новая заметка"
        subtitle.text = subtitleString ?? "Нет дополнительного текста"
    }
}
