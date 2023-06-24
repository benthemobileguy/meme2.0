//
//  DetailViewController.swift
//  meme1.0
//
//  Created by Ben on 23/06/2023.
//  Copyright © 2023 Ben. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController {
    var memes: Meme2!
    @IBOutlet weak var im: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        im.image = memes.memedImage
        im.contentMode = .scaleAspectFit
        self.tabBarController?.tabBar.isHidden = true
    }
}
