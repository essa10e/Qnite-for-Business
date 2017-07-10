//
//  ScannerViewController.swift
//  Qnite for Business
//
//  Created by Francesco Virga on 2017-06-27.
//  Copyright © 2017 Francesco Virga. All rights reserved.
//

import UIKit
import NotificationCenter



class ScannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    struct Cake {
        var name = String()
        var size = String()
    }
    
    @IBOutlet weak var venueButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarView: UIView!


    let venues: [String] = ["Ale House", "Stages"]
    var index: Int = 0

    
    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    
    var filteredData: [String]!
    
    var searchController: UISearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        venueButton.setTitle(venues[index], for: .normal)
        
        tableView.dataSource = self
        
        filteredData = []
        
        tableView.isHidden = true
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        //tableView.tableHeaderView = searchController.searchBar
        searchBarView.addSubview(searchController.searchBar)
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
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
        //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell?.textLabel?.text = filteredData[indexPath.row]
        cell?.detailTextLabel?.text = "Subtitlie"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredData = []
        } else {
            // Filter the results
            filteredData = data.filter { $0.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        tableView.isHidden = false
        self.tableView.reloadData()
        var newFrame: CGRect = self.tableView.frame;
        newFrame.size.height = self.tableView.contentSize.height;
        self.tableView.frame = newFrame;
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
}
