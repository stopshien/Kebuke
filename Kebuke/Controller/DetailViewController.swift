//
//  DetailViewController.swift
//  Kebuke
//
//  Created by 沈庭鋒 on 2023/4/22.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    var allDrinks = [DrinksInfo]()
    var allDrinksToRevise = [DrinksInfo]()

    var sugarChoose = ""
    var iceChoose = ""
    var sizeChoose = ""
    var price = 0 //單杯金額會總計在這裡，包含大小杯與加料的價格，並在按下加入購物車的按鈕時加進 addShopCart之中
    
// UIswitch 的變數
    var whiteBubbleState = false
    var whiteJellyState = false
    var sweetAlmondState = false
    var addSwitchTotalMoney = 0

    
    
    var orderBody = OrderResponse(records: [])
    
    var uploardField = OrderBody(fields: OrderData(name: "", sugar: "", ice: "", size: "", price: 0, image: URL(string: ""), human: "", whiteBubble: false, whiteJelly: false, sweetAlmond: false))
    
    var addShopCart = OrderData(name: "", sugar: "全糖", ice: "正常冰", size: "中", price: 0, image: URL(string: ""), human: "", whiteBubble: false, whiteJelly: false, sweetAlmond: false)
    
    var indexPathRowNum = 0
    
    // 修改訂單用，因為 patch 一定要使用到 id，因為之前都沒用到過，所以直接用新的model 來傳遞資料。
    var reviseResponse = OrderResponseForCart(records: [OrderBodyForCart]())
    var reviseDrink = OrderBodyForCart(id: "", fields: OrderData(name: "", sugar: "", ice: "", size: "", price: 0, image: URL(string: ""), human: "", whiteBubble: false, whiteJelly: false, sweetAlmond: false))
  

    
    @IBOutlet weak var detailImageView: UIImageView!
    
    @IBOutlet weak var detailInfo: UILabel!
    
    @IBOutlet weak var orderHumanName: UILabel!
    
    @IBOutlet weak var orderHumanTextField: UITextField!
    
    @IBOutlet weak var sugarButtonOutlet: UIButton!
    
    @IBOutlet weak var iceButtonOutlet: UIButton!
    
    @IBOutlet weak var sizeButtonOutlet: UIButton!
    
    @IBOutlet weak var drinkTitleName: UILabel!
    
    @IBOutlet weak var addWhiteBubble: UISwitch!
    
    @IBOutlet weak var addWaterJelly: UISwitch!
    
    @IBOutlet weak var addSweetAlmond: UISwitch!
    
    @IBOutlet weak var totalMoney: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        uploardField.id = allDrinks[indexPathRowNum].id
        if allDrinks.isEmpty{
            fetchGetData()
            drinkTitleName.text = addShopCart.name
            orderHumanTextField.text = addShopCart.human
            addUISwitchReivseSet()

        }else{
            price = Int(allDrinks[indexPathRowNum].fields.midPrice) ?? 0
            setImage()
            sugarButtonSet()
            iceButtonSet()
            sizeButtonSet()
            drinkTitleName.text = allDrinks[indexPathRowNum].fields.name
            totalMoney.text = "共 NT 0 $"
        }
    }

    func addUISwitchReivseSet(){
        if reviseDrink.fields.whiteBubble == true{
            addWhiteBubble.isOn = true
        }
        if reviseDrink.fields.whiteJelly == true{
            addWaterJelly.isOn = true}
        
        if reviseDrink.fields.sweetAlmond == true{
            addSweetAlmond.isOn = true
        }
    }
    
    func searchDrinkInDrinkInfo(){

        // 設定搜尋的起點，直接使用外部變數 indexPathRowNum
        // 使用 while 迴圈進行搜尋此種飲料名稱對應到的全部飲料矩陣內的順序，因為要使用到建立的許多矩陣所以才需要做這個動作。
        while indexPathRowNum < allDrinksToRevise.count {
            if allDrinksToRevise[indexPathRowNum].fields.name == addShopCart.name {
                print("找到了目標數字在陣列中的位置：\(indexPathRowNum)")
                break
            }
            indexPathRowNum += 1
        }
    }
    
    // 三個加料的 UISwitch 按鈕的設定
    @IBAction func addSwitchButtons(_ sender: UISwitch) {
        switch sender.tag{
            // 有三個 Switch 故分別做不同的事
        case 1:
            if addWhiteBubble.isOn{
                whiteBubbleState = true
                price += 10
                addSwitchTotalMoney += 10
            }else{
                whiteBubbleState = false
                price -= 10
                addSwitchTotalMoney -= 10
            }
        case 2:
            
            if addWaterJelly.isOn{
                whiteJellyState = true
                price += 10
                addSwitchTotalMoney += 10
            }else{
                whiteJellyState = false
                price -= 10
                addSwitchTotalMoney -= 10

            }
        case 3:
            if addSweetAlmond.isOn{
                sweetAlmondState = true
                price += 15
                addSwitchTotalMoney += 15

            }else{
                sweetAlmondState = false
                price -= 15
                addSwitchTotalMoney -= 15

            }
        default:
            return
        }
    // 不管按下哪一個 switch 都會重新定義每種料的 bool 並傳到 addShopCart
        addSwitchState()
    }
    
    func addSwitchState(){
         addShopCart.whiteBubble = whiteBubbleState
        addShopCart.whiteJelly = whiteJellyState
        addShopCart.sweetAlmond = sweetAlmondState
        totalMoney.text = "共 NT \(price) $"
        }

    
    // 要加入判定是修改還是新增，還沒加
    @IBAction func addChooseList(_ sender: UIButton) {
        if allDrinks.isEmpty{
            reviseFetch()

            let controller = UIAlertController(title: "修改完成", message: "可繼續修改或按右上角購物車回到訂購清單", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
//                self.navigationController?.popViewController(animated: true)
            }
            controller.addAction(action)
            present(controller, animated: true)
        }else{
            // 在按下購物車的時候會先將價格更新
            addShopCart.price = price
            if let orderHumanName = orderHumanTextField.text,
               let price = addShopCart.price{
                if orderHumanName != ""{
                    addShopCart.human = orderHumanName
                    postFetch()
                    
                    //加入成功加入的alert
                    let controller = UIAlertController(title: "已加入購物車", message: "記得付$\(price)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    controller.addAction(action)
                    present(controller, animated: true)
                }
                // 出現alert請填寫訂購者稱呼
                let controller = UIAlertController(title: "請輸入訂購者", message: "不輸入就不用喝了", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                present(controller, animated: true)
            }
        }
    }
    
    
    
    // 上傳資料 POST
    func postFetch(){
        // 將選好的飲料內容儲存到預先建立好的變數中，以達到符合上傳的JSON格式的 Model。
        uploardField = OrderBody(fields: addShopCart)
        // 此為專屬 for 儲存訂購飲料的後台 table 網址，與儲存全部飲料的菜單網址不同，但專案 ID api_key 是同一個。
        let urlString = "https://api.airtable.com/v0/app8qDE2IVOV4sQFh/kebukeOrderList"
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            // apiKey認證
            request.setValue("Bearer keyTaDO1pC3Wi8kV3", forHTTPHeaderField: "Authorization")
            // httpMethod 設定
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            // 將內容加入 httpBody
            request.httpBody = try? JSONEncoder().encode(uploardField)

            //  URLSession 本身還是必須執行，為主要上傳功能。
            URLSession.shared.dataTask(with: request) { data, response, error in
//// 內容單純拿來檢查矩陣內容，與上傳並無關係
//                    if let data = data,
//                           let content = String(data: data, encoding: .utf8) {
//                            print(content)
//                        }
            }.resume()
            
        }
        }
    //下載 data
    func fetchGetData(){
        
        let kebukeURLString = "https://api.airtable.com/v0/app8qDE2IVOV4sQFh/kebuke?sort[][field]=midPrice&sort[][direction]=asc".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if let url = URL(string: kebukeURLString){
            var request = URLRequest(url: url)
            request.setValue("Bearer keyTaDO1pC3Wi8kV3", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data,let content = String(data: data, encoding: .utf8){
                    do {
                        let result = try JSONDecoder().decode(Records.self, from: data)
                        self.allDrinksToRevise = result.records
                        DispatchQueue.main.async {
                            self.searchDrinkInDrinkInfo()
                            self.sugarButtonSet()
                            self.iceButtonSet()
                            self.sizeButtonSet()
                            self.setImage()
                            self.price = self.reviseDrink.fields.price ?? 0 // 顯示一開始傳遞過來的資料中的 price
                            self.totalMoney.text = "共 NT \(self.price) $"

                        }
                        print(content)
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    // 修改用 " PATCH " 將所有資料傳進相對應的模型中
    func reviseFetch(){
        //上傳修改前加入價格以及訂購者名稱
        addShopCart.price = price
        addShopCart.human = orderHumanTextField.text ?? reviseDrink.fields.human
        reviseDrink.fields = addShopCart
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
    
    
    // 設定甜度的 button
    func sugarButtonSet(){
        
        var rowNum = [String]()

        if allDrinks.isEmpty{
            rowNum = allDrinksToRevise[indexPathRowNum].fields.sugar
        }else{
            rowNum = allDrinks[indexPathRowNum].fields.sugar
        }
        
        sugarButtonOutlet.menu = UIMenu(children: [
            
                    UIAction(title: rowNum[0], handler: { [self] action in
                        self.sugarChoose = rowNum[0]
                        self.addShopCart.sugar = rowNum[0]
                        self.sugarButtonOutlet.setTitle(self.sugarChoose, for: .normal)
                    }),
                    UIAction(title: rowNum[1], handler: { [self]  action in
                        self.sugarChoose = rowNum[1]
                        self.addShopCart.sugar = rowNum[1]
                        self.sugarButtonOutlet.setTitle(self.sugarChoose, for: .normal)
                    }),
                    UIAction(title: rowNum[2], handler: { [self] action in
                        self.sugarChoose = rowNum[2]
                        self.addShopCart.sugar = rowNum[2]
                        self.sugarButtonOutlet.setTitle(self.sugarChoose, for: .normal)
                    }),
                    UIAction(title: rowNum[3], handler: { [self] action in
                        self.sugarChoose = rowNum[3]
                        self.addShopCart.sugar = rowNum[3]
                        self.sugarButtonOutlet.setTitle(self.sugarChoose, for: .normal)
                    }),
                    UIAction(title: rowNum[4], handler: { [self] action in
                        self.sugarChoose = rowNum[4]
                        self.addShopCart.sugar = rowNum[4]
                        self.sugarButtonOutlet.setTitle(self.sugarChoose, for: .normal)
                    })
                ])
    }
    
    
    func iceButtonSet(){
        var rowNum = [String]()

        if allDrinks.isEmpty{
            rowNum = allDrinksToRevise[indexPathRowNum].fields.ice
        }else{
            rowNum = allDrinks[indexPathRowNum].fields.ice
        }
        iceButtonOutlet.menu = UIMenu(children: [
            
                    UIAction(title: rowNum[0], handler: { [self] action in
                        self.iceChoose = rowNum[0]
                        self.addShopCart.ice = rowNum[0]
                        self.iceButtonOutlet.setTitle(self.iceChoose, for: .normal)
                    }),
                    UIAction(title: rowNum[1], handler: { [self] action in
                        self.iceChoose = rowNum[1]
                        self.addShopCart.ice = rowNum[1]
                        self.iceButtonOutlet.setTitle(self.iceChoose, for: .normal)
                    }),
                    UIAction(title: rowNum[2], handler: {[self]  action in
                        self.iceChoose = rowNum[2]
                        self.addShopCart.ice = rowNum[2]
                        self.iceButtonOutlet.setTitle(self.iceChoose, for: .normal)
                    }),
                    UIAction(title: rowNum[3], handler: { [self] action in
                        self.iceChoose = rowNum[3]
                        self.addShopCart.ice = rowNum[3]
                        self.iceButtonOutlet.setTitle(self.iceChoose, for: .normal)
                    })
                ])
    }
    
    func sizeButtonSet(){
        var rowNum = [String]()
        var rowNumMidPrice = ""
        var rowNumLargePrice = ""
        
        if allDrinks.isEmpty{
             rowNum = allDrinksToRevise[indexPathRowNum].fields.size
             rowNumMidPrice = allDrinksToRevise[indexPathRowNum].fields.midPrice
            rowNumLargePrice = allDrinksToRevise[indexPathRowNum].fields.largePrice!
        }else{
             rowNum = allDrinks[indexPathRowNum].fields.size
             rowNumMidPrice = allDrinks[indexPathRowNum].fields.midPrice
            rowNumLargePrice = allDrinks[indexPathRowNum].fields.largePrice!
        }
        addShopCart.price = Int(rowNumMidPrice)
        if rowNum.count == 2{
            sizeButtonOutlet.menu = UIMenu(children: [
                
                UIAction(title: "\(rowNum[0]): $\(rowNumMidPrice)", handler: { [self] action in
                    self.sizeChoose = rowNum[0]
                    self.price = Int(rowNumMidPrice)! + self.addSwitchTotalMoney
                    self.sizeButtonOutlet.setTitle("\(self.sizeChoose):\(Int(rowNumMidPrice)!)", for: .normal)
                    self.addShopCart.size = self.sizeChoose
//                    self.addShopCart.price = self.price + self.addSwitchTotalMoney
                    self.totalMoney.text = "共 NT \(self.price) $"

                }),
                UIAction(title: "\(rowNum[1] ): $\(rowNumLargePrice )", handler: { [self] action in
                    self.sizeChoose = rowNum[1]
                    self.price = Int(rowNumLargePrice)! + self.addSwitchTotalMoney
                    self.sizeButtonOutlet.setTitle("\(self.sizeChoose):\(Int(rowNumLargePrice)!)", for: .normal)
                    self.addShopCart.size = self.sizeChoose
//                    self.addShopCart.price = self.price + self.addSwitchTotalMoney
                    self.totalMoney.text = "共 NT \(self.price) $"
                })
            ])
        }else{
            sizeButtonOutlet.menu = UIMenu(children: [
                UIAction(title: "\(rowNum[0]): $\(rowNumMidPrice)", handler: { [self] action in
                    self.sizeChoose = rowNum[0]
                    self.price = Int(rowNumMidPrice)! + self.addSwitchTotalMoney
                    self.sizeButtonOutlet.setTitle("\(self.sizeChoose):\(Int(rowNumMidPrice)!)", for: .normal)
                    self.addShopCart.size = self.sizeChoose
//                    self.addShopCart.price = self.price + self.addSwitchTotalMoney
                    self.totalMoney.text = "共 NT \(self.price) $"
                })
            ])
        }
            
    }
    
    
    func setImage(){
        
        if allDrinks.isEmpty{
            
            let rowNum = allDrinksToRevise[indexPathRowNum].fields
            detailImageView.kf.setImage(with: rowNum.image[0].url)
            
            detailInfo.text = rowNum.detail
            
            addShopCart.image = allDrinksToRevise[indexPathRowNum].fields.image[0].url

            addShopCart.name = allDrinksToRevise[indexPathRowNum].fields.name
        }else{
            
            let rowNum = allDrinks[indexPathRowNum].fields
            detailImageView.kf.setImage(with: rowNum.image[0].url)
            
            detailInfo.text = rowNum.detail
            
            addShopCart.image = allDrinks[indexPathRowNum].fields.image[0].url

            addShopCart.name = allDrinks[indexPathRowNum].fields.name
        }
  
    }
    
    }


// 修正在按下ＣＥＬＬ後 UISWITCH 並不會隨者原有內容作變動，會造成資料不正確。
