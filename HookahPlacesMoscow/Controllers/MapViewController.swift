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
import FirebaseDatabase
import FirebaseAuth

class MapViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var databaseRef: DatabaseReference!
    
    fileprivate let locationManager = CLLocationManager()
    
    fileprivate var currentCoordinate: CLLocationCoordinate2D!
    
    var results: [Place] = []
    
    var place: Place!
    
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
        databaseRef = Database.database().reference()
        mapView.delegate = self
        detailPlaceView.isHidden = true
        closeDetailViewButton.isHidden = true
        configureLocationServices()
        if place == nil {
            initAnnotationsPlaces()
        }
        else {
            initSelectedPlace()
        }
        initConfigBackBarButton()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toDetailSegue":
            let controller = segue.destination as? DetailPlaceController
            controller?.place = place
        case "segueToUsersList":
            let controller = segue.destination as? UsersToPlaceController
            controller?.idPlace = place.id
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
    
    @IBAction func addUserToPlaceButtonPressed(_ sender: Any) {
        guard Auth.auth().currentUser != nil else {
            let controller = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LogInController
            self.present(controller!, animated: true, completion: nil)
            return
        }
        guard !isPlace else {
            defaultAlertController(title: "Упс..", message: "Вы уже находитесь в заведении", actionTitle: "OK", handler: nil)
            return
        }
        let alertController = UIAlertController(title: nil, message: "Вы действительно находитесь в этом заведении?", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.black
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Подтверждаю", style: .default) { (okAction) in
            self.addUserToFirebase()
            isPlace = true
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
    
    func initSelectedPlace() {
        mapView.addAnnotation(newPointAnnotation(place: place))
        let zoomRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(zoomRegion, animated: true)
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
        databaseRef.child("places/\(place.id)/countCurrentUsers").observeSingleEvent(of: .value) { (snapshot) in
            self.countUsersButton.setTitle("  \(snapshot.value as? Int ?? 0)", for: .normal)
        }
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
    
    func addUserToFirebase() {
        databaseRef.child("places/\(place.id)/countCurrentUsers").observeSingleEvent(of: .value) { (snapshot) in
            let count = snapshot.value as? Int ?? -1
            guard count != -1 else {
                self.defaultAlertController(title: "Ошибка", message: "Попробуйте повторить попытку", actionTitle: "OK", handler: nil)
                return
            }
            self.databaseRef.child("places/\(self.place.id)/users/\(count)").setValue((Auth.auth().currentUser?.uid)!)
            let countUsers = count + 1
            self.databaseRef.child("places/\(self.place.id)/countCurrentUsers").setValue(countUsers)
        }
        databaseRef.child("users/\((Auth.auth().currentUser?.uid)!)/countPlace").observeSingleEvent(of: .value) { (snapshot) in
            var count = snapshot.value as? Int ?? -1
            guard count != -1 else {
                self.defaultAlertController(title: "Ошибка", message: "Попробуйте повторить попытку", actionTitle: "OK", handler: nil)
                return
            }
            count += 1
            self.databaseRef.child("users/\((Auth.auth().currentUser?.uid)!)/countPlace").setValue(count)
        }
        databaseRef.child("users/\((Auth.auth().currentUser?.uid)!)/isPlace").setValue(true)
        databaseRef.child("users/\((Auth.auth().currentUser?.uid)!)/idPlace").setValue(place.id)
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        if currentCoordinate == nil, place == nil {
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
        let zoomRegion = MKCoordinateRegion(center: (view.annotation?.coordinate)!, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(zoomRegion, animated: true)
        self.detailPlaceView.isHidden = false
        self.closeDetailViewButton.isHidden = false
        let tag = (view.annotation as? PointAnnotation)?.tag
        if results.count > 1 {
            place = results[Int(tag!)]
        }
        self.configureDetailView(place: place)
    }
    
    // Отмена выбора аннотации
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.detailPlaceView.isHidden = true
        self.closeDetailViewButton.isHidden = true
    }
    
}
