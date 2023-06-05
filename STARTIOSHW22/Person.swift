//
//  Person.swift
//  STARTIOSHW22
//
//  Created by Adlet Zhantassov on 03.06.2023.
//

import Foundation

struct User {
    let name: String
    let surname: String
    
    var fio: String {
        self.name + " " + self.surname
    }
}

typealias Users = [User]
