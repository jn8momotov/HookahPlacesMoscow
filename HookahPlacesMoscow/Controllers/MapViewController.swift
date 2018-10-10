//
//  MapViewController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 02/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    fileprivate let locationManager = CLLocationManager()
    
    fileprivate var currentCoordinate: CLLocationCoordinate2D!
    
    var results: [Place] = []
    
    var idSelectPlace: Int!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var detailPlaceView: UIView! {
        didSet {
            self.detailPlaceView.layer.cornerRadius = 10
            self.detailPlaceView.layer.borderColor = UIColor.black.cgColor
            self.detailPlaceView.layer.borderWidth = 4
            self.detailPlaceView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imagePlace: UIImageView! {
        didSet {
            self.imagePlace.layer.cornerRadius = 40
            self.imagePlace.layer.borderColor = UIColor.black.cgColor
            self.imagePlace.layer.borderWidth = 4
            self.imagePlace.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var namePlaceLabel: UILabel!
    @IBOutlet weak var distanceToPlaceLabel: UILabel!
    @IBOutlet weak var ratingPlaceLabel: UILabel!
    
    @IBOutlet weak var addNewUserButton: UIButton! {
        didSet {
            self.addNewUserButton.layer.cornerRadius = 5
            self.addNewUserButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var countUsersButton: UIButton!{
        didSet {
            self.countUsersButton.layer.cornerRadius = 5
            self.countUsersButton.layer.borderWidth = 2
            self.countUsersButton.layer.borderColor = UIColor.black.cgColor
            self.countUsersButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var openDetailVireControllerButton: UIButton! {
        didSet {
            self.openDetailVireControllerButton.layer.cornerRadius = 5
            self.openDetailVireControllerButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var closeDetailViewButton: UIButton! {
        didSet {
            self.closeDetailViewButton.layer.cornerRadius = 15
            self.closeDetailViewButton.layer.borderColor = UIColor.black.cgColor
            self.closeDetailViewButton.layer.borderWidth = 4
            self.closeDetailViewButton.clipsToBounds = true
        }
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        detailPlaceView.isHidden = true
        closeDetailViewButton.isHidden = true
        configureLocationServices()
        initAnnotationsPlaces()
        initConfigBackBarButton()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toDetailSegue":
            let controller = segue.destination as? DetailPlaceController
            controller?.place = results[idSelectPlace]
        default:
            return
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func closeWindow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hideDetailViewButtonPressed(_ sender: Any) {
        self.detailPlaceView.isHidden = true
        self.closeDetailViewButton.isHidden = true
    }
    
    // MARK: - Functions
    
    // Добавление аннотаций на карту
    func initAnnotationsPlaces() {
        if results.count == 0 {
            let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            do {
                results = try context.fetch(fetchRequest)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        for place in results {
            self.mapView.addAnnotation(self.newPointAnnotation(place: place))
        }
    }
    
    // Создание аннотации
    func newPointAnnotation(place: Place) -> PointAnnotation {
        let marker = PointAnnotation()
        marker.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        marker.title = place.name
        marker.subtitle = place.metroStation
        marker.tag = place.id
        return marker
    }
    
    // Заполнение информации по заведению
    func configureDetailView(place: Place) {
        self.namePlaceLabel.text = "\(place.name!) \(place.metroStation!)"
        self.distanceToPlaceLabel.text = "\(place.distance) км"
        self.ratingPlaceLabel.text = "\(place.rating)"
        if let image = place.image {
            self.imagePlace.image = UIImage(data: image as Data)
        }
        else {
            self.imagePlace.image = UIImage(named: "NoImage")
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        if currentCoordinate == nil {
            zoomToLatestocation(with: latestLocation.coordinate)
        }
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginUpdateLocation(locationManager: manager)
        }
    }
    
    // Начало обновления получения геолокации
    private func beginUpdateLocation(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // Конфигурации определения местоположения
    private func configureLocationServices() {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        else if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginUpdateLocation(locationManager: self.locationManager)
        }
    }
    
    // Приближение к геолокации пользователя на карте
    private func zoomToLatestocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    // Нажатие на аннотацию
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.detailPlaceView.isHidden = false
        self.closeDetailViewButton.isHidden = false
        let tag = (view.annotation as? PointAnnotation)?.tag
        idSelectPlace = Int(tag!)
        let place = results[idSelectPlace]
        self.configureDetailView(place: place)
    }
    
    // Отмена выбора аннотации
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.detailPlaceView.isHidden = true
        self.closeDetailViewButton.isHidden = true
    }
    
}
