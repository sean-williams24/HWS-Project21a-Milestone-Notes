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
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = notes[indexPath.row]

        // Configure the cell...
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.text

        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = notes[indexPath.row]
        note = selectedNote
        viewingExistingNote = true
        performSegue(withIdentifier: "DetailVC", sender: self)

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
