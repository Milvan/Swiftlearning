//
//  DetailsViewController.swift
//  ItunesAPI
//
//  Created by Marcus Larson on 16/10/16.
//  Copyright © 2016 IVaE. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var album: Album?
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tracksTableView: UITableView!
    
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.album?.title  ?? "Failed"
        self.albumCover.image = UIImage(data: NSData(contentsOf: NSURL(string: self.album!.largeImageURL) as! URL) as! Data)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
        return UITableViewCell()
        
    }
}
