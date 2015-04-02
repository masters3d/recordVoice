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
    
    @IBAction func StopButton(sender: UIButton) {
        songAudio.stop()
    }
    
    @IBAction func FastButtonPlay(sender: UIButton) {
        songAudio.stop()
        songAudio.currentTime = 0.0
        songAudio.rate = 1.5
        songAudio.play()
    }
    
    @IBAction func SlowButtonPlay(sender: UIButton) {
        songAudio.stop()
        songAudio.currentTime = 0.0
        songAudio.rate = 0.5
        songAudio.play()
    }
    @IBAction func chipButtonPlay(sender: UIButton) {
        playAudioWithVariable(pitch: 1000)
        
    }
    
    @IBAction func darthButtonPlay(sender: UIButton) {
        playAudioWithVariable(pitch: -500)
    }
    
    @IBAction func delayButtonPlay(sender: UIButton) {
        playAudioWithVariable(delay: 50)
    }
    
    
    func playAudioWithVariable(#delay: Float ){
        songAudio.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeDelayEffect = AVAudioUnitDelay()
        changeDelayEffect.feedback = delay
        audioEngine.attachNode(changeDelayEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeDelayEffect, format: nil)
        audioEngine.connect(changeDelayEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithVariable(#pitch: Float ){
        songAudio.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        songAudio = AVAudioPlayer(contentsOfURL:recievedAudio.filePathUrl, error: nil)!
        songAudio.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)
        
        
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionRouteChangeNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                (note:NSNotification!) in
                println("change route \(note.userInfo)")
                println("current output :\(AVAudioSession.sharedInstance().currentRoute.outputs[0].UID)")
                if (AVAudioSession.sharedInstance().currentRoute.outputs[0].UID) == "Built-In Receiver" {
                    
                    AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
                    
                }
        })
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
