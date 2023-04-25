//
//  ShopCartViewController.swift
//  Kebuke
//
//  Created by 沈庭鋒 on 2023/4/23.
//

import UIKit
import Kingfisher

class ShopCartViewController: UIViewController {

    var shopCartListArray = [OrderBody]()
    var totalMoneyCount = 0

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
    
    
    func fetchShopCartList(){
        let shopCartURL = "https://api.airtable.com/v0/app8qDE2IVOV4sQFh/kebukeOrderList"
        guard let url = URL(string: shopCartURL)  else{return}
        var request = URLRequest(url: url)
        request.setValue("Bearer keyTaDO1pC3Wi8kV3", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let content = String(data: data, encoding: .utf8){
                do {
                    let result = try JSONDecoder().decode(OrderResponse.self, from: data)
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
        if let size = indexPathForRowItem.size,
           let sugar = indexPathForRowItem.sugar,
           let ice = indexPathForRowItem.ice{
            cell.drinkAdjust.text = "\(size)杯 \(sugar) \(ice)"
        }
        
        
        return cell
    }
    
    
}
