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
    
    @IBOutlet weak var imageProfileButton: UIButton! {
        didSet {
            self.imageProfileButton.setTitleColor(UIColor.black, for: .normal)
            self.imageProfileButton.layer.cornerRadius = 60
            self.imageProfileButton.layer.borderWidth = 5
            self.imageProfileButton.layer.borderColor = UIColor.black.cgColor
            self.imageProfileButton.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storageRef = Storage.storage().reference()
        self.databaseRef = Database.database().reference()
        self.initConfigBackBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard Auth.auth().currentUser != nil else {
            self.imageProfileButton.setTitle("ВОЙТИ", for: .normal)
            return
        }
        self.imageProfileButton.setTitle(nil, for: .normal)
        let urlImageUser = storageRef.child("users/\((Auth.auth().currentUser?.uid)!).png")
        urlImageUser.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if error == nil {
                self.imageProfileButton.setBackgroundImage(UIImage(data: data!), for: .normal)
            }
            else {
                self.imageProfileButton.setBackgroundImage(UIImage(named: "noImageUser"), for: .normal)
            }
        }
        databaseRef.child("users/\((Auth.auth().currentUser?.uid)!)").observeSingleEvent(of: .value, with: { (snapshot) in
            let user = snapshot.value as? NSDictionary
            let name = user?["name"] as? String ?? ""
            let countPlaces = user?["countPlace"] as? Int ?? 0
            let countReviews = user?["countReviews"] as? Int ?? 0
            self.initDataUser(name: name, email: (Auth.auth().currentUser?.email)!, countPlaces: countPlaces, countReviews: countReviews)
            self.view.addSubview(self.nameLabel)
            self.view.addSubview(self.emailLabel)
            self.view.addSubview(self.countPlacesLabel)
            self.view.addSubview(self.countReviewsLabel)
            self.view.addSubview(self.countPlacesTextLabel)
            self.view.addSubview(self.countReviewsTextLabel)
        }) { (error) in
            self.defaultAlertController(title: "Ошибка", message: error.localizedDescription, actionTitle: "OK", handler: nil)
        }
    }
    
    @IBAction func imageProfileButtonPressed(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LogInController
        self.present(controller!, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initDataUser(name: String, email: String, countPlaces: Int, countReviews: Int) {
        self.nameLabel = UILabel(frame: CGRect(x: 0, y: 250, width: self.view.bounds.width, height: 30))
        self.nameLabel.textColor = UIColor.black
        self.nameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 21)
        self.nameLabel.text = name.uppercased()
        self.nameLabel.textAlignment = .center
        
        self.emailLabel = UILabel(frame: CGRect(x: 0, y: 275, width: self.view.bounds.width, height: 30))
        self.emailLabel.textColor = UIColor.lightGray
        self.emailLabel.font = UIFont(name: "AppleSDGothicNeo", size: 18)
        self.emailLabel.text = email
        self.emailLabel.textAlignment = .center
        
        self.countPlacesLabel = UILabel(frame: CGRect(x: 50, y: 340, width: self.view.bounds.width / 2 - 50, height: 20))
        self.countPlacesLabel.textColor = UIColor.black
        self.countPlacesLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        self.countPlacesLabel.text = "\(countPlaces)\n"
        self.countPlacesLabel.textAlignment = .center
        
        self.countReviewsLabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2, y: 340, width: self.view.bounds.width / 2 - 50, height: 20))
        self.countReviewsLabel.textColor = UIColor.black
        self.countReviewsLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        self.countReviewsLabel.text = "\(countReviews)"
        self.countReviewsLabel.textAlignment = .center
        
        self.countPlacesTextLabel = UILabel(frame: CGRect(x: 50, y: 355, width: self.view.bounds.width / 2 - 50, height: 20))
        self.countPlacesTextLabel.textColor = UIColor.lightGray
        self.countPlacesTextLabel.font = UIFont(name: "AppleSDGothicNeo", size: 12)
        self.countPlacesTextLabel.text = "места"
        self.countPlacesTextLabel.textAlignment = .center
        
        self.countReviewsTextLabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2, y: 355, width: self.view.bounds.width / 2 - 50, height: 20))
        self.countReviewsTextLabel.textColor = UIColor.lightGray
        self.countReviewsTextLabel.font = UIFont(name: "AppleSDGothicNeo", size: 12)
        self.countReviewsTextLabel.text = "отзывы"
        self.countReviewsTextLabel.textAlignment = .center
    }

}
