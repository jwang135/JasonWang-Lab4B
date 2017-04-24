//
//  MovieViewController.swift
//  JasonWang-Lab4B
//
//  Created by J Wang on 3/8/17.
//  Copyright © 2017 J Wang. All rights reserved.
//

import Foundation
import UIKit

class MovieInfoViewController: UIViewController {
    
    var info: movieInfo!
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieYear: UILabel!
    
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var imdb: UILabel!
    @IBOutlet weak var faveButton: UIButton!
    
    
    //Alert Controller appears and prompts the user if he or she wants to add the movie to his or her favories

    @IBAction func addToFavourites(_ sender: UIButton) {
       
        let alertControl = UIAlertController(title: "Favorite", message: "Add Movie to Favorites List", preferredStyle: .alert)
        
        //Cancel button
        let cancelAct = UIAlertAction(title: "Cancel", style: .cancel)
        alertControl.addAction(cancelAct)
        
        //Save button
        let saveAct = UIAlertAction(title:"Add", style: .default)
        alertControl.addAction(saveAct)
        
        let toAdd = info.mName
        
        let defaults = UserDefaults.standard
        var favedArray = defaults.stringArray(forKey: "Faved") ?? [String]()
        
        if favedArray.count == 0{
            favedArray = [toAdd]
        }
        else{
            if favedArray.contains(toAdd){
                alertControl.title = "Movie Already Saved";
                alertControl.message = ""
                saveAct.isEnabled = false
            }
            else{
                favedArray.append(toAdd)
            }
        }
        
        self.present(alertControl, animated: true, completion: nil)
        defaults.set(favedArray, forKey: "Faved")
    }
    
    private func getJSON(_ url: String) -> JSON {
        if let url = URL(string: url){
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                return json
            } else {
                return JSON.null
            }
        } else {
            return JSON.null
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thisUrl = "http://www.omdbapi.com/?i=\(info.imdbID)"
        let det = getJSON(thisUrl)
        
        imageView.image = image
        movieTitle.text = info.mName
        langLabel.text = "Language: " + det["Language"].stringValue
        movieYear.text = "Released: " + det["Released"].stringValue
        imdb.text = "IMDB Rating: " + det["imdbRating"].stringValue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
