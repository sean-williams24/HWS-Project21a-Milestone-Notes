//
//  ViewController.swift
//  Project 21a - Milestone - Notes
//
//  Created by Sean Williams on 29/10/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var share: UIBarButtonItem!
    
    
    var notes = [Note]()
    var note: Note!
    var viewingExistingNote = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isToolbarHidden = false
        
        
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
        let deleteNoteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style:.done, target: self, action: #selector(deleteNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [deleteNoteButton, spacer, composeButton]
        
        if viewingExistingNote {
            textView.text = note.text

        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if viewingExistingNote {
            //filter the notes array locating note with matching ID, set its text to new text and save.
            notes.filter({$0.id == note.id}).first?.text = textView.text
            save()
        } else {
            //Saving new note
            let id = UUID().uuidString
            
            if let range = textView.text.range(of: "\n") {
                let rangeOfString = textView.text.startIndex ..< range.upperBound
                let title = String(textView.text[rangeOfString])
                
                let note = Note(title: title, text: textView.text, id: id, date: Date())
                notes.append(note)
                save()
            }
        }
        
    }
    

    
    
    //MARK: - Private Methods
    
    @objc func compose() {
        
    }
    
    @objc func deleteNote() {
        
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            UserDefaults.standard.set(savedData, forKey: "notes")
        } else {
            print("Could not save data")
        }
    }
    
}

