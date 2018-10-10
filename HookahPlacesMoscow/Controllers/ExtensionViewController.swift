//
//  ExtensionViewController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 30/09/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseAuth

extension UIViewController {
    
    func initConfigBackBarButton() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
    }
    
    // Определяет расстояние до заведения
    func distanceKm(from: CLLocationCoordinate2D, toLatitude: Double, toLongitude: Double) -> Double {
        let thisLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let otherLocation = CLLocation(latitude: toLatitude, longitude: toLongitude)
        let distance = thisLocation.distance(from: otherLocation)
        var doubleDistance = (Double(distance / 1000))
        doubleDistance = Double(round(10 * doubleDistance) / 10)
        return doubleDistance
    }
    
    // Добавление border bottom to view
    func addLineToView(view : UIView, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineView)
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
    
    // Показ сообщения
    func defaultAlertController(title: String, message: String, actionTitle: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = UIColor.black
        let defaultAction = UIAlertAction(title: actionTitle, style: .cancel, handler: handler)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Выход пользователя из системы
    func signOutUser() {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            self.defaultAlertController(title: "Ошибка", message: signOutError.localizedDescription, actionTitle: "OK", handler: nil)
        }
    }
    
    // Показать индикатор загрузки
    class func displaySpinner(onView: UIView) -> UIView {
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activeIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activeIndicator.startAnimating()
        activeIndicator.center = spinnerView.center
        DispatchQueue.main.async {
            spinnerView.addSubview(activeIndicator)
            onView.addSubview(spinnerView)
        }
        return spinnerView
    }
    
    // Завершить индикатор загрузки
    class func removeSpinner(spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
}
