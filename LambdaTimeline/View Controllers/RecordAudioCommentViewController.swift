//
//  RecordAudioCommentViewController.swift
//  LambdaTimeline
//
//  Created by Daniela Parra on 11/6/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioCommentViewController: UIViewController {

    
    

    // MARK: - Properties
    
    private var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    
    private var player: AVAudioPlayer?
    private var recorder: AVAudioRecorder?
    var recordingURL: URL?

}
