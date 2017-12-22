//
//  Notes.swift
//  NotesWithSQLite
//
//  Created by Ali Abdat on 12/8/17.
//  Copyright © 2017 Ali Abdat. All rights reserved.
//

import Foundation
import SQLite
class NoteSQLite {
    var note = [Note]()
    let NotesTable = Table ("Notes")
    let ID = Expression<Int> ("ID")
    let Text = Expression<String> ("Text")
    let Title = Expression<String> ("Title")
    var Database : Connection!
    private func CreateTable ( ) -> String
    {
        let createTable = NotesTable.create { (Table) in
            Table.column(ID, primaryKey: true)
            Table.column(Text)
            Table.column(Title)
        }
        return createTable
    }
    func CreatingDatabase() {
        do{
            let SavingDocument = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let FileUrl = SavingDocument.appendingPathComponent("Notes").appendingPathExtension("sqlite3")
            let DataBase = try Connection(FileUrl.path)
            self.Database = DataBase
            try self.Database.run(CreateTable())
        }catch
        {
            print(error)
        }
    }
    
    func UpdateDatabase(TableChecker : Table , Title : String, Text : String)
    {
        let UpdateText = TableChecker.update(self.Text <- Text, self.Title <- Title)
        do{
            try Database.run(UpdateText)
        }
        catch{
            print(error)
        }
    }
    
    func InsertInDatabase(Title : String, Text : String)
    {
        let InsertData = NotesTable.insert(self.Text <- Text , self.Title <-  Title)
        do
        {
            try Database.run(InsertData)
        }
        catch{
            print(error)
        }
    }
    
    func DeletingfromTable(SelectedCell : Int)
    {
        let SelectedID = note[SelectedCell].ID
        note.remove(at: SelectedCell)
        let IDChecker = NotesTable.filter(ID  == SelectedID)
        let Deleteall = IDChecker.delete()
        do{
            try Database.run(Deleteall)
        }
        catch{
            print(error)
        }
    }
    
    func FillingCells() {
        do
        {
            let notes = try self.Database.prepare(NotesTable)
            for note in notes
            {
                self.note.append(Note.init(ID: note[ID],Title: note[Title],Text: note[Text]))
            }
        }
        catch{
            print(error)
        }
    }
}
