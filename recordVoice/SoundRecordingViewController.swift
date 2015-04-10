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
    
    @IBAction func stopButton(sender: UIButton) {
        stopbuttonLabel.hidden = true
        recLabel.text = "Press to Record"
        recLabel.textColor = UIColor.blackColor()
        recButtonLabel.enabled = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
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
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
        audioRecorder.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            
            
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("StopRecordingSegue", sender: recordedAudio)
            
        }else{
            println("recording was not succesfull")
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

