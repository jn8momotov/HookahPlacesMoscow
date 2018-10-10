//
//  LikePlacesController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 02/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import CoreData

class LikePlacesController: UIViewController {

    @IBOutlet weak var likePlacesCollectionView: UICollectionView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var results: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.likePlacesCollectionView.delegate = self
        self.likePlacesCollectionView.dataSource = self
        self.initConfigBackBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initListLikePlaces()
        self.likePlacesCollectionView.reloadData()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToDetail":
            let controller = segue.destination as! DetailPlaceController
            let cell = sender as! LikePlaceCell
            let index = (self.likePlacesCollectionView.indexPath(for: cell)?.row)!
            controller.place = results[index]
        default:
            return
        }
    }
    
    func initListLikePlaces() {
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLike = true")
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print(error.localizedDescription)
        }
    }

}

extension LikePlacesController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likePlaceCell", for: indexPath) as? LikePlaceCell else {
            return UICollectionViewCell()
        }
        let place = results[indexPath.row]
        if let image = place.image {
            cell.imagePlaceView.image = UIImage(data: image as Data)
        }
        else {
            cell.imagePlaceView.image = UIImage(named: "NoImage")
        }
        cell.namePlaceLabel.text = place.name!
        cell.metroStationPlaceLabel.text = place.metroStation!
        return cell
    }
    
    
}
