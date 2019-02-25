//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Ranieri Aguiar on 25/02/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet var imgDetailMeme: UIImageView!
    
    var imageMeme: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgDetailMeme.image = imageMeme
    }
}
