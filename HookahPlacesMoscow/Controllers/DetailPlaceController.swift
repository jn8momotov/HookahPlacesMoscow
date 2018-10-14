//
//  DetailPlaceController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 30/09/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseDatabase
import Segmentio
import MapKit

class DetailPlaceController: UIViewController {

    var place: Place!
    var timeTableSegmentio: TimeTableSegmentioControl!
    var isAssessment: Bool!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var databaseRef: DatabaseReference!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var namePlaceLabel: UILabel!
    @IBOutlet weak var addressPlaceLabel: UILabel!
    @IBOutlet weak var phonePlaceLabel: UILabel!
    @IBOutlet weak var imagePlaceView: UIImageView!
    @IBOutlet weak var TimeTableView: UIView!
    @IBOutlet weak var isLikeBarButton: UIBarButtonItem!
    @IBOutlet weak var ratingPlaceLabel: UILabel!
    
    @IBOutlet weak var addRatingPlaceButton: UIButton! {
        didSet {
            self.addRatingPlaceButton.layer.cornerRadius = 5
            self.addRatingPlaceButton.layer.borderColor = UIColor.black.cgColor
            self.addRatingPlaceButton.layer.borderWidth = 2
            self.addRatingPlaceButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var detailInfoButton: UIButton! {
        didSet {
            self.detailInfoButton.layer.cornerRadius = 5
            self.detailInfoButton.layer.borderColor = UIColor.black.cgColor
            self.detailInfoButton.layer.borderWidth = 1
            self.detailInfoButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var showPlaceOnMapButton: UIButton! {
        didSet {
            self.showPlaceOnMapButton.layer.cornerRadius = 5
            self.showPlaceOnMapButton.layer.borderWidth = 1
            self.showPlaceOnMapButton.layer.borderColor = UIColor.black.cgColor
            self.showPlaceOnMapButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var hookahRatingProgressView: UIProgressView! {
        didSet {
            self.hookahRatingProgressView.transform = self.hookahRatingProgressView.transform.scaledBy(x: 1, y: 4)
        }
    }
    
    @IBOutlet weak var placeRatingProgressView: UIProgressView! {
        didSet {
            self.placeRatingProgressView.transform = self.placeRatingProgressView.transform.scaledBy(x: 1, y: 4)
        }
    }
    
    @IBOutlet weak var staffRatingProgressView: UIProgressView! {
        didSet {
            self.staffRatingProgressView.transform = self.staffRatingProgressView.transform.scaledBy(x: 1, y: 4)
        }
    }
    
    @IBOutlet weak var addUserToPlaceButton: UIButton! {
        didSet {
            self.addUserToPlaceButton.layer.cornerRadius = 5
            self.addUserToPlaceButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var countUsersButton: UIButton! {
        didSet {
            self.countUsersButton.layer.cornerRadius = 5
            self.countUsersButton.clipsToBounds = true
        }
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        initIsAssessment()
        initData()
        initSegmentedControl()
        updateRating()
        initConfigBackBarButton()
    }
    
    @IBAction func isLikeBarButtonPressed(_ sender: Any) {
        if self.isLikeBarButton.tintColor == UIColor.black {
            self.isLikeBarButton.tintColor = UIColor.red
            self.changeIsLike(isLike: true)
        }
        else {
            self.isLikeBarButton.tintColor = UIColor.black
            self.changeIsLike(isLike: false)
        }
    }
    
    @IBAction func callToPlaceBarButtonPressed(_ sender: Any) {
        if let url = URL(string: "tel://\(place.phone!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func addUserToPlaceButtonPressed(_ sender: Any) {
        guard Auth.auth().currentUser != nil else {
            let controller = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LogInController
            self.present(controller!, animated: true, completion: nil)
            return
        }
    }
    
    @IBAction func addAssessmentButtonPressed(_ sender: Any) {
        guard Auth.auth().currentUser != nil else {
            let controller = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LogInController
            self.present(controller!, animated: true, completion: nil)
            return
        }
        
        if isAssessment {
            defaultAlertController(title: "Отметка", message: "Вы уже ставили оценку этому заведению", actionTitle: "OK", handler: nil)
            return
        }
        
        let navController = storyboard?.instantiateViewController(withIdentifier: "navControllerAssessment") as? UINavigationController
        let controller = navController?.viewControllers.first as? AssessmentPlaceController
        controller?.place = place
        self.present(navController!, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToUsersToPlaceController":
            let controller = segue.destination as? UsersToPlaceController
        case "segueToInfoFilters":
            let controller = segue.destination as? InfoPlaceFiltersController
            controller?.place = place
        case "segueToMap":
            let navController = segue.destination as? UINavigationController
            let controller = navController?.viewControllers.first as? MapViewController
            controller?.place = place
        default:
            return
        }
    }

    func initData() {
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 750)
        self.namePlaceLabel.text = "\(self.place.name!) \(self.place.metroStation!)"
        self.addressPlaceLabel.text = "\(self.place.distance) км, \(self.place.address!)"
        let phone = place.phone!
        self.phonePlaceLabel.text = "Телефон: +7 (\(phone[phone.index(phone.startIndex, offsetBy: 1)...phone.index(phone.startIndex, offsetBy: 3)])) \(phone[phone.index(phone.startIndex, offsetBy: 4)...phone.index(phone.startIndex, offsetBy: 6)]) \(phone[phone.index(phone.startIndex, offsetBy: 7)...phone.index(phone.startIndex, offsetBy: 8)]) \(phone[phone.index(phone.startIndex, offsetBy: 9)...phone.index(phone.startIndex, offsetBy: 10)])"
        self.ratingPlaceLabel.text = "\(place.rating)"
        self.hookahRatingProgressView.progress = Float(self.place.ratingHookah / 10.0 * 2.0)
        self.placeRatingProgressView.progress = Float(self.place.ratingPlace / 10.0 * 2.0)
        self.staffRatingProgressView.progress = Float(self.place.ratingStaff / 10.0 * 2.0)
        if place.isLike {
            self.isLikeBarButton.tintColor = UIColor.red
        }
        else {
            self.isLikeBarButton.tintColor = UIColor.black
        }
        if let image = self.place.image {
            self.imagePlaceView.image = UIImage(data: image as Data)
        }
        else {
            self.imagePlaceView.image = UIImage(named: "NoImage")
        }
    }
    
    func initSegmentedControl() {
        let items: [SegmentioItem] = [
            SegmentioItem(title: "ПН\n11:00\n05:00", image: nil),
            SegmentioItem(title: "ВТ\n11:00\n05:00", image: nil),
            SegmentioItem(title: "СР\n11:00\n05:00", image: nil),
            SegmentioItem(title: "ЧТ\n11:00\n05:00", image: nil),
            SegmentioItem(title: "ПТ\n11:00\n05:00", image: nil),
            SegmentioItem(title: "СБ\n11:00\n05:00", image: nil),
            SegmentioItem(title: "ВС\n11:00\n05:00", image: nil)
        ]
        self.timeTableSegmentio = TimeTableSegmentioControl(
            items: items,
            view: self.TimeTableView
        )
    }
    
    func changeIsLike(isLike: Bool) {
        let fetchRequest = NSFetchRequest<Place>(entityName: "Place")
        fetchRequest.predicate = NSPredicate(format: "id = \(self.place.id)")
        do {
            let objects = try context.fetch(fetchRequest)
            guard objects.count != 0 else {
                return
            }
            let place = objects[0]
            place.isLike = isLike
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func initIsAssessment() {
        isAssessment = false
        databaseRef.child("places/\(place.id)/countAssessment").observe(.value) { (snapshot) in
            let count = snapshot.value as? Int ?? 0
            var index = 0
            while index < count {
                self.databaseRef.child("places/\(self.place.id)/assessments/\(index)/id").observeSingleEvent(of: .value, with: { (snapshot) in
                    let id = snapshot.value as? String ?? ""
                    if id == Auth.auth().currentUser?.uid {
                        self.isAssessment = true
                        self.addRatingPlaceButton.setTitle("  Вы оценили", for: .normal)
                        return
                    }
                })
                index += 1
            }
        }
    }
    
    func updateRating() {
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = \(self.place.id)")
        var results: [Place] = []
        do {
            results = try self.context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        guard results.count != 0 else {
            return
        }
        let placeCore = results[0]
        print(results.count)
        databaseRef.child("places/\(place.id)").observeSingleEvent(of: .value) { (snapshot) in
            let object = snapshot.value as? NSDictionary
            placeCore.rating = object?["rating"] as? Double ?? 0.0
            placeCore.ratingHookah = object?["ratingHookah"] as? Double ?? 0.0
            placeCore.ratingPlace = object?["ratingPlace"] as? Double ?? 0.0
            placeCore.ratingStaff = object?["ratingStaff"] as? Double ?? 0.0
            self.ratingPlaceLabel.text = "\(placeCore.rating)"
            self.hookahRatingProgressView.progress = Float(placeCore.ratingHookah / 10.0 * 2.0)
            self.placeRatingProgressView.progress = Float(placeCore.ratingPlace / 10.0 * 2.0)
            self.staffRatingProgressView.progress = Float(placeCore.ratingStaff / 10.0 * 2.0)
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
