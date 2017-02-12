//
//  MoviesViewController.swift
//  Flickster
//
//  Created by Edwin Young on 1/26/17.
//  Copyright © 2017 Test Org Pls Ignore. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
	@IBOutlet weak var loadingView: UIView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var splashLoading: UIActivityIndicatorView!
	
	var movies : [NSDictionary]?
	var endpoint : String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.splashLoading.startAnimating()
		
		// Initialize a UIRefreshControl
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
		// add refresh control to table view
		tableView.insertSubview(refreshControl, at: 0)
		
		tableView.dataSource = self
		tableView.delegate = self
		
		let apiKey = "8c196c3c0b660eff61aa8b14f87d402e"
		let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")!
		let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
		let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
		let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
			if let data = data {
				if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
					print(dataDictionary)
					
					self.movies = dataDictionary["results"] as! [NSDictionary]
					self.tableView.reloadData()
					self.splashLoading.stopAnimating()
					self.loadingView.alpha = 0
				}
			}
		}
		task.resume()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let movies = movies {
			return movies.count
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
		
		let movie = movies![indexPath.row]
		let title = movie["title"] as! String
		let overview = movie["overview"] as! String
		
		cell.titleLabel.text = title
		cell.overviewLabel.text = overview
		
		if let posterPath = movie["poster_path"] as? String {
			let baseImgUrl = "https://image.tmdb.org/t/p/w500"
			let imgUrl = URL(string: baseImgUrl + posterPath)
			cell.posterView.setImageWith(imgUrl!)
			print(imgUrl?.absoluteString)
		}
		return cell
	}
	
	// Makes a network request to get updated data
	// Updates the tableView with the new data
	// Hides the RefreshControl
	func refreshControlAction(_ refreshControl: UIRefreshControl) {
		
		// ... Create the URLRequest ...
		let apiKey = "8c196c3c0b660eff61aa8b14f87d402e"
		let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
		let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
		
		// Configure session so that completion handler is executed on main UI thread
		let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
		let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
			
			// ... Use the new data to update the data source ...
			if let data = data {
				if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
					print(dataDictionary)
					
					self.movies = dataDictionary["results"] as! [NSDictionary]
					self.tableView.reloadData()
				}
			}
			
			// Reload the tableView now that there is new data
			self.tableView.reloadData()
			
			// Tell the refreshControl to stop spinning
			refreshControl.endRefreshing()
		}
		task.resume()
	}
	
	/*
		// MARK: - Navigation
	
		// In a storyboard-based application, you will often want to do a little preparation before navigation
		override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
			// Get the new view controller using segue.destinationViewController.
			// Pass the selected object to the new view controller.
		}
	*/
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let cell = sender as! UITableViewCell
		let indexPath = tableView.indexPath(for: cell)
		let movie = movies![indexPath!.row]
		
		let detailViewController = segue.destination as! DetailViewController
		detailViewController.movie = movie
		
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		
	}
	
}
