//
//  NoteViewController.swift
//  Notes-CFT
//
//  Created by work on 12.03.2023.
//

import Foundation
import UIKit

class NoteViewContoller: UIViewController {
    
    // MARK: - Properties
    
    private let textView = NoteTextView()
    private let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
    private var note: Note!
    private weak var delegate: NoteViewControllerDelegate?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        note = delegate?.getNote()
        configureTextView()
        configureKeyboardNotifications()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if note.text.length == .zero { textView.becomeFirstResponder() }
    }
    
    // MARK: - Private methods
    
    private func configureTextView() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: textView.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        textView.delegate = self
        textView.allowsEditingTextAttributes = true
        textView.textContainerInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        if note.text.length == 0 {
            textView.font = .preferredFont(forTextStyle: .body)
        }
        
        let mutableAttributedString = note.text.mutableCopy() as! NSMutableAttributedString
        let attributes: [NSAttributedString.Key: Any]
        if traitCollection.userInterfaceStyle == .dark {
            attributes = [
               .font: UIFont.preferredFont(forTextStyle: .body),
               .foregroundColor: UIColor.white,
               .backgroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0)
           ]
        } else {
            attributes = [
               .font: UIFont.preferredFont(forTextStyle: .body),
               .foregroundColor: UIColor.black,
               .backgroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0)
           ]
        }
        mutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: mutableAttributedString.length))
        textView.attributedText = mutableAttributedString
    }
    
    private func configureKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIControl.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIControl.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Actions
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        navigationItem.rightBarButtonItem = doneButton
        
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        textView.contentInset = contentInsets
        textView.scrollIndicatorInsets = contentInsets
    }

    @objc private func keyboardWillHide() {
        navigationItem.rightBarButtonItem = nil
        let contentInsets = UIEdgeInsets.zero
        textView.contentInset = contentInsets
        textView.scrollIndicatorInsets = contentInsets
    }

    
    @objc private func didTapDoneButton() {
        textView.endEditing(false)
    }
    
    // MARK: - Initializers
    
    init(delegate: NoteViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

// MARK: - Text View Delegate

extension NoteViewContoller: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        note.text = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        delegate?.noteDidChange()
    }
    
}

// MARK: - NoteTextView

class NoteTextView: UITextView {
    override func paste(_ sender: Any?) {
        guard let image = UIPasteboard.general.image else {
            super.paste(sender)
            return
        }
        let scaleFactor = image.size.width / (bounds.size.width - 48)
        let scaledImageSize = CGSize(width: image.size.width / scaleFactor, height: image.size.height / scaleFactor)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image.resized(to: scaledImageSize)

        let attributedStringWithImage = NSMutableAttributedString(attributedString: attributedText)
        attributedStringWithImage.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]))
        attributedStringWithImage.append(NSMutableAttributedString(attributedString: NSAttributedString(attachment: imageAttachment)))
        attributedStringWithImage.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]))
        attributedText = attributedStringWithImage
    }
}

// MARK: - UIImage extension

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
