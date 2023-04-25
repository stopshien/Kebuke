//
//  Model.swift
//  Kebuke
//
//  Created by 沈庭鋒 on 2023/4/21.
//

import Foundation

struct Records:Codable{
    let records : [DrinksInfo]
}

struct DrinksInfo:Codable{
    let id : String
    let createdTime : String
    let fields : Fields
}

struct Fields:Codable{
    let name :String
    let sugar : [String]
    let ice : [String]
    let size : [String]
    let midPrice : String
    let type : String
    let detail : String
    let info : String
    let largePrice : String?
    let image : [Image]
}

struct Image : Codable{
    let url : URL
}
