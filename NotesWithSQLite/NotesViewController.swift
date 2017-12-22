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
//    var activeField: UITextView?
//    func registerForKeyboardNotifications(){
//        //Adding notifies on keyboard appearing
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    
//    func deregisterFromKeyboardNotifications(){
//        //Removing notifies on keyboard appearing
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    
//    @objc func keyboardWasShown(notification: NSNotification){
//        //Need to calculate keyboard exact size due to Apple suggestions
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
//        MyTextView.scrollIndicatorInsets = contentInsets
//        
//        var aRect : CGRect = self.view.frame
//        aRect.size.height -= keyboardSize!.height
//        if let activeField = self.activeField {
//            if (!aRect.contains(activeField.frame.origin)){
//                //MyTextView.scrollRangeToVisible(activeField.frame)
//                MyTextView.scrollRectToVisible(activeField.frame, animated: true)
//                //self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
//            }
//        }
//    }
//    @objc func keyboardWillBeHidden(notification: NSNotification){
//        //Once keyboard disappears, restore original positions
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
//        MyTextView.scrollIndicatorInsets = contentInsets
//        self.view.endEditing(true)
//    }
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        activeField = textView
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        activeField = nil
//    }

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
//    @objc func keyboardFrameWillDisappear(notification: NSNotification)
//    {
//        let keyboardBeginFrame = ((notification.userInfo! as NSDictionary).object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue
//        let keyboardEndFrame = ((notification.userInfo! as NSDictionary).object(forKey: UIKeyboardFrameEndUserInfoKey)! as AnyObject).cgRectValue
//
//        let animationCurve = UIViewAnimationCurve(rawValue: ((notification.userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationCurveUserInfoKey)! as AnyObject).integerValue)
//
//        let animationDuration: TimeInterval = ((notification.userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationDurationUserInfoKey)! as AnyObject).doubleValue
//
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(animationDuration)
//        UIView.setAnimationCurve(animationCurve!)
//
//        var newFrame = self.view.frame
//        let keyboardFrameEnd = self.view.convert(keyboardEndFrame!, to: nil)
//        let keyboardFrameBegin = self.view.convert(keyboardBeginFrame!, to: nil)
//
//        newFrame.origin.y += (keyboardFrameBegin.origin.y + keyboardFrameEnd.origin.y)
//        self.view.frame = newFrame;
//
//        UIView.commitAnimations()
//    }
//    @objc func keyboardFrameWillChange(notification: NSNotification) {
//        let keyboardBeginFrame = ((notification.userInfo! as NSDictionary).object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue
//        let keyboardEndFrame = ((notification.userInfo! as NSDictionary).object(forKey: UIKeyboardFrameEndUserInfoKey)! as AnyObject).cgRectValue
//
//        let animationCurve = UIViewAnimationCurve(rawValue: ((notification.userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationCurveUserInfoKey)! as AnyObject).integerValue)
//
//        let animationDuration: TimeInterval = ((notification.userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationDurationUserInfoKey)! as AnyObject).doubleValue
//
//        UIView.beginAnimations(nil, context: nil)
//        UIView.setAnimationDuration(animationDuration)
//        UIView.setAnimationCurve(animationCurve!)
//
//        var newFrame = self.view.frame
//        let keyboardFrameEnd = self.view.convert(keyboardEndFrame!, to: nil)
//        let keyboardFrameBegin = self.view.convert(keyboardBeginFrame!, to: nil)
//
//        newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y)
//        self.view.frame = newFrame;
//
//        UIView.commitAnimations()
//    }
}
