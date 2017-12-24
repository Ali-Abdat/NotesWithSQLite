//
//  ViewController.swift
//  NotesWithSQLite
//
//  Created by Ali Abdat on 12/8/17.
//  Copyright © 2017 Ali Abdat. All rights reserved.
//

import UIKit
import SQLite
class NotesViewController: UIViewController,UISplitViewControllerDelegate,UITextViewDelegate{
    let SingleNote = Note()
    var NoteText = String()
    var NoteTitle = String()
    @IBOutlet weak var MyTextView: UITextView!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var DoneButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.MyTextView.text = NoteText
        self.TextField.text = NoteTitle
        DoneButton.isEnabled = false
        TextField.addTarget(self, action: #selector(IsEmpty),for: .editingChanged)
        self.MyTextView.delegate=self
        self.splitViewController?.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    func splitViewController(_ splitViewController: UISplitViewController,collapseSecondary secondaryViewController: UIViewController,onto primaryViewController: UIViewController) -> Bool
    {
            return true
    }
    @IBAction func SavingText(_ sender: UIBarButtonItem)
    {
        if DoneButton.title == "Done Editing"
        {
            self.performSegue(withIdentifier: "DoneEditingSegue", sender: self)
             DoneButton.title = "Done"
        }
        else
        {
            self.performSegue(withIdentifier: "DoneSegue", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC = segue.destination
        if let navigationC = destinationVC as? UINavigationController{
            destinationVC = navigationC.visibleViewController ?? destinationVC
        }
        let MasterTVC = destinationVC as? MasterTableViewController
        if segue.identifier == "DoneSegue"
        {
            SingleNote.Text = MyTextView.text
            SingleNote.Title = TextField.text!
            MasterTVC?.NoteTable.note.append(SingleNote)
            MasterTVC?.NoteTable.InsertInDatabase(Title: SingleNote.Title, Text: SingleNote.Text)
        }
        else if segue.identifier == "DoneEditingSegue"
        {
            MasterTVC?.NoteTable.note[(MasterTVC?.SelectedCell)!].Text = MyTextView.text
            MasterTVC?.NoteTable.note[(MasterTVC?.SelectedCell)!].Title = TextField.text!
            let IDChecker = MasterTVC?.NoteTable.NotesTable.filter((MasterTVC?.NoteTable.ID)!  == (MasterTVC?.SelectedID)!)
            MasterTVC?.NoteTable.UpdateDatabase(TableChecker: IDChecker!, Title: TextField.text!, Text: MyTextView.text)
        }
        MasterTVC?.MyTable.reloadData()
    }
}
extension NotesViewController
{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textViewDidChange(_ textView: UITextView) {
        if(MyTextView.text.isEmpty == true || TextField.text?.isEmpty == true || (TextField.text == NoteTitle && MyTextView.text == NoteText))
        {
            DoneButton.isEnabled = false
        }
        else
        {
            DoneButton.isEnabled = true
        }
    }
    @objc func IsEmpty(_ textField: UITextField) {
        if(TextField.text?.isEmpty == true || MyTextView.text.isEmpty == true || (TextField.text == NoteTitle && MyTextView.text == NoteText))
        {
            DoneButton.isEnabled = false
        }
        else
        {
            DoneButton.isEnabled = true
        }
    }
}
