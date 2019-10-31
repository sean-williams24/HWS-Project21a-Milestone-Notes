//
//  NotesTableViewController.swift
//  Project 21a - Milestone - Notes
//
//  Created by Sean Williams on 29/10/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {

    var notes = [Note]()
    var note: Note!
    var viewingExistingNote = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isToolbarHidden = false
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.toolbar.tintColor = .systemYellow
        navigationController?.navigationBar.tintColor = .systemYellow
        
        loadSavedNotes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadSavedNotes()
        
        tableView.reloadData()
        
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
        let noteCount = UIBarButtonItem(title: "\(notes.count) Notes", style: .done, target: nil, action: nil)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, noteCount, spacer, composeButton]
    }
    
    //MARK: - Private Methods
    
    @objc func compose() {
        viewingExistingNote = false
        performSegue(withIdentifier: "DetailVC", sender: self)
    }
    
    func loadSavedNotes() {
        if let savedNotes = UserDefaults.standard.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Could not load data")
            }
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            UserDefaults.standard.set(savedData, forKey: "notes")
        } else {
            print("Could not save data")
        }
    }
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = notes[indexPath.row]
        let date = note.date.description
        if let subDate = date.components(separatedBy: " ").first {
            
            if let range = note.text.range(of: "\n") {
                let rangeOfString = range.upperBound ..< note.text.endIndex
                let subtitle = String(note.text[rangeOfString])
                cell.detailTextLabel?.text = "\(subDate)   \(subtitle)"
            } else {
                cell.detailTextLabel?.text = "\(subDate)   No additional text"
            }
        }

        // Configure the cell...
        cell.textLabel?.text = note.title


        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = notes[indexPath.row]
        note = selectedNote
        viewingExistingNote = true
        performSegue(withIdentifier: "DetailVC", sender: self)

    }


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            notes.remove(at: indexPath.row)
            save()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailViewController
        // Pass the selected object to the new view controller.
        vc.notes = notes
        vc.note = note
        vc.viewingExistingNote = viewingExistingNote

    }
    

}
