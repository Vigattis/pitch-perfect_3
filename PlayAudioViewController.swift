//
//  PlayAudioViewController.swift
//  PitchMyVoice
//
//  Created by Aras Senova on 2015-05-16.
//  Copyright (c) 2015 Aras Senova. All rights reserved.
//

import UIKit
import AVFoundation

class PlayAudioViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
        stopAllAudio()
        Stops the audioplayer engine, resets it. Stops the audioplayer and makes the
       timer value equal the initial starting point of the audio file.
    */
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        stopAllAudio()
    }
    
    /*
        playSpeedMultiplier(speed: Float)
        Plays the recorded audio file with given speed multiplier
    */
    func playSpeedMultiplier(speed: Float) {
        audioPlayer.rate = speed
        audioPlayer.play()
    }
    /*
        playSlow(sender: UIButton)
        Plays the recorded audio file with the rate of 0.5 (Half the speed)
    */
    @IBAction func playSlow(sender: UIButton) {
        stopAllAudio()
        playSpeedMultiplier(0.5)
    }
    
    /*
        playFast(sender: UIButton)
        Plays the recorded audio file with the rate of 2.0 (2 times quicker)
    */
    @IBAction func playFast(sender: UIButton) {
        stopAllAudio()
        playSpeedMultiplier(2.0)
    }
    
    /*
        playChipmunkAudio(sender: UIButton)
        Uses the "playAudioWithVariablePitch" function, giving the value of 1000
       as the pitch level, in order to mimic chipmunk sound.
    */
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    /*
        darthVaderAudio(sender: UIButton)
        Uses the "playAudioWithVariablePitch" function, giving the value of -1000
       as the pitch level, in order to mimic Darth Vader sound.
    */
    @IBAction func darthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    /*
        playAudioWithVariablePitch(pitch: Float)
        This function is used to play the recorded audio with different than regular
       pitch. Gets the pitch value as a variable.
    */
    func playAudioWithVariablePitch(pitch: Float) {
        stopAllAudio()
        
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
    /*
        echoAudio(sender: UIButton)
        This function is used to play the audio with specified delay time (causing echo
       with the specified time interval) and specified wet blend percentage.
    */
    func playAudioVariedWetDryMixAndDelay(wetDryMix: Float, delay: NSTimeInterval) {
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        var unitReverb = AVAudioUnitReverb()
        unitReverb.wetDryMix = wetDryMix
        var unitDelay = AVAudioUnitDelay()
        unitDelay.delayTime = delay
        audioEngine.attachNode(unitReverb)
        audioEngine.attachNode(unitDelay)
        
        audioEngine.connect(audioPlayerNode, to: unitReverb, format: nil)
        audioEngine.connect(unitReverb, to: unitDelay, format: nil)
        audioEngine.connect(unitDelay, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    /*
        reverbAudio(sender: UIButton)
        This function is used to play the recorded audio file with wet blend percentage
       of 99.5.
    */
    @IBAction func reverbAudio(sender: UIButton) {
        stopAllAudio()
        
        playAudioVariedWetDryMixAndDelay(99.5, delay: 0)
    }
    
    /*
        echoAudio(sender: UIButton)
        This function is used to play the same audio record on top of the previous one
       with decreased volume starting one second after, in order to mimic echoing behaviour.
       Continues to play one after another each having one second in between until the 
       decreased volume is negligibly silent.
    */
    @IBAction func echoAudio(sender: UIButton) {
        stopAllAudio()
        
        playAudioVariedWetDryMixAndDelay(0, delay: 1.0)
    }
}
