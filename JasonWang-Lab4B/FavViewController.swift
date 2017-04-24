//
//  FavViewController.swift
//  JasonWang-Lab4B
//
//  Created by J Wang on 3/8/17.
//  Copyright © 2017 J Wang. All rights reserved.
//

import Foundation
import UIKit

class FavViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var favArray:[String] = []
    
    @IBOutlet weak var favTable: UITableView!
    //ViewController for user's favorited movies
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favTable.delegate = self
        favTable.dataSource = self
        let dfault = UserDefaults.standard
        favArray = dfault.stringArray(forKey: "Faved") ?? [String]()
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let defaults = UserDefaults.standard
            self.favArray = defaults.stringArray(forKey: "Faved") ?? [String]()
            
            DispatchQueue.main.async {
                self.favTable.reloadData()
            }
        }
    }
    
    //Loads the user default saved movies to the table
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated);
        let defaults = UserDefaults.standard
        favArray = defaults.stringArray(forKey: "Faved") ?? [String]()
        self.favTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favMovie = UITableViewCell(style: .default, reuseIdentifier: nil)
        favMovie.textLabel?.text = favArray[indexPath.row]
        
        return favMovie
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            favArray.remove(at: indexPath.row)
            favTable.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.set(favArray, forKey: "Faved")
        }
    }
    
    //When table entry for a movie is clicked, segue to webViewController and shows the IMDB web page of that movie
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showIMDBPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showIMDBPage"){
            
            let indexPaths = self.favTable.indexPathsForSelectedRows
            let indexPath = indexPaths![0] as IndexPath
            
            let web = segue.destination as! WebViewController
            
            let title = self.favTable.cellForRow(at: indexPath)?.textLabel?.text
            let eTitle = title?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            
            web.urlInsert = eTitle
            
        }
    }

}
