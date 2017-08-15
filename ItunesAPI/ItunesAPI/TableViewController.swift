//
//  TableViewController.swift
//  ItunesAPI
//
//  Created by Marcus Larson on 11/10/16.
//  Copyright © 2016 IVaE. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController{
    
    @IBOutlet var appsTableView : UITableView!
    var tableData : [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchItunesFor(searchTerm: "one direction")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchItunesFor(searchTerm: String){
        // Itunes wants multiple terms separated by +, so replace " " with "+"
        let itunesSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+")
        
        // Now escape anything else that isn't URL-friendly
        let escapedSearchTerm = itunesSearchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed )
        let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm!)&media=software"
        let url = URL(string: urlPath)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {data, response, error in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                print(error!.localizedDescription)
            }
            do{
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                if let results: NSArray = jsonResult!["results"] as? NSArray {
                    DispatchQueue.main.async(execute: {
                        self.tableData = results as! [NSDictionary]
                        self.appsTableView.reloadData()
                    })
                }
                
            } catch let err as NSError{
                // If there is an error parsing JSON, print it to the console
                print("JSON Error \(err.localizedDescription)")
                
            }
        }
        
        // The task is just an object with all these properties set
        // In order to actually make the web request, we need to "resume"
        task.resume()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "MyTestCell")
        
        let rowData: NSDictionary = self.tableData[indexPath.row]
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString = rowData["artworkUrl60"] as? String
        // Create an NSURL instance from the String URL we get from the API
        let imgURL = NSURL(string: urlString!)
        // Get the formatted price string for display in the subtitle
        let formattedPrice = rowData["formattedPrice"] as? String
        // Download an NSData representation of the image at the URL
        let imgData = NSData(contentsOf: imgURL as! URL)
        // Get the track name
        let trackName = rowData["trackName"] as? String
        // Get the formatted price string for display in the subtitle
        cell.detailTextLabel?.text = formattedPrice
        // Update the imageView cell to use the downloaded image data
        cell.imageView?.image = UIImage(data: imgData as! Data)
        // Update the textLabel text to use the trackName from the API
        cell.textLabel?.text = trackName
        
        return cell
    }

}
