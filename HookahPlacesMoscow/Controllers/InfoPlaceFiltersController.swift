//
//  InfoPlaceFiltersController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 11/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class InfoPlaceFiltersController: UITableViewController {
    
    var place: Place!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoFiltersPlaceCell", for: indexPath) as! InfoFilterPlaceCell
        switch indexPath.row {
        case 0:
            cell.nameFilterLabel.text = "Перезабивка"
            cell.keyFilterLabel.text = place.restarting ? "Есть" : "Нет"
        case 1:
            cell.nameFilterLabel.text = "Свои напитки"
            cell.keyFilterLabel.text = place.theirDrink ? "Можно" : "Нет"
        case 2:
            cell.nameFilterLabel.text = "Своя еда"
            cell.keyFilterLabel.text = place.theirFoot ? "Можно" : "Нет"
        case 3:
            cell.nameFilterLabel.text = "Свой алкоголь"
            cell.keyFilterLabel.text = place.theirAlko ? "Можно" : "Нет"
        case 4:
            cell.nameFilterLabel.text = "Настольные игры"
            cell.keyFilterLabel.text = place.tableGames ? "Есть" : "Нет"
        case 5:
            cell.nameFilterLabel.text = "Приставка"
            cell.keyFilterLabel.text = place.gameConsole ? "Есть" : "Нет"
        case 6:
            cell.nameFilterLabel.text = "Wi-Fi"
            cell.keyFilterLabel.text = place.wifi ? "Есть" : "Нет"
        case 7:
            cell.nameFilterLabel.text = "Банковские карты"
            cell.keyFilterLabel.text = place.bankCard ? "Принимаются" : "Нет" 
        default:
            return UITableViewCell()
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
