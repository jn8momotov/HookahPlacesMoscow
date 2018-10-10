//
//  ResetPasswordController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 10/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var resetPasswordButton: UIButton! {
        didSet {
            self.resetPasswordButton.layer.cornerRadius = 5
            self.resetPasswordButton.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        self.addLineToView(view: self.emailTextField, color: .black, width: 3)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func closeWindowBarButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: Any) {
        // Отправляем сообщение на почту для сброса пароля
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            // Скрываем клавиатуру
            self.view.endEditing(true)
            // Если нет ошибки пишем пользователю, что придет сообщение на почту для смены пароля
            if error == nil {
                self.defaultAlertController(title: "Подтверждение пароля", message: "На адрес электронной почты \(self.emailTextField.text!) отправлено сообщение для сброса пароля", actionTitle: "OK", handler: { (alertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
            }
                // Если есть ошибка - выводим ее на экран
            else {
                self.defaultAlertController(title: "Ошибка", message: (error?.localizedDescription)!, actionTitle: "OK", handler: nil)
            }
        }
    }
}
