//
//  ShopCartViewController.swift
//  Kebuke
//
//  Created by 沈庭鋒 on 2023/4/23.
//

import UIKit
import Kingfisher

class ShopCartViewController: UIViewController {

    var shopCartListArray = [OrderBodyForCart]()
    var totalMoneyCount = 0
    var deleteID = ""
    
    @IBOutlet weak var drinksCount: UILabel!
    
    @IBOutlet weak var totalMoney: UILabel!
    
    @IBOutlet weak var shopCartTableView: UITableView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shopCartTableView.delegate = self
        shopCartTableView.dataSource = self
        fetchShopCartList()
    }
    
    @IBAction func backToMenuButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    

    @IBAction func unwindToDetailViewController(_ unwindSegue: UIStoryboardSegue) {
        fetchShopCartList()
    }

    
    func deleteDrinkTask(){
        let shopCartURL = "https://api.airtable.com/v0/app8qDE2IVOV4sQFh/kebukeOrderList"
        if let deleteURL = URL(string: "\(shopCartURL)/\(deleteID)"){
            var request = URLRequest(url: deleteURL)
            request.httpMethod = "DELETE"
            request.setValue("Bearer keyTaDO1pC3Wi8kV3", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                }
            }.resume()
        }
    }
    
        func fetchShopCartList(){
        // 加入排序條件，依照單品建立時間做排序
        let shopCartURL = "https://api.airtable.com/v0/app8qDE2IVOV4sQFh/kebukeOrderList?sort[][field]=createdTime&sort[][direction]=asc"
        guard let url = URL(string: shopCartURL)  else{return}
        var request = URLRequest(url: url)
        request.setValue("Bearer keyTaDO1pC3Wi8kV3", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let content = String(data: data, encoding: .utf8){
                do {
                    let result = try JSONDecoder().decode(OrderResponseForCart.self, from: data)
                    self.shopCartListArray = result.records
                    DispatchQueue.main.async {
                        self.totalSet()
                        self.shopCartTableView.reloadData()
                    }
                    print(content)
                } catch  {
                    print(error)
                }
            }
        }.resume()
        
    }
    
    func totalSet(){
        
        totalMoneyCount = 0
        
        if shopCartListArray.count != 0{
            for i in 0...shopCartListArray.count-1{
                totalMoneyCount += shopCartListArray[i].fields.price!
            }
        }
            
            drinksCount.text = "共\(shopCartListArray.count)杯"
            totalMoney.text = "TOTAL : NT. \(totalMoneyCount) $"
        
    }

}

extension ShopCartViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopCartListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ShopCartTableViewCell.self)", for: indexPath) as! ShopCartTableViewCell
        
        let indexPathForRowItem = shopCartListArray[indexPath.row].fields
        
              
        cell.drinkImageView.kf.setImage(with: indexPathForRowItem.image)
        cell.drinkName.text = indexPathForRowItem.name
        cell.orderer.text = "訂購者： \(indexPathForRowItem.human)"
        if let price = indexPathForRowItem.price{
            cell.drinksizeNPrice.text = "NT. \(price) $"
        }
        
        //計算有無加料以及金額，主要用在每個飲料的說明中
        
            var bubbleToInfo : String{
             
                if indexPathForRowItem.whiteBubble == true {
                    return " 白玉"
                }
                return ""
            }
        var jellyToInfo : String{
         
            if indexPathForRowItem.whiteJelly == true {
                return " 水玉"
            }
            return ""
        }
        
        var almondToInfo : String{
         
            if indexPathForRowItem.sweetAlmond == true {
                return " 甜杏"
            }
            return ""
        }
     
        cell.drinkAdjust.text = "\(indexPathForRowItem.size)杯 \(indexPathForRowItem.sugar) \(indexPathForRowItem.ice)\(bubbleToInfo)\(jellyToInfo)\(almondToInfo)"
  
        return cell
    }
    
    // 滑動刪除tableViewCell, 必須注意串接後台刪除的順序位置必須在 shopCartListArray 之前， 不然順序會錯亂。
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
         {
            
             let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { [self] (action, sourceView, complete) in
                 deleteID = shopCartListArray[indexPath.row].id

                 deleteDrinkTask()
                 print(indexPath.row,shopCartListArray[indexPath.row].id,deleteID) // 檢查用

             shopCartListArray.remove(at: indexPath.row) // 刪除矩陣中 cell 位置內容
             shopCartTableView.deleteRows(at: [indexPath], with: .top)
                 totalSet() //重新計算全部金額
             complete(true)
                 
             }
             deleteAction.image = UIImage(systemName: "trash")
             let trailingSwipConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
             return trailingSwipConfiguration
         }
    
    // 按下cell 後切換到修改畫面，並將當格cell資料傳至修改頁面，故在修改頁面沒有進行後台的下載串接
    // 直接使用 pushViewController 來進行頁面的切換，沒有在ＳＢ另外拉 segue ，需要在ＳＢ中設定 storyboardID。
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        if let controller = storyboard?.instantiateViewController(withIdentifier: "reviseSB") as? ReviseViewController {
//            navigationController?.pushViewController(controller, animated: true)
//            controller.reviseDrink = shopCartListArray[indexPath.row]
//        }
    }
    
}
