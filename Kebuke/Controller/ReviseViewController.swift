//
//  ReviseViewController.swift
//  Kebuke
//
//  Created by 沈庭鋒 on 2023/4/26.
//

import UIKit
import Kingfisher

class ReviseViewController: UIViewController {
    
    var reviseResponse = OrderResponseForCart(records: [OrderBodyForCart]())
    var reviseDrink = OrderBodyForCart(id: "", fields: OrderData(name: "", sugar: "", ice: "", size: "", price: 0, image: URL(string: ""), human: "", whiteBubble: false, whiteJelly: false, sweetAlmond: false))

    @IBOutlet weak var drinkImageView: UIImageView!
    
    @IBOutlet weak var reviseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviseTableView.delegate = self
        reviseTableView.dataSource = self
        print(reviseDrink)
//        fetchData()
        drinkImageView.kf.setImage(with: reviseDrink.fields.image) 
    }
    
    @IBAction func reviseButton(_ sender: Any) {
        
        reviseFetch()

        let controller = UIAlertController(title: "修改完成", message: "再次修改或按back鍵往回", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        controller.addAction(action)
        present(controller, animated: true)
    }

        
    func reviseFetch(){
        reviseResponse = OrderResponseForCart(records: [reviseDrink])
        let airtableURL = "https://api.airtable.com/v0/app8qDE2IVOV4sQFh/kebukeOrderList"
        if let url = URL(string: airtableURL){
            var request = URLRequest(url: url)
            request.setValue("Bearer keyTaDO1pC3Wi8kV3", forHTTPHeaderField: "Authorization")
            // httpMethod 設定
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PATCH"
            request.httpBody = try? JSONEncoder().encode(reviseResponse)
            print(request)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data,let content = String(data: data, encoding: .utf8){
                    
                    print(content)
                }
            }.resume()
            }
        }
    
    
    
    @IBAction func sugarSegment(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
                    case 0:
                        reviseDrink.fields.sugar = "全糖"
                    case 1:
                        reviseDrink.fields.sugar = "少糖"
                    case 2:
                        reviseDrink.fields.sugar = "半糖"
                    case 3:
                        reviseDrink.fields.sugar = "微糖"
                    case 4:
                        reviseDrink.fields.sugar = "無糖"
                    default:
                        return
        }
        print(reviseDrink.fields.sugar)
    }
    
    @IBAction func iceSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
                    case 0:
                        reviseDrink.fields.ice = "正常冰"
                    case 1:
                        reviseDrink.fields.ice = "少冰"
                    case 2:
                        reviseDrink.fields.ice = "微冰"
                    case 3:
                        reviseDrink.fields.ice = "去冰"
                    default:
                        return
        }
        print(reviseDrink.fields.ice)
    }
    
    
    @IBAction func sizeSegmaent(_ sender: UISegmentedControl) {
        
        if reviseDrink.fields.name == "熟成檸果"{
//            sender.numberOfSegments =
        }else{
            if sender.selectedSegmentIndex == 0{
                reviseDrink.fields.size = "中"
            }else{
                reviseDrink.fields.size = "大"
            }
        }
    }
    
//
//    func fetchData(){
//        let orderURLString = "https://api.airtable.com/v0/app8qDE2IVOV4sQFh/kebukeOrderList"
//        if let URL = URL(string: orderURLString){
//            var request = URLRequest(url: URL)
//            request.setValue("Bearer keyTaDO1pC3Wi8kV3", forHTTPHeaderField: "Authorization")
//            URLSession.shared.dataTask(with: request) { [self] data, response, error in
//                if let data = data{
//                    do {
//                        let result = try JSONDecoder().decode(OrderResponseForCart.self, from: data)
//                        drinksArray = result.records
//                        DispatchQueue.main.async {
//                            self.reviseTableView.reloadData()
//                        }
//                    } catch  {
//                        print(error)
//                    }
//                }
//            }.resume()
//        }
//    }
    
//    @objc func sugarChange(){
//        switch number{
//        case 0:
//            reviseDrink.fields.sugar = "全糖"
//        case 1:
//            reviseDrink.fields.sugar = "少糖"
//        case 2:
//            reviseDrink.fields.sugar = "半糖"
//        case 3:
//            reviseDrink.fields.sugar = "微糖"
//        case 4:
//            reviseDrink.fields.sugar = "無糖"
//        default:
//            return
//        }
//        print(reviseDrink.fields.sugar)
//    }
    
    
    @IBAction func circleButton(_ sender: UIButton) {
        
            
            }
    
    

}

extension ReviseViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section < 3{
            return 1
        }else{
            return 3
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var id = ""
        switch indexPath.section{
            
        case 0:
            id = "sugarCell"
            let cell = reviseTableView.dequeueReusableCell(withIdentifier: "\(id)") as! ReviceTableViewCell
           
            return cell
        case 1:
            id = "iceCell"
            let cell = reviseTableView.dequeueReusableCell(withIdentifier: "\(id)") as! ReviceTableViewCell
            return cell
        case 2:
            id = "sizeCell"
            let cell = reviseTableView.dequeueReusableCell(withIdentifier: "\(id)") as! ReviceTableViewCell
            return cell
            
        default:
            id = "ReviceTableViewCell"
            let cell = reviseTableView.dequeueReusableCell(withIdentifier: "\(id)") as! ReviceTableViewCell
            if indexPath.row == 0{
                cell.addLabel.text = "加白玉"
                cell.addMoneyLabel.text = "+10"
            
            }
            if indexPath.row == 1{
                cell.addLabel.text = "加水玉"
                cell.addMoneyLabel.text = "+10"
            }
            if indexPath.row == 2{
                cell.addLabel.text = "加甜杏"
                cell.addMoneyLabel.text = "+15"
            }
            return cell
        }
        

    }
 
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "甜度"
        case 1:
            return "冰度"
        case 2:
            return "容量"
        default:
            return "配料"
        }
    }
}

// 目前完成可改甜度冰塊，按下button 會回到上一頁並更新資訊，但有時候會沒有更新，需重新切換頁面外會耕新畫面，要判斷容量加料需要將原本資訊匯入，有點複雜先擺著試試看其他方法。
