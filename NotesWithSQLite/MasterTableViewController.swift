//  MasterTableViewController.swift
//  NotesWithSQLite
//
//  Created by Ali Abdat on 12/8/17.
//  Copyright © 2017 Ali Abdat. All rights reserved.
//

import UIKit
import SQLite
import AVFoundation

class MasterTableViewController: UITableViewController,AVAudioRecorderDelegate {
    
    let NoteTable = NoteSQLite()
    var SelectedCell = Int()
    var SingleNote = Note()
    var SelectedID = Int()
    @IBOutlet var MyTable: UITableView!
    @IBOutlet weak var AddButton: UIBarButtonItem!
    // act as refresh to let the table up-to-date with notes added
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        MyTable.reloadData()
    }
    // creating database & put the data in cells
    override func viewDidLoad() {
        super.viewDidLoad()
        NoteTable.CreatingDatabase()
        NoteTable.FillingCells()
        MyTable.reloadData()
    }
    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoteTable.note.count
    }
    //both segues act to return to the main ViewController
    
    @IBAction func DoneEditing(segue: UIStoryboardSegue){}
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    //put the texts on the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = NoteTable.note[indexPath.row].Title
        cell.detailTextLabel?.text = NoteTable.note[indexPath.row].Text
        return cell
    }
    // by click on one of the cells its segue to another ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if the segue destination was in Navigation controller which isn't the main ViewController it changes it
        var destinationVC = segue.destination
        if let navigationC = destinationVC as? UINavigationController
        {
            destinationVC = navigationC.visibleViewController ?? destinationVC
        }
        if segue.identifier == "PushingCells",
            let NotesVC = destinationVC as? NotesViewController
        {
            SelectedCell = (MyTable.indexPathForSelectedRow?.row)!
            SelectedID = self.NoteTable.note[SelectedCell].ID
            NotesVC.NoteText = self.NoteTable.note[SelectedCell].Text
            NotesVC.NoteTitle = self.NoteTable.note[SelectedCell].Title
            NotesVC.DoneButton.title = "Done Editing"
        }
    }
    // make a segue if one of the cells was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "PushingCells", sender: self)
    }
    
    // editing the table by deleting unused notes
    override func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCellEditingStyle,forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            SelectedCell = indexPath.row
            NoteTable.DeletingfromTable(SelectedCell: SelectedCell)
            MyTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
