//
//  FavoriteViewCell.swift
//  VideoLibrary
//
//  Created by MIMO on 12/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

import UIKit
import UICircularProgressRing

class FavoriteViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var voteAverage: UICircularProgressRingView!
}
