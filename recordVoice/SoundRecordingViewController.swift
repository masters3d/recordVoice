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

    
    @IBAction func stopButton(_ sender: UIButton) {
        stopbuttonLabel.isHidden = true
        recLabel.text = "Press to Record"
        recLabel.textColor = UIColor.black
        recButtonLabel.isEnabled = true
        audioRecorder.stop()
        _ = try? audioSession.setActive(false)

    }
    
    @IBOutlet weak var stopbuttonLabel: UIButton!
    
    @IBOutlet weak var recLabel: UILabel!
    
    @IBOutlet weak var recButtonLabel: UIButton!
    
    @IBAction func recButtonAction(_ sender: UIButton) {
        recLabel.text = "Recording"
        recLabel.textColor = UIColor.red
        recLabel.isHidden = false
        stopbuttonLabel.isHidden = false
        recButtonLabel.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] 
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        if #available(iOS 9.0, *) {
            print("\(audioSession.availableCategories)")
        } else {
            // Fallback on earlier versions
        }
        _ = try? audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)

        audioRecorder =  try? AVAudioRecorder(url:filePath! , settings: [:] )
        
//        print("\(audioRecorder)")
        audioRecorder.isMeteringEnabled = true
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
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            performSegue(withIdentifier: "StopRecordingSegue", sender: recordedAudio)
            
        }else{
            print("recording was not succesfull")
            recButtonLabel.isEnabled = true
            stopbuttonLabel.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "StopRecordingSegue"){
            
            let playSoundsVC:PlaySoundsViewControler = segue.destination as! PlaySoundsViewControler
            
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data
        }
        
    }
    
    
    
}

