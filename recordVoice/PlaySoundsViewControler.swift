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
        stopAllAudio()
    }
    
    @IBAction func FastButtonPlay(sender: UIButton) {
        stopAllAudio()
        songAudio.currentTime = 0.0
        songAudio.rate = 1.5
        songAudio.play()
    }
    
    @IBAction func SlowButtonPlay(sender: UIButton) {
        stopAllAudio()
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
    
    func stopAllAudio(){
        songAudio.stop()
        audioEngine.stop()
    }
    
    func playAudioEffect(changeEffect:AVAudioNode){
        stopAllAudio()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(changeEffect)
        audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
        audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func playAudioWithVariable(#delay: Float ){
            var changeEffect = AVAudioUnitDelay()
            changeEffect.feedback = delay
            playAudioEffect(changeEffect)
    }
    
    func playAudioWithVariable(#pitch: Float ){
            var changeEffect = AVAudioUnitTimePitch()
            changeEffect.pitch = pitch
            playAudioEffect(changeEffect)
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
