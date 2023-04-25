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
    var id : String //上傳資料中沒有id 若加進去會找不到資料，猜測可用optional或是直接不用後台會自己加入
    let fields : OrderData
}
struct OrderData:Codable{
    
    var name : String
    var sugar : String?
    var ice : String?
    var size : String?
    var price : Int?
    var image : URL?
    var human : String
    var whiteBubble : Bool?
    var whiteJelly : Bool?
    var sweetAlmond : Bool?

    
}

