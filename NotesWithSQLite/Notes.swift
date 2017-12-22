//
//  Notes.swift
//  NotesWithSQLite
//
//  Created by Ali Abdat on 12/19/17.
//  Copyright © 2017 Ali Abdat. All rights reserved.
//

import Foundation
class Note
{
    var ID = Int()
    var Title = String()
    var Text = String()
    init() {
    }
    init(ID : Int ,Title: String, Text: String )
    {
        self.ID = ID
        self.Text = Text
        self.Title = Title
    }
}
