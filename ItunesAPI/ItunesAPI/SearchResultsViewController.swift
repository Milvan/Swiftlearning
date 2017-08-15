//
//  ViewController.swift
//  ItunesAPI
//
//  Created by Marcus Larson on 11/10/16.
//  Copyright © 2016 IVaE. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIControllerProtocol{
    
    @IBOutlet var appsTableView : UITableView!
    var albums = [Album]()
    var api : APIController!
    let kCellIdentifier : String = "SearchResultCell"
    
    var imageCache = [String:UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api = APIController(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        api.searchItunesFor(searchTerm: "one direction")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didRecieveAPIResults(results: NSArray) {
        DispatchQueue.main.async(execute: {
            self.albums = Album.albumsWithJSON(results:results)
            self.appsTableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsViewController: DetailsViewController = segue.destination as? DetailsViewController{
            let albumIndex = appsTableView!.indexPathForSelectedRow!.row
            let selectedAlbum = self.albums[albumIndex]
            detailsViewController.album = selectedAlbum
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: kCellIdentifier)! as UITableViewCell)
        
        let album = self.albums[indexPath.row]
        
        cell.detailTextLabel?.text = album.price
        cell.textLabel?.text = album.title
        cell.imageView?.image = UIImage(named: "Blank52")
        
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let thumbnailURLString = album.thumbnailImageURL
        let thumbnailURL = URL(string: thumbnailURLString)!
            
        //Update the imageView cell to use the downloaded image data
                if let img = self.imageCache[thumbnailURLString]{
                    cell.imageView?.image = img
                } else {
            
                    let request:NSURLRequest = NSURLRequest(url: thumbnailURL)
                    //let mainQueue = OperationQueue.main
                    let session = URLSession.shared
                    let task = session.dataTask(with: request as URLRequest, completionHandler: {data, resoponse, error -> Void in
                        if error==nil{
                        let image = UIImage(data:data!)
                        self.imageCache[thumbnailURLString] = image
                            DispatchQueue.main.async(execute: {
                                if let cellToUpdate = tableView.cellForRow(at: indexPath) {
                                    cellToUpdate.imageView?.image = image
                                }
                            })
                        }
                    })
                    task.resume()
                }
            
        
        return cell
        
    }
    

}

