//
//  Note.swift
//  Project 21a - Milestone - Notes
//
//  Created by Sean Williams on 29/10/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import Foundation

class Note: NSObject, Codable {
    var title: String
    var text: String
    let id: String
    let date: Date
    
    init(title: String, text: String, id: String, date: Date) {
        self.title = title
        self.text = text
        self.id = id
        self.date = date
    }
    
}
