//
//  RecordAudioViewController.swift
//  PitchMyVoice
//
//  Created by Aras Senova on 2015-05-14.
//  Copyright (c) 2015 Aras Senova. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var resumeInactive: UIButton!
    @IBOutlet weak var pauseInactive: UIButton!
    @IBOutlet weak var pauseActive: UIButton!
    @IBOutlet weak var resumeActive: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        pauseActive.hidden = true
        resumeActive.hidden = true
        pauseInactive.hidden = false
        resumeInactive.hidden = false
        stopButton.hidden = true
        microphoneButton.enabled = true
        recordingLabel.text = "Tap to record"
    }

    /*
        audioRecord(sender: UIButton)    
        This function is used to start recording the audio file. It sets the name to current date and time 
       in order to prevent same named file and keep track of records.
    */
    @IBAction func audioRecord(sender: UIButton) {
        println("Nabun")
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        pauseInactive.hidden = true
        resumeInactive.hidden = false
        resumeActive.hidden = true
        pauseActive.hidden = false
        
        recordingLabel.text = "Recording..."
        
        microphoneButton.enabled = false
        stopButton.hidden = false
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        audioRecorder.pause()
        resumeActive.hidden = false
        pauseActive.hidden = true
        pauseInactive.hidden = false
        recordingLabel.text = "Paused"
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        audioRecorder.record()
        resumeActive.hidden = true
        resumeInactive.hidden = false
        pauseInactive.hidden = true
        pauseActive.hidden = false
        recordingLabel.text = "Recording..."
    }
    
    /*
        audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool)
        This function is used to send the readied (in prepareForSegue function below) data and slide to the
       next screen.
    */
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Recording was not successful")
            stopButton.hidden = true
            microphoneButton.enabled = true
            recordingLabel.text = "Tap to record"
        }
    }
    
    /*
        prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
        This function prepares the audio file to be sent with the segue operation.
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playAudioVC:PlayAudioViewController = segue.destinationViewController as! PlayAudioViewController
            let data = sender as! RecordedAudio
            playAudioVC.receivedAudio = data
        }
    }
    
    /*
        stopRecord(sender: UIButton)
        This function is triggered by pressing the stop button. It stops recording of the audio file and 
       triggers the changing of the screen to the playback screen.
    */
    @IBAction func stopRecord(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        stopButton.hidden = true
    }
}
