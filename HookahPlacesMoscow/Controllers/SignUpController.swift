//
//  SignUpController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 03/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class SignUpController: UIViewController {
    
    var databaseRef: DatabaseReference!
    
    @IBOutlet weak var imageProfileButton: UIButton! {
        didSet {
            self.imageProfileButton.setTitle("ДОБАВИТЬ\nФОТО", for: .normal)
            self.imageProfileButton.titleLabel?.textAlignment = .center
            self.imageProfileButton.titleLabel?.numberOfLines = 2
            self.imageProfileButton.layer.cornerRadius = 55
            self.imageProfileButton.layer.borderWidth = 5
            self.imageProfileButton.layer.borderColor = UIColor.black.cgColor
            self.imageProfileButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            self.nameTextField.autocapitalizationType = .words
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            self.signUpButton.layer.cornerRadius = 5
            self.signUpButton.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseRef = Database.database().reference()
        self.initNavigationController()
    }
    
    override func viewDidLayoutSubviews() {
        self.addLineToView(view: self.nameTextField, color: .black, width: 3)
        self.addLineToView(view: self.emailTextField, color: .black, width: 3)
        self.addLineToView(view: self.passwordTextField, color: .black, width: 3)
        self.addLineToView(view: self.repeatPasswordTextField, color: .black, width: 3)
    }
    
    @IBAction func imageProfileButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor.black
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let openLibraryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { (openLibraryAction) in
            
        }
        let takePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { (takePhotoAction) in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(openLibraryAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard passwordTextField.text == repeatPasswordTextField.text else {
            self.defaultAlertController(title: "Некорректный пароль", message: "Неверно введен пароль. Повторите попытку", actionTitle: "OK", handler: nil)
            return
        }
        guard nameTextField.text != "" else {
            self.defaultAlertController(title: "Пустое поле", message: "Для завершения регистрации требуется заполнить все поля", actionTitle: "OK", handler: nil)
            return
        }
        self.view.endEditing(true)
        let spinnerView = UIViewController.displaySpinner(onView: self.view)
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            UIViewController.removeSpinner(spinner: spinnerView)
            if error == nil {
                self.view.endEditing(true)
                self.addNewUser()
            }
            else {
                self.defaultAlertController(title: "Ошибка", message: "Не удалось зарегистрироваться! \(error!.localizedDescription)", actionTitle: "OK", handler: nil)
            }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func addNewUser() {
        let storeRef = Storage.storage().reference()
        let usersRef = storeRef.child("Users/\((Auth.auth().currentUser?.uid)!).jpg")
        if let image = self.imageProfileButton.currentBackgroundImage {
            let data = image.pngData()
            usersRef.putData(data!, metadata: nil)
        }
        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
        self.defaultAlertController(title: "Подтвердите профиль", message: "На вашу почту \(self.emailTextField.text!) отправлено сообщение с подтверждением", actionTitle: "OK") { (defaultAction) in
            self.signOutUser()
            self.dismiss(animated: true, completion: nil)
        }
        self.databaseRef.child("countUsers").observeSingleEvent(of: .value, with: { (snapshot) in
            let countUsers = snapshot.value as? NSInteger
            self.databaseRef.child("users").child("\((Auth.auth().currentUser?.uid)!)").setValue([
                "name": self.nameTextField.text!,
                "email": self.emailTextField.text!,
                "countPlace": 0,
                "countReviews": 0
                ])
            self.databaseRef.child("countUsers").setValue(countUsers! + 1)
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
    }
    
    func initNavigationController() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: view.bounds.width, height: 44))
        navigationBar.backgroundColor = UIColor.white
        let navigationItem = UINavigationItem()
        navigationItem.title = "Регистрация"
        let leftButton = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: nil, action: #selector(SignUpController.closeWindow))
        leftButton.tintColor = UIColor.black
        let rightButton = UIBarButtonItem(image: UIImage(named: "login"), style: .done, target: nil, action: #selector(SignUpController.signUpButtonPressed(_:)))
        rightButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        navigationBar.items = [navigationItem]
        self.view.addSubview(navigationBar)
    }
    
    @objc func closeWindow() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

}
