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
    
    let segueIdentifier = "detailSegueFromTable"
    var appDelegate: AppDelegate!
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memes = appDelegate.memes
        tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        performSegue(withIdentifier: segueIdentifier, sender: meme)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let view = segue.destination as! MemeDetailViewController
            if let meme = sender as? Meme {
                let image = meme.memedImage
                view.imageMeme = image
            }
        }
    }
}
