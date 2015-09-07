//
//  SoundRecordingViewController.swift
//  recordVoice
//
//  Created by masters3d on 11/23/14.
//  Copyright (c) 2014 masters3d. All rights reserved.
//

import UIKit
import AVFoundation


class SoundRecordingViewController: UIViewController,AVAudioRecorderDelegate{
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    let audioSession = AVAudioSession.sharedInstance()

    
    @IBAction func stopButton(sender: UIButton) {
        stopbuttonLabel.hidden = true
        recLabel.text = "Press to Record"
        recLabel.textColor = UIColor.blackColor()
        recButtonLabel.enabled = true
        audioRecorder.stop()
        try? audioSession.setActive(false)

    }
    
    @IBOutlet weak var stopbuttonLabel: UIButton!
    
    @IBOutlet weak var recLabel: UILabel!
    
    @IBOutlet weak var recButtonLabel: UIButton!
    
    @IBAction func recButtonAction(sender: UIButton) {
        recLabel.text = "Recording"
        recLabel.textColor = UIColor.redColor()
        recLabel.hidden = false
        stopbuttonLabel.hidden = false
        recButtonLabel.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        if #available(iOS 9.0, *) {
            print("\(audioSession.availableCategories)")
        } else {
            // Fallback on earlier versions
        }
        try? audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)

        audioRecorder =  try? AVAudioRecorder(URL:filePath! , settings: [:] )
        
//        print("\(audioRecorder)")
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.record()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            performSegueWithIdentifier("StopRecordingSegue", sender: recordedAudio)
            
        }else{
            print("recording was not succesfull")
            recButtonLabel.enabled = true
            stopbuttonLabel.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "StopRecordingSegue"){
            
            let playSoundsVC:PlaySoundsViewControler = segue.destinationViewController as! PlaySoundsViewControler
            
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data
        }
        
    }
    
    
    
}

