//
//  meme1.swift
//  meme1.0
//
//  Created by Ben on 23/06/2023.
//  Copyright © 2023 Ben. All rights reserved.
//

import UIKit
import Foundation

struct Meme2 {
    let top: String
    let bottom: String
    let image: UIImage
    let memedImage: UIImage
    init(topText: String!, bottomText: String!, image: UIImage!, memedImage: UIImage!) {
        self.top = topText
        self.bottom = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}
