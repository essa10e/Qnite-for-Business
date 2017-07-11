//
//  ScannerViewController.swift
//  Qnite for Business
//
//  Created by Francesco Virga on 2017-06-27.
//  Copyright © 2017 Francesco Virga. All rights reserved.
//

import UIKit
import NotificationCenter
import FirebaseDatabase
import SVProgressHUD

class ScannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    // add observer to update dictionary if new person has paid
    
    @IBOutlet weak var venueButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarView: UIView!

    var IdDidScan = [String: Any]()
    var nameDidScan = [String: Any]()
    var nameIDs = [String: Any]()
    
    let venues: [String] = ["Ale House", "Stages"]
    var index: Int = 0
    
    var filteredData: [String: Any]!
    
    var searchController: UISearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchCoverData()
        observeChanges()
        venueButton.setTitle(venues[index], for: .normal)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        
        filteredData = [:]
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search Cover Purchases"
        //tableView.tableHeaderView = searchController.searchBar
        searchBarView.addSubview(searchController.searchBar)
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
    }
    
    func observeChanges() {
        DBProvider.Instance.eventRef.child("1378406678918207").child(Constants.Instance.getFIRDateInFormat()).child("Users Attending").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            self.fetchCoverData()
        }
    }
    
    func fetchCoverData() {
        DBProvider.Instance.eventRef.child("1378406678918207").child(Constants.Instance.getFIRDateInFormat()).child("Users Attending").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? [String: Any] {
                for (key,value) in data {
                    if let userData = value as? [String: Any] {
                        if let didScan = userData["Scanned"] as? Bool {
                            self.IdDidScan.updateValue(didScan, forKey: key)
                        }
                    }
                }
            }
        }
        
        DBProvider.Instance.usersRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? [String: Any] {
                for (key,value) in data {
                    if let didScan = self.IdDidScan[key] as? Bool {
                        if let userData = value as? [String: Any] {
                            if let name = userData["Name"] as? String {
                                self.nameDidScan.updateValue(didScan, forKey: name)
                                self.nameIDs.updateValue(key, forKey: name)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func venueChoice(_ sender: Any) {
        if index < (venues.count - 1) {
            index += 1
        }
        else {
            index = 0
        }
        venueButton.setTitle(venues[index], for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name("Venue Name"), object: venues[index])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let key = Array(filteredData.keys)[indexPath.row]
        let value = filteredData[key] as! Bool
        cell?.textLabel?.text = key
        
        if value {
            cell?.detailTextLabel?.text = "Scanned"
        }
        else {
            cell?.detailTextLabel?.text = "Hasn't Scanned"
        }
    
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let keys: [String] = Array(nameDidScan.keys)
        //let values = Array(nameDidScan.values)
        
        if searchController.searchBar.text! == "" {
            filteredData = [:]
        }
        else {
            let text = searchController.searchBar.text!.lowercased()
            let filteredKeys = keys.filter { $0.lowercased().contains(text) }
            
            filteredData = [:]
            if !filteredKeys.isEmpty {
                for key in filteredKeys {
                    filteredData.updateValue(nameDidScan[key]!, forKey: key)
                }
            }
        }
        tableView.isHidden = false
        tableView.reloadData()
        var newFrame: CGRect = tableView.frame;
        newFrame.size.height = tableView.contentSize.height;
        tableView.frame = newFrame;
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = Array(filteredData.keys)[indexPath.row]
        
        if Array(filteredData.values)[indexPath.row] as! Bool {
            
        }
        else {
            confirmAlert(title: "Update Status", message: "Change \(name)'s status to 'Scanned'?") { (action) in
                DBProvider.Instance.eventRef.child("1378406678918207").child(Constants.Instance.getFIRDateInFormat()).child("Users Attending").child(self.nameIDs[name] as! String).child("Scanned").setValue(true)
                self.fetchCoverData()
                self.searchController.searchBar.text = ""
                self.showSuccess(name: name)
            }
        }
    }
    
    func showSuccess(name: String) {
        SVProgressHUD.setFadeInAnimationDuration(0.2)
        SVProgressHUD.setFadeOutAnimationDuration(0.2)
        SVProgressHUD.showSuccess(withStatus: "\(name)")
        SVProgressHUD.dismiss(withDelay: 1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func confirmAlert(title: String, message: String, yesHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: yesHandler)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

/*
 
 func updateSearchResults(for searchController: UISearchController) {
 // If we haven't typed anything into the search bar then do not filter the results
 if searchController.searchBar.text! == "" {
 filteredCakes = cakes
 } else {
 // Filter the results
 filteredCakes = cakes.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
 }
 
 self.tableView.reloadData()
 }
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return self.filteredCakes.count
 }
 
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
 let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
 
 cell.textLabel?.text = self.filteredCakes[indexPath.row].name
 cell.detailTextLabel?.text = self.filteredCakes[indexPath.row].size
 
 return cell
 }
 
 
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 print("Row \(indexPath.row) selected")
 }
 */

/*
 func updateSearchResults(for searchController: UISearchController) {
 filterContentForSearchText(searchController.searchBar.text!)
 }
 
 func filterContentForSearchText(searchText: String, scope: String = "All") {
 filteredCandies = candies.filter { candy in
 return candy.name.lowercaseString.containsString(searchText.lowercaseString)
 }
 
 tableView.reloadData()
 }*/
