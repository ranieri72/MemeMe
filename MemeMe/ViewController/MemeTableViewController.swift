//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Ranieri Aguiar on 14/02/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath)
        
        let meme = memes[indexPath.row]
        cell.textLabel?.text = meme.textTop
        cell.detailTextLabel?.text = meme.textBottom
        cell.imageView?.image = meme.memedImage
        return cell
    }
}
