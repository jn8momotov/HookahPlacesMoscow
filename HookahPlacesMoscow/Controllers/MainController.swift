//
//  MainController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 20.09.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Segmentio
import CoreLocation

class MainController: UITableViewController {
    
    @IBOutlet weak var segmentioView: UIView!
    
    var segmentio: MainSegmentioControl!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
    
    var databaseRef: DatabaseReference!
    
    var results: [Place] = []
    
    private let locationManager: CLLocationManager = CLLocationManager()
    
    private var currentCoordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initLocationManager()
        self.loadData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        self.initSegmentedControl()
        self.segmentio.segmentioView.selectedSegmentioIndex = 0
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
        do {
            self.results = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        self.initConfigBackBarButton()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idMainCell", for: indexPath) as! MainPlaceCell
        let place = results[indexPath.row]
        configureCell(cell: cell, withObject: place)
        return cell
    }
    
    // MARK: - Refresh Control
    
    @IBAction func refreshControlAction(_ sender: Any) {
        if segmentio.segmentioView.selectedSegmentioIndex == 0 {
            self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
        }
        else {
            self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "distance", ascending: true)]
        }
        do {
            self.results = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToDetail":
            let controller = segue.destination as! DetailPlaceController
            let cell = sender as! MainPlaceCell
            let index = (self.tableView.indexPath(for: cell)?.row)!
            controller.place = results[index]
        default:
            return
        }
    }
    

}

extension MainController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Получаем последнюю локацию пользователя
        let currentLocation = locations.last
        // Останавливаем обновление геолокации
        locationManager.stopUpdatingLocation()
        // Получаем координаты пользователя
        let coords = CLLocationCoordinate2DMake((currentLocation?.coordinate.latitude)!, (currentLocation?.coordinate.longitude)!)
        // Передаем координаты в переменную класса
        self.currentCoordinate = coords
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
}

extension MainController {
    
