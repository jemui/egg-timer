//
//  ViewController.swift
//  EggTimer
//
//  Created by Jeanette on 1/22/25.
//  

import UIKit
import AVFoundation

@MainActor
class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressBar.progress = 0.0
    }
    
    //in minutes
    let eggTimes: [String:Int] = ["Soft": 5,
                    "Medium": 7,
                    "Hard": 12]
    
    @IBOutlet weak var progressBar: UIProgressView!

    weak var timer: Timer?
    var player: AVAudioPlayer?
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        guard let hardness = sender.titleLabel?.text else { return }
        guard let numberTime = eggTimes[hardness] else { return }
        startTimer(from: numberTime)
 
    }
    
    func startTimer(from time: Int) {
        if timer != nil {
            timer?.invalidate()
        }
        progressBar.progress = 0
        
        //convert to seconds
        var time = time * 60
        let totalTime: Float = Float(time)
        var progress: Float = 0.0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            Task { @MainActor in
                guard let self = self else { return }
                if time > 0 {
                    time -= 1
                    progress += 1
                    
                    self.progressBar.progress = Float(progress/totalTime)
                    
                }
                else {
                    guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else {return}
                                           do {
                        self.player = try AVAudioPlayer(contentsOf: url)
                        guard let audioPlayer = self.player else { return }
                        audioPlayer.play()
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                    
                }
            }
        }
 
    }
}
