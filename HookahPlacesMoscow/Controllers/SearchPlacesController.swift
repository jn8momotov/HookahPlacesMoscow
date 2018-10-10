//
//  SearchPlacesController.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 05/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import CoreData

class SearchPlacesController: UITableViewController {
    
    fileprivate var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
    
    fileprivate var results = [Place]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var restarting: Bool!
    var theirFoot: Bool!
    var theirDrink: Bool!
    var theirAlko: Bool!
    var tableGames: Bool!
    var gameConsole: Bool!
    var wifi: Bool!
    var bankCard: Bool!
    
    var filters = [NSPredicate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.initConfigBackBarButton()
        self.initFiltersFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchPlaceCell", for: indexPath) as! SearchPlaceCell
        let place = results[indexPath.row]
        cell.imageViewPlace.image = UIImage(data: place.image! as Data)
        cell.namePlaceLabel.text = "\(place.name!) \(place.metroStation!)"
        cell.distanceToPlaceLabel.text = "\(place.distance) км"
        cell.ratingPlaceLabel.text = "\(place.rating)"
        return cell
    }
    
    func initFiltersFields() {
        self.restarting = false
        self.theirFoot = false
        self.theirDrink = false
        self.theirAlko = false
        self.tableGames = false
        self.gameConsole = false
        self.wifi = false
        self.bankCard = false
    }
    
    func getPlaces(text: String?) {
        var resultsFilters = filters
        resultsFilters.append(NSPredicate(format: "name contains[c] %@ OR metroStation contains[c] %@", argumentArray: [text!, text!]))
        let predicates = NSCompoundPredicate(type: .and, subpredicates: resultsFilters)
        self.fetchRequest.predicate = predicates
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "distance", ascending: true)]
        do {
            self.results = try context.fetch(self.fetchRequest)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func filtersBarButtonPressed(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "filtersController") as? FiltersController
        controller?.searchController = self
        self.present(controller!, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToDetailPlace":
            let controller = segue.destination as? DetailPlaceController
            let cell = sender as! SearchPlaceCell
            let index = (self.tableView.indexPath(for: cell)?.row)!
            controller?.place = self.results[index]
        default:
            return
        }
    }

}

extension SearchPlacesController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.getPlaces(text: searchText)
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
