//
//  CommentTableViewCell.swift
//  LambdaTimeline
//
//  Created by Daniela Parra on 11/6/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func playAudio(_ sender: Any) {
        
        
        
    }
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var audioButton: UIButton!
    
}