    func initLocationManager() {
        self.locationManager.delegate = self
        // Точность определения геолокации
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Запрос на получение геолокации
        self.locationManager.requestWhenInUseAuthorization()
        // Получаем геоданные пользователя
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: - Segmented Control
    
    // Инициализация сегмент контроллера
    func initSegmentedControl() -> Void {
        let items: [SegmentioItem] = [
            SegmentioItem(title: "Популярное", image: nil),
            SegmentioItem(title: "Рядом", image: nil)
        ]
        self.segmentio = MainSegmentioControl(
            items: items,
            view: self.view,
            handler: self.segmentedControlCallback
        )
        
        self.segmentio.index = 1
    }
    
    // Обновляем данные таблицы при изменении значения segment control
    func segmentedControlCallback(_ segmentio: Segmentio, _ selectedSegmentioIndex: Int) -> Void {
        if selectedSegmentioIndex == 0 {
            self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
        }
        else {
            self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "distance", ascending: true)]
        }
        do {
            self.results = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    func loadData(completionHandler: (() -> Void)?) {
        let entityPlace = NSEntityDescription.entity(forEntityName: "Place", in: context)
        databaseRef = Database.database().reference()
        if let user = Auth.auth().currentUser {
            databaseRef.child("users/\(user.uid)/isPlace").observeSingleEvent(of: .value) { (snapshot) in
                isPlace = snapshot.value as? Bool ?? true
            }
        }
        databaseRef.child("countPlaces").observeSingleEvent(of: .value, with: { (snapshot) in
            let count = snapshot.value as? NSInteger
            var index = 0
            guard try! self.context.count(for: self.fetchRequest) == 0 else {
                print("НАЧИНАЕМ ОБНОВЛЯТЬ ДАННЫЕ!")
                while index < count! {
                    let fetchWithIdRequest: NSFetchRequest<Place> = Place.fetchRequest()
                    fetchWithIdRequest.predicate = NSPredicate(format: "id = \(index)")
                    do {
                        let objects = try self.context.fetch(fetchWithIdRequest)
                        guard objects.count != 0 else {
                            return
                        }
                        let place = objects[0]
                        if let coords = self.currentCoordinate {
                            place.distance = self.distanceKm(from: coords, toLatitude: place.latitude, toLongitude: place.longitude)
                            print("ДАННЫЕ ОБНОВЛЕНЫ!")
                        }
                        self.databaseRef.child("places/\(place.id)").observeSingleEvent(of: .value, with: { (snapshot) in
                            let obj = snapshot.value as? NSDictionary
                            place.rating = obj?["rating"] as? Double ?? 0.0
                            place.ratingHookah = obj?["ratingHookah"] as? Double ?? 0.0
                            place.ratingPlace = obj?["ratingPlace"] as? Double ?? 0.0
                            place.ratingStaff = obj?["ratingStaff"] as? Double ?? 0.0
                        })
                    try self.context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    completionHandler?()
                    index += 1
                }
                return
            }
            while index < count! {
                let objPlaceRef = self.databaseRef.child("places/\(index)")
                objPlaceRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let place = snapshot.value as? NSDictionary
                    let id = place?["id"] as? Int16 ?? 0
                    let storageRef = Storage.storage().reference()
                    var image: UIImage?
                    storageRef.child("places/\(id)-1.jpg").getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                        if error == nil {
                            image = UIImage(data: data!)
                        }
                        
                        self.addPlaceObject(entity: entityPlace,
                                            id: id,
                                            name: place?["name"] as? String ?? "",
                                            metroStation: place?["metroStation"] as? String ?? "",
                                            address: place?["address"] as? String ?? "",
                                            phone: place?["phone"] as? String ?? "",
                                            rating: place?["rating"] as? Double ?? 0.0,
                                            ratingHookah: place?["ratingHookah"] as? Double ?? 0.0,
                                            ratingPlace: place?["ratingPlace"] as? Double ?? 0.0,
                                            ratingStaff: place?["ratingStaff"] as? Double ?? 0.0,
                                            latitude: place?["latitude"] as? Double ?? 0.0,
                                            longitude: place?["longitude"] as? Double ?? 0.0,
                                            countUsers: place?["countCurrentUsers"] as? Int16 ?? 0,
                                            image: image,
                                            restarting: place?["restarting"] as? Bool ?? false,
                                            theirFoot: place?["theirFoot"] as? Bool ?? false,
                                            theirDrink: place?["theirDrink"] as? Bool ?? false,
                                            theirAlko: place?["theirAlko"] as? Bool ?? false,
                                            tableGames: place?["tableGames"] as? Bool ?? false,
                                            gameConsole: place?["gameConsole"] as? Bool ?? false,
                                            wifi: place?["wifi"] as? Bool ?? false,
                                            bankCard: place?["bankCard"] as? Bool ?? false)
                    })
                    completionHandler?()
                })
                index += 1
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func updateDistance() {
        self.locationManager.startUpdatingLocation()
    }
    
    func addPlaceObject(entity: NSEntityDescription?, id: Int16, name: String, metroStation: String, address: String, phone: String, rating: Double, ratingHookah: Double, ratingPlace: Double, ratingStaff: Double, latitude: Double, longitude: Double, countUsers: Int16, image: UIImage?, restarting: Bool, theirFoot: Bool, theirDrink: Bool, theirAlko: Bool, tableGames: Bool, gameConsole: Bool, wifi: Bool, bankCard: Bool) {
        let place = NSManagedObject(entity: entity!, insertInto: context) as! Place
        place.id = id
        place.name = name
        place.metroStation = metroStation
        place.address = address
        place.phone = phone
        place.rating = rating
        place.ratingHookah = ratingHookah
        place.ratingPlace = ratingPlace
        place.ratingStaff = ratingStaff
        place.latitude = latitude
        place.longitude = longitude
        place.countUsers = countUsers
        place.isLike = false
        place.restarting = restarting
        place.theirFoot = theirFoot
        place.theirDrink = theirDrink
        place.theirAlko = theirAlko
        place.tableGames = tableGames
        place.gameConsole = gameConsole
        place.wifi = wifi
        place.bankCard = bankCard
        if let coords = currentCoordinate {
            place.distance = self.distanceKm(from: coords, toLatitude: latitude, toLongitude: longitude)
        }
        else {
            place.distance = 0.0
        }
        if let img = image {
            place.image = img.pngData() as NSData?
        }
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func configureCell(cell: MainPlaceCell, withObject place: Place) {
        cell.nameLabel.text = "\(place.name!) \(place.metroStation!)"
        cell.addressLabel.text = place.address!
        cell.ratingLabel.text = "\(place.rating)"
        cell.distanceToPlaceLabel.text = "\(place.distance) км"
        if let image = place.image {
            cell.imagePlaceView.image = UIImage(data: image as Data)
        }
        else {
            cell.imagePlaceView.image = UIImage(named: "NoImage")
        }
    }
    
}
