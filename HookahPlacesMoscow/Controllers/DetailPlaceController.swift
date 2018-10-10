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
import Segmentio
import MapKit

class DetailPlaceController: UIViewController {

    var place: Place!
    var timeTableSegmentio: TimeTableSegmentioControl!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var namePlaceLabel: UILabel!
    @IBOutlet weak var addressPlaceLabel: UILabel!
    @IBOutlet weak var phonePlaceLabel: UILabel!
    @IBOutlet weak var imagePlaceView: UIImageView!
    @IBOutlet weak var TimeTableView: UIView!
    @IBOutlet weak var isLikeBarButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
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
        initData()
        initSegmentedControl()
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
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 1090)
        self.namePlaceLabel.text = "\(self.place.name!) \(self.place.metroStation!)"
        self.addressPlaceLabel.text = "\(self.place.distance) км, \(self.place.address!)"
        self.phonePlaceLabel.text = "Телефон: \(self.place.phone!)"
        self.ratingPlaceLabel.text = "\(place.rating)"
        self.hookahRatingProgressView.progress = Float(self.place.rating / 10.0 * 2.0)
        self.placeRatingProgressView.progress = Float(self.place.rating / 10.0 * 2.0)
        self.staffRatingProgressView.progress = Float(self.place.rating / 10.0 * 2.0)
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
    
//    func initMapView() {
//        let annotation = MKPointAnnotation()
//        let coordinate = CLLocationCoordinate2D(latitude: self.place.latitude, longitude: self.place.longitude)
//        annotation.coordinate = coordinate
//        annotation.title = self.place.name!
//        annotation.subtitle = self.place.metroStation!
//        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
//        self.mapView.addAnnotation(annotation)
//        self.mapView.setRegion(zoomRegion, animated: true)
//    }
    
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
}
