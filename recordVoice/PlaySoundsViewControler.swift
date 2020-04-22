//
//  PlaySoundsViewControler.swift
//  recordVoice
//
//  Created by masters3d on 11/24/14.
//  Copyright (c) 2014 masters3d. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewControler: UIViewController {
    
    var songAudio:AVAudioPlayer!
    var recievedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBAction func StopButton(_ sender: UIButton) {
        stopAllAudio()
    }
    
    @IBAction func FastButtonPlay(_ sender: UIButton) {
        stopAllAudio()
        songAudio.currentTime = 0.0
        songAudio.rate = 1.5
        songAudio.play()
    }
    
    @IBAction func SlowButtonPlay(_ sender: UIButton) {
        stopAllAudio()
        songAudio.currentTime = 0.0
        songAudio.rate = 0.5
        songAudio.play()
    }
    
    @IBAction func chipButtonPlay(_ sender: UIButton) {
        playAudioWithVariable(pitch: 1000)
    }
    
    @IBAction func darthButtonPlay(_ sender: UIButton) {
        playAudioWithVariable(pitch: -500)
    }
    
    @IBAction func delayButtonPlay(_ sender: UIButton) {
        playAudioWithVariable(delay: 50)
    }
    
    func stopAllAudio(){
        songAudio.stop()
        audioEngine.stop()
    }
    
    func playAudioEffect(_ changeEffect:AVAudioNode){
        stopAllAudio()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(changeEffect)
        audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
        audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        
        _ = try? audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func playAudioWithVariable(delay: Float ){
            let changeEffect = AVAudioUnitDelay()
            changeEffect.feedback = delay
            playAudioEffect(changeEffect)
    }
    
    func playAudioWithVariable(pitch: Float ){
            let changeEffect = AVAudioUnitTimePitch()
            changeEffect.pitch = pitch
            playAudioEffect(changeEffect)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songAudio = try? AVAudioPlayer(contentsOf:recievedAudio.filePathUrl as URL)
        songAudio.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: recievedAudio.filePathUrl as URL)
        
        NotificationCenter.default.addObserver(
            forName: AVAudioSession.routeChangeNotification, object: nil, queue: OperationQueue.main, using: {
                (note:Notification) in
                print("change route \(String(describing: (note as NSNotification).userInfo ))")
                print("current output :\(AVAudioSession.sharedInstance().currentRoute.outputs[0].uid)")
                if (AVAudioSession.sharedInstance().currentRoute.outputs[0].uid) == "Built-In Receiver" {
                    do {
                        try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                    } catch _ {
                    }
                }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
