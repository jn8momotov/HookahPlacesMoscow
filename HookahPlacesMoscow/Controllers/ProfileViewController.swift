//
//  ProfileViewController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 03/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProfileViewController: UIViewController {

    var storageRef: StorageReference!
    var databaseRef: DatabaseReference!
    
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var countPlacesLabel: UILabel!
    var countReviewsLabel: UILabel!
    var countPlacesTextLabel: UILabel!
    var countReviewsTextLabel: UILabel!
    var loginButton: UIButton!
    
    @IBOutlet weak var imageUserView: UIImageView! {
        didSet {
            imageUserView.contentMode = .scaleAspectFill
            imageUserView.layer.cornerRadius = 55
            imageUserView.layer.borderColor = UIColor.black.cgColor
            imageUserView.layer.borderWidth = 4
            imageUserView.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storageRef = Storage.storage().reference()
        self.databaseRef = Database.database().reference()
        self.initConfigBackBarButton()
        if Auth.auth().currentUser == nil {
            imageUserView.image = UIImage(named: "noImageUser")
            initLoginButton()
        }
        else {
            initDataUser()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initLoginButton() {
        loginButton = UIButton(frame: CGRect(x: 16, y: 240, width: self.view.bounds.width - 32, height: 50))
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.textColor = UIColor.white
        loginButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 19)
        loginButton.backgroundColor = UIColor.black
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(showLoginController), for: .touchUpInside)
        self.view.addSubview(loginButton)
    }
    
    func initDataUser() {
        let urlImageUser = storageRef.child("users/\((Auth.auth().currentUser?.uid)!).png")
        urlImageUser.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if error == nil {
                self.imageUserView.image = UIImage(data: data!)
            }
            else {
                self.imageUserView.image = UIImage(named: "noImageUser")
            }
        }
        databaseRef.child("users/\((Auth.auth().currentUser?.uid)!)").observeSingleEvent(of: .value, with: { (snapshot) in
            let user = snapshot.value as? NSDictionary
            let name = user?["name"] as? String ?? ""
            let countPlaces = user?["countPlace"] as? Int ?? 0
            let countReviews = user?["countReviews"] as? Int ?? 0
            self.nameLabel.text = name.uppercased()
            self.emailLabel.text = (Auth.auth().currentUser?.email)!
            self.countPlacesLabel.text = "\(countPlaces)"
            self.countReviewsLabel.text = "\(countReviews)"
            self.view.addSubview(self.nameLabel)
            self.view.addSubview(self.emailLabel)
            self.view.addSubview(self.countPlacesLabel)
            self.view.addSubview(self.countReviewsLabel)
            self.view.addSubview(self.countPlacesTextLabel)
            self.view.addSubview(self.countReviewsTextLabel)
        }) { (error) in
            self.defaultAlertController(title: "Ошибка", message: error.localizedDescription, actionTitle: "OK", handler: nil)
        }
        self.nameLabel = UILabel(frame: CGRect(x: 0, y: 250, width: self.view.bounds.width, height: 30))
        self.nameLabel.textColor = UIColor.black
        self.nameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 21)
        self.nameLabel.textAlignment = .center
        
        self.emailLabel = UILabel(frame: CGRect(x: 0, y: 275, width: self.view.bounds.width, height: 30))
        self.emailLabel.textColor = UIColor.lightGray
        self.emailLabel.font = UIFont(name: "AppleSDGothicNeo", size: 18)
        self.emailLabel.textAlignment = .center
        
        self.countPlacesLabel = UILabel(frame: CGRect(x: 50, y: 340, width: self.view.bounds.width / 2 - 50, height: 20))
        self.countPlacesLabel.textColor = UIColor.black
        self.countPlacesLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        self.countPlacesLabel.textAlignment = .center
        
        self.countReviewsLabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2, y: 340, width: self.view.bounds.width / 2 - 50, height: 20))
        self.countReviewsLabel.textColor = UIColor.black
        self.countReviewsLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        self.countReviewsLabel.textAlignment = .center
        
        self.countPlacesTextLabel = UILabel(frame: CGRect(x: 50, y: 355, width: self.view.bounds.width / 2 - 50, height: 20))
        self.countPlacesTextLabel.textColor = UIColor.lightGray
        self.countPlacesTextLabel.font = UIFont(name: "AppleSDGothicNeo", size: 12)
        self.countPlacesTextLabel.text = "места"
        self.countPlacesTextLabel.textAlignment = .center
        
        self.countReviewsTextLabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2, y: 355, width: self.view.bounds.width / 2 - 50, height: 20))
        self.countReviewsTextLabel.textColor = UIColor.lightGray
        self.countReviewsTextLabel.font = UIFont(name: "AppleSDGothicNeo", size: 12)
        self.countReviewsTextLabel.text = "оценки"
        self.countReviewsTextLabel.textAlignment = .center
    }
    
    @objc func showLoginController() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LogInController
        controller?.profileViewController = self
        self.present(controller!, animated: true, completion: nil)
    }

}
