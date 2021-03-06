//
//  DetailViewController.swift
//  Flickster
//
//  Created by Edwin Young on 2/5/17.
//  Copyright © 2017 Test Org Pls Ignore. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {

	@IBOutlet weak var posterImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var overviewLabel: UILabel!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var infoView: UIView!
	
	var movie: NSDictionary!
	
    override func viewDidLoad() {
			super.viewDidLoad()

			// Do any additional setup after loading the view.
			scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
			let title = movie["title"] as! String
			let overview = movie["overview"] as! String
			
			if let posterPath = movie["poster_path"] as? String {
				let baseImgUrl = "https://image.tmdb.org/t/p/w500"
				let imgUrl = URL(string: baseImgUrl + posterPath)
				posterImageView.setImageWith(imgUrl!)
			}
			
			titleLabel.text = title
			overviewLabel.text = overview
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
