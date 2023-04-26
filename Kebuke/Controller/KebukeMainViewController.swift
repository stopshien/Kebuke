//
//  KebukeMainViewController.swift
//  Kebuke
//
//  Created by 沈庭鋒 on 2023/4/21.
//

import UIKit
import Kingfisher

class KebukeMainViewController: UIViewController {

    @IBOutlet weak var kebukeTableView: UITableView!
    

    
    
    var kebukeMenu = [DrinksInfo]()
    var indexPathRowNum = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        kebukeTableView.delegate = self
        kebukeTableView.dataSource = self
        fetchGetData()
        title = "MENU"
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
            if let detailVC = segue.destination as? DetailViewController{
              
                detailVC.allDrinks = kebukeMenu
                detailVC.indexPathRowNum = kebukeTableView.indexPathForSelectedRow?.row ?? 0
            }


    }
    

    func fetchGetData(){
        
        let kebukeURLString = "https://api.airtable.com/v0/app8qDE2IVOV4sQFh/kebuke?sort[][field]=midPrice&sort[][direction]=asc".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if let url = URL(string: kebukeURLString){
            var request = URLRequest(url: url)
            request.setValue("Bearer keyTaDO1pC3Wi8kV3", forHTTPHeaderField: "Authorization")
//            print(request)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data,
                   let content = String(data: data, encoding: .utf8){
                    do {
                        let result = try JSONDecoder().decode(Records.self, from: data)
                        self.kebukeMenu = result.records
                        DispatchQueue.main.async {
                            self.kebukeTableView.reloadData()
                        }
//                        print(content)
                    } catch  {
                        print(error)

                    }
                }
                
            }.resume()
        }
    }
}

extension KebukeMainViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kebukeMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(KebukeTableViewCell.self)", for: indexPath) as! KebukeTableViewCell
        
        let rowNum = kebukeMenu[indexPath.row].fields
        indexPathRowNum = indexPath.row
        
        cell.drinkNameLabel.text = rowNum.name
        cell.drinkInfoLabel.text = rowNum.info
        if rowNum.size.count == 2{
            cell.drinkSizeNPriceLabel.text = "\(rowNum.size[0]):\(rowNum.midPrice) / \(rowNum.size[1] ):\(rowNum.largePrice ?? "")"
        }else{
            cell.drinkSizeNPriceLabel.text = "\(String(describing: rowNum.size[0])):\(rowNum.midPrice)"
        }
        cell.drinkImageView.kf.setImage(with: rowNum.image[0].url)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
////        indexPathRowNum = tableView.indexPathForSelectedRow?.row ?? 0
//    }
    
    
}
