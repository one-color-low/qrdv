//
//  User.swift
//  qrdb_v0
//
//  Created by Yuta on 2022/09/18.
//

import Foundation


struct User{
    var id: Int
    var name: String
    var address: String
    var phone_number: String
    //var birth_date: Date
    
    init(id: Int, name: String, address: String, phone_number: String) {
        self.id = id
        self.name = name
        self.address = address
        self.phone_number = phone_number
        //self.birth_date = birth_date
    }
}
