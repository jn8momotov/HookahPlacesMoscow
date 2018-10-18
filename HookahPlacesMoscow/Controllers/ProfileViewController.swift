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
import CoreData

class ProfileViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var currentPlace: Place?

    var storageRef: StorageReference!
    var databaseRef: DatabaseReference!
    
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var countPlacesLabel: UILabel!
    var countAssessmentsLabel: UILabel!
    var countPlacesTextLabel: UILabel!
    var countAssessmentsTextLabel: UILabel!
    var loginButton: UIButton!
    
    @IBOutlet weak var currentPlaceView: UIView! {
        didSet {
            currentPlaceView.layer.cornerRadius = 8
            currentPlaceView.layer.borderColor = UIColor.black.cgColor
            currentPlaceView.layer.borderWidth = 4
            currentPlaceView.clipsToBounds = true
        }
    }
    
    var imagePlaceView: UIImageView!
    var namePlaceLabel: UILabel!
    var metroPlaceLabel: UILabel!
    var exitFromPlaceButton: UIButton!
    var detailPlaceButton: UIButton!
    
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
        if isPlace {
            initCurrentPlaceView()
            print("IS PLACE")
        }
        else {
            initNotCurrentPlaceView()
            print("NOT IS PLACE")
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
    
    @IBAction func updateDataBarButtonPressed(_ sender: UIBarButtonItem) {
        if let user = Auth.auth().currentUser {
            databaseRef.child("users/\(user.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                let object = snapshot.value as? NSDictionary
                self.nameLabel.text = (object?["name"] as? String ?? "").uppercased()
                self.countPlacesLabel.text = "\(object?["countPlace"] as? Int ?? 0)"
                self.countAssessmentsLabel.text = "\(object?["countAssessment"] as? Int ?? 0)"
                self.emailLabel.text = (Auth.auth().currentUser?.email)!
            }) { (error) in
                self.defaultAlertController(title: "Ошибка", message: error.localizedDescription, actionTitle: "OK", handler: nil)
            }
        }
    }
    
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
    
    func initCurrentPlaceView() {
        databaseRef.child("users/\((Auth.auth().currentUser?.uid)!)/idPlace").observeSingleEvent(of: .value) { (snapshot) in
            let id = snapshot.value as? Int ?? -1
            guard id != -1 else {
                self.initNotCurrentPlaceView()
                return
            }
            
            let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id = \(id)")
            do {
                let results = try self.context.fetch(fetchRequest)
                guard results.count > 0 else {
                    return
                }
                self.currentPlace = results[0]
            } catch {
                print(error.localizedDescription)
            }
            guard self.currentPlace != nil else {
                return
            }
            self.initDataPlace()
        }
    }
    
    func initDataPlace() {
        imagePlaceView = UIImageView(frame: CGRect(x: 16, y: 16, width: 70, height: 70))
        if let image = currentPlace!.image {
            imagePlaceView.image = UIImage(data: image as Data)
        }
        imagePlaceView.layer.cornerRadius = 35
        imagePlaceView.layer.borderColor = UIColor.black.cgColor
        imagePlaceView.layer.borderWidth = 3
        imagePlaceView.clipsToBounds = true
        currentPlaceView.addSubview(imagePlaceView)
        
        namePlaceLabel = UILabel(frame: CGRect(x: 112, y: 16, width: currentPlaceView.bounds.width - 118, height: 20))
        namePlaceLabel.text = "\(currentPlace!.name!)"
        namePlaceLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        currentPlaceView.addSubview(namePlaceLabel)
        
        metroPlaceLabel = UILabel(frame: CGRect(x: 112, y: 36, width: currentPlaceView.bounds.width - 118, height: 15))
        metroPlaceLabel.text = "\(currentPlace!.metroStation!)"
        metroPlaceLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 12)
        metroPlaceLabel.textColor = UIColor.lightGray
        currentPlaceView.addSubview(metroPlaceLabel)
        
        exitFromPlaceButton = UIButton(frame: CGRect(x: 112, y: 55, width: 100, height: 30))
        exitFromPlaceButton.layer.cornerRadius = 5
        exitFromPlaceButton.clipsToBounds = true
        exitFromPlaceButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        exitFromPlaceButton.tintColor = UIColor.white
        exitFromPlaceButton.backgroundColor = UIColor.red
        exitFromPlaceButton.setTitle("Уйти", for: .normal)
        exitFromPlaceButton.addTarget(self, action: #selector(exitUserButtonPressed), for: .touchUpInside)
        currentPlaceView.addSubview(exitFromPlaceButton)
        
        detailPlaceButton = UIButton(frame: CGRect(x: 225, y: 55, width: 100, height: 30))
        detailPlaceButton.layer.cornerRadius = 5
        detailPlaceButton.clipsToBounds = true
        detailPlaceButton.titleLabel?.textColor = UIColor.white
        detailPlaceButton.setTitle("Подробнее", for: .normal)
        detailPlaceButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        detailPlaceButton.backgroundColor = UIColor.black
        detailPlaceButton.addTarget(self, action: #selector(detailPlaceButtonPressed), for: .touchUpInside)
        currentPlaceView.addSubview(detailPlaceButton)
    }
    
    @objc func exitUserButtonPressed() {
        let alertController = UIAlertController(title: "Уйти?", message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor.black
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let exitAction = UIAlertAction(title: "Уйти", style: .default) { (exitAction) in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(exitAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func detailPlaceButtonPressed() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "detailPlaceController") as? DetailPlaceController
        controller?.place = self.currentPlace!
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    func initNotCurrentPlaceView() {
        let label = UILabel(frame: CGRect(x: 16, y: 30, width: currentPlaceView.bounds.width - 32, height: 40))
        label.text = "Увы, Вы сейчас не находитесь не в одном заведении"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        label.textColor = UIColor.lightGray
        currentPlaceView.addSubview(label)
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
            let countAssessments = user?["countAssessment"] as? Int ?? 0
            self.nameLabel.text = name.uppercased()
            self.emailLabel.text = (Auth.auth().currentUser?.email)!
            self.countPlacesLabel.text = "\(countPlaces)"
            self.countAssessmentsLabel.text = "\(countAssessments)"
            self.view.addSubview(self.nameLabel)
            self.view.addSubview(self.emailLabel)
            self.view.addSubview(self.countPlacesLabel)
            self.view.addSubview(self.countAssessmentsLabel)
            self.view.addSubview(self.countPlacesTextLabel)
            self.view.addSubview(self.countAssessmentsTextLabel)
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
        
        self.countAssessmentsLabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2, y: 340, width: self.view.bounds.width / 2 - 50, height: 20))
        self.countAssessmentsLabel.textColor = UIColor.black
        self.countAssessmentsLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        self.countAssessmentsLabel.textAlignment = .center
        
        self.countPlacesTextLabel = UILabel(frame: CGRect(x: 50, y: 355, width: self.view.bounds.width / 2 - 50, height: 20))
        self.countPlacesTextLabel.textColor = UIColor.lightGray
        self.countPlacesTextLabel.font = UIFont(name: "AppleSDGothicNeo", size: 12)
        self.countPlacesTextLabel.text = "места"
        self.countPlacesTextLabel.textAlignment = .center
        
        self.countAssessmentsTextLabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2, y: 355, width: self.view.bounds.width / 2 - 50, height: 20))
        self.countAssessmentsTextLabel.textColor = UIColor.lightGray
        self.countAssessmentsTextLabel.font = UIFont(name: "AppleSDGothicNeo", size: 12)
        self.countAssessmentsTextLabel.text = "оценки"
        self.countAssessmentsTextLabel.textAlignment = .center
    }
    
    @objc func showLoginController() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LogInController
        controller?.profileViewController = self
        self.present(controller!, animated: true, completion: nil)
    }

}
