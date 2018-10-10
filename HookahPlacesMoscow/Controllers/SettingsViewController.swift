//
//  SettingsViewController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 03/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if Auth.auth().currentUser != nil {
            return 3
        }
        else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        let user = Auth.auth().currentUser
        switch indexPath.section {
        case 0:
            if user != nil {
                cell.textLabel?.text = "Учетная запись"
                cell.imageView?.image = UIImage(named: "profile")
                cell.accessoryType = .disclosureIndicator
            }
            else {
                cell.textLabel?.text = "Войти"
                cell.textLabel?.textAlignment = .center
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Написать разработчику"
                cell.imageView?.image = UIImage(named: "pencil")
                cell.accessoryType = .disclosureIndicator
            case 1:
                cell.textLabel?.text = "О приложении"
                cell.imageView?.image = UIImage(named: "info")
                cell.accessoryType = .disclosureIndicator
            default:
                return UITableViewCell()
            }
        case 2:
            cell.textLabel?.text = "Выйти"
            cell.textLabel?.textColor = UIColor.red
            cell.textLabel?.textAlignment = .center
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            return
        case 2:
            let alertController = UIAlertController(title: "Выйти?", message: nil, preferredStyle: .actionSheet)
            let exitAction = UIAlertAction(title: "Выход", style:  .destructive) { (exitAction) in
                self.signOutUser()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initial = storyboard.instantiateInitialViewController()
                UIApplication.shared.keyWindow?.rootViewController = initial
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertController.addAction(exitAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        default:
            return
        }
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
