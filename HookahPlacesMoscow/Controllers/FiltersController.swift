//
//  FiltersController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 05/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class FiltersController: UITableViewController {
    
    var searchController: SearchPlacesController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavigationController()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! FilterCell
        switch indexPath.row {
        case 0:
            cell.nameFilterLabel.text = "Перезабивка"
            if searchController.restarting! {
                cell.checkImageView.image = UIImage(named: "checked")
            }
            else {
                cell.checkImageView.image = UIImage(named: "unchecked")
            }
        case 1:
            cell.nameFilterLabel.text = "Свои напитки"
            if searchController.theirDrink! {
                cell.checkImageView.image = UIImage(named: "checked")
            }
            else {
                cell.checkImageView.image = UIImage(named: "unchecked")
            }
        case 2:
            cell.nameFilterLabel.text = "Своя еда"
            if searchController.theirFoot! {
                cell.checkImageView.image = UIImage(named: "checked")
            }
            else {
                cell.checkImageView.image = UIImage(named: "unchecked")
            }
        case 3:
            cell.nameFilterLabel.text = "Свой алкоголь"
            if searchController.theirAlko! {
                cell.checkImageView.image = UIImage(named: "checked")
            }
            else {
                cell.checkImageView.image = UIImage(named: "unchecked")
            }
        case 4:
            cell.nameFilterLabel.text = "Настольные игры"
            if searchController.tableGames! {
                cell.checkImageView.image = UIImage(named: "checked")
            }
            else {
                cell.checkImageView.image = UIImage(named: "unchecked")
            }
        case 5:
            cell.nameFilterLabel.text = "Приставка"
            if searchController.gameConsole! {
                cell.checkImageView.image = UIImage(named: "checked")
            }
            else {
                cell.checkImageView.image = UIImage(named: "unchecked")
            }
        case 6:
            cell.nameFilterLabel.text = "Wi-Fi"
            if searchController.wifi! {
                cell.checkImageView.image = UIImage(named: "checked")
            }
            else {
                cell.checkImageView.image = UIImage(named: "unchecked")
            }
        case 7:
            cell.nameFilterLabel.text = "Банковская карта"
            if searchController.bankCard! {
                cell.checkImageView.image = UIImage(named: "checked")
            }
            else {
                cell.checkImageView.image = UIImage(named: "unchecked")
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FilterCell
        if cell.checkImageView.image == UIImage(named: "unchecked") {
            cell.checkImageView.image = UIImage(named: "checked")
        }
        else {
            cell.checkImageView.image = UIImage(named: "unchecked")
        }
    }
    
    func initNavigationController() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: view.bounds.width, height: 44))
        navigationBar.backgroundColor = UIColor.white
        let navigationItem = UINavigationItem()
        navigationItem.title = "Фильтры"
        let leftButton = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: nil, action: #selector(FiltersController.closeWindowBarButtonPressed))
        leftButton.tintColor = UIColor.black
        let rightButton = UIBarButtonItem(image: UIImage(named: "login"), style: .done, target: nil, action: #selector(FiltersController.addFiltersBarButtonPressed))
        rightButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        navigationBar.items = [navigationItem]
        self.tableView.addSubview(navigationBar)
    }
    
    @objc func closeWindowBarButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addFiltersBarButtonPressed() {
        if self.searchController.filters.count > 0 {
            self.searchController.filters.removeAll()
        }
        var cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FilterCell
        if cell.checkImageView.image == UIImage(named: "checked") {
            self.searchController.filters.append(NSPredicate(format: "restarting = true"))
            self.searchController.restarting = true
        }
        else {
            self.searchController.restarting = false
        }
        cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! FilterCell
        if cell.checkImageView.image == UIImage(named: "checked") {
            self.searchController.filters.append(NSPredicate(format: "theirDrink = true"))
            self.searchController.theirDrink = true
        }
        else {
            self.searchController.theirDrink = false
        }
        cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! FilterCell
        if cell.checkImageView.image == UIImage(named: "checked") {
            self.searchController.filters.append(NSPredicate(format: "theirFoot = true"))
            self.searchController.theirFoot = true
        }
        else {
            self.searchController.theirFoot = false
        }
        cell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! FilterCell
        if cell.checkImageView.image == UIImage(named: "checked") {
            self.searchController.filters.append(NSPredicate(format: "theirAlko = true"))
            self.searchController.theirAlko = true
        }
        else {
            self.searchController.theirAlko = false
        }
        cell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! FilterCell
        if cell.checkImageView.image == UIImage(named: "checked") {
            self.searchController.filters.append(NSPredicate(format: "tableGames = true"))
            self.searchController.tableGames = true
        }
        else {
            self.searchController.tableGames = false
        }
        cell = self.tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as! FilterCell
        if cell.checkImageView.image == UIImage(named: "checked") {
            self.searchController.filters.append(NSPredicate(format: "gameConsole = true"))
            self.searchController.gameConsole = true
        }
        else {
            self.searchController.gameConsole = false
        }
        cell = self.tableView.cellForRow(at: IndexPath(row: 6, section: 0)) as! FilterCell
        if cell.checkImageView.image == UIImage(named: "checked") {
            self.searchController.filters.append(NSPredicate(format: "wifi = true"))
            self.searchController.wifi = true
        }
        else {
            self.searchController.wifi = false
        }
        cell = self.tableView.cellForRow(at: IndexPath(row: 7, section: 0)) as! FilterCell
        if cell.checkImageView.image == UIImage(named: "checked") {
            self.searchController.filters.append(NSPredicate(format: "bankCard = true"))
            self.searchController.bankCard = true
        }
        else {
            self.searchController.bankCard = false
        }
        self.searchController.getPlaces(text: self.searchController.searchBar.text)
        self.searchController.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
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
