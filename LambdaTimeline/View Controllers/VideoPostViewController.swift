//
//  VideoPostViewController.swift
//  LambdaTimeline
//
//  Created by Daniela Parra on 11/7/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class VideoPostViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureSession = AVCaptureSession()
        let cameraDevice = bestCamera()
        
        guard let microphone = AVCaptureDevice.default(.builtInMicrophone, for: .audio, position: .unspecified),
            let audioDeviceInput = try? AVCaptureDeviceInput(device: microphone),
            captureSession.canAddInput(audioDeviceInput) else { fatalError()}
        
        captureSession.addInput(audioDeviceInput)
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice), captureSession.canAddInput(videoDeviceInput) else { fatalError("")}
        
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        guard captureSession.canAddOutput(fileOutput) else { fatalError() }
        captureSession.addOutput(fileOutput)
        
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        recordingOutput = fileOutput
        self.captureSession = captureSession
        
        previewView.videoPreviewLayer.session = captureSession
    }
    
    @IBAction func record(_ sender: Any) {
        if recordingOutput.isRecording {
            recordingOutput.stopRecording()
        } else {
            recordingOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    @IBAction func playVideo(_ sender: Any) {
        guard let videoURL = videoURL else { return }
        
        defer { updateButtons() }
        
        guard !isPlaying else {
            player?.pause()
            isPlaying = false
            return
        }
        
        if  player != nil && !isPlaying {
            player?.play()
            isPlaying = true
            return
        }
        
        player = AVPlayer(url: videoURL)
        playerView.player = player
        player?.play()
        isPlaying = true
    }
    
    @IBAction func postVideo(_ sender: Any) {
        
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateButtons()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.updateButtons()
            self.previewView.isHidden = true
//            self.recordButton.isHidden = true
            self.videoURL = outputFileURL
            self.playerView.isHidden = false
        }
    
    }
    
    // MARK: - Private
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            fatalError("Missing back camera device")
        }
        
    }
    
    private func updateButtons() {
        guard isViewLoaded else { return }
        
        let isRecording = recordingOutput.isRecording
        let recordButtonImageTitle = isRecording ? "Stop" : "Record"
        let image = UIImage(named: recordButtonImageTitle)
        recordButton.setImage(image, for: .normal)
        
        let isPlaying = self.isPlaying
        let playButtonImageTitle = isPlaying ? "pause" : "play"
        let image2 = UIImage(named: playButtonImageTitle)
        playButton.setImage(image2, for: .normal)
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    // MARK: - Properties
    
    var captureSession: AVCaptureSession!
    var recordingOutput: AVCaptureMovieFileOutput!
    private var videoURL: URL?
    private var player: AVPlayer?
    private var isPlaying: Bool = false
    
    
    @IBOutlet weak var previewView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playerView: PlayerView!
    
}
