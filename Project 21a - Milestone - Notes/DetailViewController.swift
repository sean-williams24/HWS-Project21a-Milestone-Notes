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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isToolbarHidden = false

        
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
        let deleteNoteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style:.done, target: self, action: #selector(deleteNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [deleteNoteButton, spacer, composeButton]
        
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let note = Note(title: "Title", text: textView.text)
        notes.append(note)
        save()
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

