//
//  ApiController.swift
//  ItunesAPI
//
//  Created by Marcus Larson on 12/10/16.
//  Copyright © 2016 IVaE. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didRecieveAPIResults(results :NSArray)
}

class APIController {
    
    var delegate: APIControllerProtocol
    
    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    
    func get(path: String){
        let url = URL(string: path)
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
                    self.delegate.didRecieveAPIResults(results: results)
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
    
func searchItunesFor(searchTerm: String){
    // Itunes wants multiple terms separated by +, so replace " " with "+"
    let itunesSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+")
    
    // Now escape anything else that isn't URL-friendly
    let escapedSearchTerm = itunesSearchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed )
    let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm!)&media=music&entity=album"
    get(path: urlPath)
    
    
}
}
