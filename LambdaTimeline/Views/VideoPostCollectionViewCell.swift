//
//  VideoPostCollectionViewCell.swift
//  LambdaTimeline
//
//  Created by Daniela Parra on 11/8/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPostCollectionViewCell: UICollectionViewCell {
    
    func updateViews() {
        guard let post = post else { return }
        
        titleLabel.text = post.title
        authorLabel.text = post.author.displayName
    }
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playerView: PlayerView!
}
