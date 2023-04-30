//
//  ShopCartModel.swift
//  Kebuke
//
//  Created by 沈庭鋒 on 2023/4/25.
//

import Foundation

struct OrderResponseForCart:Codable{
    let records : [OrderBodyForCart]
}

struct OrderBodyForCart:Codable{
        var id : String //上傳資料中沒有id 若加進去會找不到資料，猜測可用optional或是直接不用後台會自己加入
//        let createdTime : String
        var fields : OrderData
}
