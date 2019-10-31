//
//  ViewController.swift
//  Project 21a - Milestone - Notes
//
//  Created by Sean Williams on 29/10/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var share: UIBarButtonItem!
    
    
    var notes = [Note]()
    var note: Note!
    var viewingExistingNote = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isToolbarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
        let deleteNoteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style:.done, target: self, action: #selector(deleteNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [deleteNoteButton, spacer, composeButton]
        
        if viewingExistingNote {
            textView.text = note.text
            
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveNote()
    }
    
    
    
    
    //MARK: - Private Methods
    
    fileprivate func saveNote() {
        if viewingExistingNote {
            //filter the notes array locating note with matching ID, set its text to new text and save.
            let editedNote = notes.filter({$0.id == note.id}).first
            if let editedNote =  editedNote {
                editedNote.text = textView.text
                
                if let range = textView.text.range(of: "\n") {
                let rangeOfString = textView.text.startIndex ..< range.upperBound
                let title = String(textView.text[rangeOfString])
                
                editedNote.title = title
                }
            }
            save()
            
        } else if viewingExistingNote == false && !textView.text.isEmpty {
            //Saving new note
            let id = UUID().uuidString
            
            if let range = textView.text.range(of: "\n") {
                let rangeOfString = textView.text.startIndex ..< range.upperBound
                let title = String(textView.text[rangeOfString])
                
                let note = Note(title: title, text: textView.text, id: id, date: Date())
                notes.append(note)
                save()
            } else {
                let note = Note(title: textView.text, text: textView.text, id: id, date: Date())
                notes.append(note)
                save()
            }
        }
    }
    
    @objc func compose() {
        saveNote()
        
        viewingExistingNote = false
        textView.text = ""
        saveNote()
    }
    
    @objc func deleteNote() {
        for (index, noteToDelete) in notes.enumerated().reversed() {
            if noteToDelete.id == note.id {
                notes.remove(at: index)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            UserDefaults.standard.set(savedData, forKey: "notes")
        } else {
            print("Could not save data")
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
         guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
         
         let keyboardScreenEndFrame = keyboardValue.cgRectValue
         // Convert frame from size of screen which will now be the correct size of the kyboard
         let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
         
         //Check if we are hiding
         if notification.name == UIResponder.keyboardWillHideNotification {
             textView.contentInset = .zero
         } else {
             textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
         }
         
         textView.scrollIndicatorInsets = textView.contentInset
         
         //Make scroll view scroll down to show what user has just tapped on
         let selectedRange = textView.selectedRange
         textView.scrollRangeToVisible(selectedRange)
     }
    
    
    //MARK: - Action Methods
    
    @IBAction func shareTapped(_ sender: Any) {
        guard let text = textView.text else { return }
        
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    
}

