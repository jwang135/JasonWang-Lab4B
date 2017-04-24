//
//  SearchViewController.swift
//  JasonWang-Lab4B
//
//  Created by J Wang on 3/9/17.
//  Copyright © 2017 J Wang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollection: UICollectionView!
    @IBOutlet weak var activityWheel: UIActivityIndicatorView!
    @IBOutlet weak var nothingThere: UIImageView!
    
    var movieStore: [movieInfo] = []
    var imageStore: [UIImage] = []
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let movieString = searchBar.text
        let editString = movieString?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let search1 = "http://www.omdbapi.com/?s=\(editString!)&page=1"
        let search2 = "http://www.omdbapi.com/?s=\(editString!)&page=2"
        let search3 = "http://www.omdbapi.com/?s=\(editString!)&page=3"
        
        self.nothingThere.isHidden = true
        movieCollection.reloadData()

        movieStore.removeAll()
        imageStore.removeAll()
        
        
        self.activityWheel.startAnimating()
        self.activityWheel.isHidden = false
        
        DispatchQueue.global(qos: .userInitiated).async {
            //Search is done in background, while activity wheel is running
            self.getMovieInfo(search1)
            self.getMovieInfo(search2)
            self.getMovieInfo(search3)
            self.storeImages()
            
            DispatchQueue.main.async {
                
                self.movieCollection.reloadData()
                //After done loading you stop animation
                self.activityWheel.stopAnimating()
                self.activityWheel.isHidden = true
                
                //If no results are available the nothingThere picture is shown
                if self.movieStore.isEmpty{

                    self.nothingThere.isHidden = false
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieStore.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    //Sets the movie poster and movie name to each Collection cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! SearchViewCell
        
        if(imageStore.isEmpty && movieStore.isEmpty){
            
           return cell
        }
        else{
            
            let poster:UIImage = imageStore[indexPath.row]
            
            //Sets movie poster to cell image
            cell.movieImage.image = poster
            
            //Sets title of movie to cell label
            cell.movieTitle.text = movieStore[indexPath.row].mName
            
            return cell
        }
    }
    
    //Segue And Load Appropriate Info for Individual Movies
    func collectionView(_ collectionView:
        UICollectionView, didSelectItemAt indexPath: IndexPath) {
         self.performSegue(withIdentifier: "showMovieInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showMovieInfo"){
            let indexPaths = self.movieCollection.indexPathsForSelectedItems
            let indexPath = indexPaths![0] as IndexPath
            
            let infoView = segue.destination as! MovieInfoViewController
            
            infoView.info = movieStore[indexPath.row]
            infoView.image = imageStore[indexPath.row]
            infoView.title = self.movieStore[indexPath.row].mName
        }
    }
    
    //get JSON Info
    //getMovieInfo appends JSON results to movieStore Array

    private func getMovieInfo(_ url: String) {
        
        let jsonInfo = getJSON(url)
        
        for result in jsonInfo["Search"].arrayValue {
            let title = result["Title"].stringValue
            let rate = result["imdbRating"].floatValue
            let id = result["imdbID"].stringValue
            let url = result["Poster"].stringValue
            let date = result["Released"].stringValue
            let language = result["Language"].stringValue
            movieStore.append(movieInfo(mName: title, imdbRate: rate, imgPost: url, imdbID: id, release: date, lang: language))
        }
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
    
    //Stores images in an array and if there's no image for a movie then
    //the no-image-found.jpg is appended for that movie
    
    private func storeImages() {
        for mov in movieStore {
            let movImg = URL(string: mov.imgPost)
            let data = try? Data(contentsOf: movImg!)
            if (data == nil){
                let image = UIImage?(#imageLiteral(resourceName: "no-image-found.png"))
                imageStore.append(image!)
            }
            else{
                let image = UIImage(data: data!)
                imageStore.append(image!)
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let scnSize = UIScreen.main.bounds
        let scnWidth = scnSize.width
        let scnHeight = scnSize.height
        
        //Sets boundaries for the collection view
        
        let format: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        format.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 10)
        format.itemSize = CGSize(width: scnWidth / 3.5, height: scnHeight / 5.0)
        
        movieCollection.dataSource = self
        movieCollection.delegate = self
        searchBar.delegate = self
        movieCollection.collectionViewLayout = format
        
        
        self.view.addSubview(self.activityWheel)
        self.activityWheel.startAnimating()
        self.activityWheel.isHidden = true
        
        
        self.view.addSubview(nothingThere)
        self.nothingThere.isHidden = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.storeImages()
            
            DispatchQueue.main.async {
                self.movieCollection.reloadData()
                //reloadData() must finish and then activity wheel will disappear
                self.activityWheel.isHidden = true
                self.activityWheel.stopAnimating()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
