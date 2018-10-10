//
//  LogInController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 02/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInController: UIViewController {
    
    var profileViewController: ProfileViewController?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            self.loginButton.layer.cornerRadius = 5
            self.loginButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var signupButton: UIButton! {
        didSet {
            self.signupButton.layer.cornerRadius = 5
            self.signupButton.layer.borderWidth = 2
            self.signupButton.layer.borderColor = UIColor.black.cgColor
            self.signupButton.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavigationController()
    }
    
    override func viewDidLayoutSubviews() {
        self.addLineToView(view: self.emailTextField, color: .black, width: 3)
        self.addLineToView(view: self.passwordTextField, color: .black, width: 3)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        let spinnerView = UIViewController.displaySpinner(onView: self.view)
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            UIViewController.removeSpinner(spinner: spinnerView)
            if error == nil {
                guard (user?.user.isEmailVerified)! else {
                    let alertController = UIAlertController(title: "Подтвердите профиль", message: "Подтвердите свой профиль, перейдя по ссылке в письме, пришедшее на ваш адрес электронной почты", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { (defaultAction) in
                        self.signOutUser()
                    })
                    let repeatSendMessageAction = UIAlertAction(title: "Отправить еще раз", style: .default, handler: { (repeatMessageAction) in
                        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                        self.defaultAlertController(title: "Подтвердите профиль", message: "На вашу почту \(self.emailTextField.text!) отправлено сообщение с подтверждением", actionTitle: "OK", handler: nil)
                        self.signOutUser()
                    })
                    alertController.addAction(defaultAction)
                    alertController.addAction(repeatSendMessageAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                if self.profileViewController != nil {
                    self.profileViewController?.loginButton.removeFromSuperview()
                    self.profileViewController?.initDataUser()
                }
                self.dismiss(animated: true, completion: nil)
            }
            else {
                self.defaultAlertController(title: "Ошибка", message: "Произошла ошибка! \(error!.localizedDescription)", actionTitle: "OK", handler: nil)
            }
        }
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: Any) {
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
    
    func initNavigationController() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: view.bounds.width, height: 44))
        navigationBar.backgroundColor = UIColor.white
        let navigationItem = UINavigationItem()
        navigationItem.title = "Вход"
        let leftButton = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: nil, action: #selector(LogInController.closeWindow))
        leftButton.tintColor = UIColor.black
        let rightButton = UIBarButtonItem(image: UIImage(named: "login"), style: .done, target: nil, action: #selector(LogInController.loginButtonPressed(_:)))
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
