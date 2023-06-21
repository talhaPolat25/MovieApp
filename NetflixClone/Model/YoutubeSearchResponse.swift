//
//  YoutubeSearchResponse.swift
//  NetflicClone
//
//  Created by talha polat on 10.05.2023.
//

import Foundation

struct YoutubeSearchResponse:Codable{
    let items:[YoutubeSearchElement]
}

struct YoutubeSearchElement:Codable{
    let id:IdSearchElement
}

struct IdSearchElement:Codable{
    let kind:String
    let videoId:String
}
