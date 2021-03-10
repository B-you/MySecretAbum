//
//  AssetCollectionViewCell.swift
//  SecretAlbum
//
//  Created by 100 on 05.03.2021.
//

import UIKit

class AssetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
}



class PhotoVideoCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var starBtn: UIImageView!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
}
