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
    
    enum EffectEnum{
        case delay
        case pitch
    }
    
    func playAudioEffect(#input:EffectEnum, value:Float){
        stopAllAudio()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeEffect = AVAudioNode()
        
        func delay()->AVAudioUnitDelay{
            var changeEffect = AVAudioUnitDelay()
            changeEffect.feedback = value
            return changeEffect
        }
        
        func pitch()->AVAudioUnitTimePitch{
            var changeEffect = AVAudioUnitTimePitch()
            changeEffect.pitch = value
            return changeEffect
        }
        
        switch input {
        case .delay : changeEffect = delay()
        case .pitch : changeEffect = pitch()
        }
        
        audioEngine.attachNode(changeEffect)
        audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
        audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    
    func playAudioWithVariable(#delay: Float ){
        playAudioEffect(input: EffectEnum.delay, value: delay)
    }
    func playAudioWithVariable(#pitch: Float ){
        playAudioEffect(input: EffectEnum.pitch, value: pitch)
        
    }
    
    //  Is called funccion overloading. Did I want to abstract the AVAudioPlayerNodes? no. Why? because is just two effects. Is the code above any better than the code below? I dont think so. If anythinbg the below code is easier to reason with, easier to read. Sure there is some duplicate code but the code above is longer and more complicated. Why add more complication to the code if is never going to be extended? Now If I was going to do 4+ effects then it makes sences to get rid of ducplication.
    
    //    func playAudioWithVariable(#delay: Float ){
    //        stopAllAudio()
    //        audioEngine.reset()
    //        var audioPlayerNode = AVAudioPlayerNode()
    //        audioEngine.attachNode(audioPlayerNode)
    //        var changeDelayEffect = AVAudioUnitDelay()
    //        changeDelayEffect.feedback = delay
    //        audioEngine.attachNode(changeDelayEffect)
    //        audioEngine.connect(audioPlayerNode, to: changeDelayEffect, format: nil)
    //        audioEngine.connect(changeDelayEffect, to: audioEngine.outputNode, format: nil)
    //        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    //        audioEngine.startAndReturnError(nil)
    //        audioPlayerNode.play()
    //    }
    //
    //    func playAudioWithVariable(#pitch: Float ){
    //        stopAllAudio()
    //        audioEngine.reset()
    //        var audioPlayerNode = AVAudioPlayerNode()
    //        audioEngine.attachNode(audioPlayerNode)
    //        var changePitchEffect = AVAudioUnitTimePitch()
    //        changePitchEffect.pitch = pitch
    //        audioEngine.attachNode(changePitchEffect)
    //        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
    //        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    //        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    //        audioEngine.startAndReturnError(nil)
    //        audioPlayerNode.play()
    //    }
    
    
    
    
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
