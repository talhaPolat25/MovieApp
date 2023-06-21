//
//  Movies.swift
//  NetflicClone
//
//  Created by talha polat on 3.05.2023.
//

import Foundation

struct Media:Codable{
    let results:[Movie]
}

struct Movie:Codable{
    let id:Int
    let title:String?
    let name:String?
    let original_title:String?
    let poster_path:String?
    let overview:String
}
