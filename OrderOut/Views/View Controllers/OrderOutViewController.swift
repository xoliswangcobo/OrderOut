//
//  OrderOutViewController.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/29.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit
import Bond
import MapKit

class OrderOutViewController: UIViewController {

    var viewModel: OrderOutViewModel!
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var noLocationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toSettings: UIButton!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBinding()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Food"
        self.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc func refresh(_ sender: UIRefreshControl?) {
        guard let keyWord = self.searchController.searchBar.text, keyWord != ""  else {
            return
        }
        
        self.viewModel.findFood(name: keyWord)
    }
}

// MARK: - Search Updating

extension OrderOutViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let keyWord = searchController.searchBar.text, keyWord.isEmpty == false, searchController.isEditing == false {
            self.viewModel.findFood(name: keyWord)
        }
    }
}


// MARK: - Bond Binding

extension OrderOutViewController {
    
    func setupBinding() {
        self.viewModel.businesses.observeNext { businesses in
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }.dispose(in: self.bag)
        
        self.viewModel.locationAvailable.observeNext { status in
            if status {
                self.navigationItem.searchController = self.searchController
                self.tableView.isHidden = false
                self.noLocationView.isHidden = true
                self.definesPresentationContext = true
            } else {
                self.navigationItem.searchController = nil
                self.tableView.isHidden = true
                self.noLocationView.isHidden = false
            }
        }.dispose(in: self.bag)
        
        self.toSettings.reactive.tap.observe { _ in
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(settingsUrl)
        }.dispose(in: self.bag)
        
        self.viewModel.orderOutMessage.observeNext { message in
            switch message {
                case .Message(let text):
                    MessageView.showMessage(title: "OrderOut", message: text, viewController: self)
                case .None:
                   break
            }
        }.dispose(in: self.bag)
    }
}


// MARK: - TableView Delegate & Data Source

extension OrderOutViewController: UITableViewDelegate,  UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.businesses.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessTableViewCell
        
        let business = self.viewModel.businesses.value[indexPath.row]
        
        cell.name.text = business.name
        cell.address.text = business.vicinity
        
        if let reference = business.photos?.first?.photoReference {
            self.viewModel.photo(reference: reference) { data in
                cell.icon.image = UIImage(data: data)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showLocationActions(business: self.viewModel.businesses.value[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - Navigation

extension OrderOutViewController {
    
    func showLocationActions(business:Business) {
        
        let alertViewController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let attributedTitle = NSAttributedString(string: "Select", attributes: [ .foregroundColor : UIColor.primary ])
        let attributedMessage = NSAttributedString(string: "", attributes: [ .foregroundColor : UIColor.primary ])
        
        alertViewController.setValuesForKeys(["attributedTitle" : attributedTitle, "attributedMessage" : attributedMessage])
        
        let mapViewButton = UIAlertAction(title: "View on Map", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "toMapView", sender: business)
        })
        alertViewController.addAction(mapViewButton)
        
        let navigationMapButton = UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
            let mapItem = MKMapItem(placemark: MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: business.geometry.location.lat, longitude: business.geometry.location.lng)))
            mapItem.name = business.name

            let launchOptions = [ MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving ]
            
            mapItem.openInMaps(launchOptions: launchOptions)
        })
        alertViewController.addAction(navigationMapButton)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertViewController.addAction(cancel)
        
        alertViewController.view.tintColor = .primary
        present(alertViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapView" {
            let viewController = segue.destination as! MapViewController
            viewController.business = (sender as! Business)
        }
    }
}
