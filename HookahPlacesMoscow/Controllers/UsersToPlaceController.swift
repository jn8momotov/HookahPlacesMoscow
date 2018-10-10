//
//  UsersToPlaceController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 10/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class UsersToPlaceController: UITableViewController {
    
    var place: Place!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userToPlaceCell", for: indexPath) as! UserToPlaceCell

        cell.nameUserLabel.text = "Евгений"
        cell.imageUserView.image = UIImage(named: "noImageUser")

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
    
    @IBAction func sendMessageToUserButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Написать", message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor.black
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let telegramAction = UIAlertAction(title: "Telegram", style: .default) { (telegramAction) in
            
        }
        let whatsAppAction = UIAlertAction(title: "Whats App", style: .default) { (whatsAppAction) in
            
        }
        let smsAction = UIAlertAction(title: "СМС", style: .default) { (smsAction) in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(whatsAppAction)
        alertController.addAction(telegramAction)
        alertController.addAction(smsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
