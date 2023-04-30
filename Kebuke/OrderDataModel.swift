//
//  OrderDataModel.swift
//  Kebuke
//
//  Created by 沈庭鋒 on 2023/4/23.
//

import Foundation

struct OrderResponse:Codable{
    let records : [OrderBody]
}

struct OrderBody:Codable{
    var fields : OrderData
}


struct OrderData:Codable{
    
    var name : String
    var sugar : String
    var ice : String
    var size : String
    var price : Int?
    var image : URL?
    var human : String
    var whiteBubble : Bool?
    var whiteJelly : Bool?
    var sweetAlmond : Bool?

    
}

