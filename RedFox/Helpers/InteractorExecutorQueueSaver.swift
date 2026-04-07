//
//  AudioManager.swift
//  RedFox
//
//  Created by Илья Волощик on 13.10.25.
//


import Foundation
import AVFoundation
import Combine

class 

BuilderCacheClient: ObservableObject {
    static let shared = BuilderCacheClient()
    private let audioSetting = AdapterTaskHandlerHelper.shared
    
    private var musicPlayer: AVAudioPlayer?
    private var soundPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "Maximalism", withExtension: "mp3") else {
            return
        }
        
        let volume = audioSetting.musicVolume
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.numberOfLoops = -1
            musicPlayer?.volume = volume ? 1 : 0
            musicPlayer?.prepareToPlay()
            musicPlayer?.play()
        } catch {
            print("❌  \(error)")
        }
    }
    
    func updateMusicVolume(to volume: Bool) {
        musicPlayer?.volume = volume ? 1 : 0
    }
    
    func playSoundEffect(named name: String, withExtension: String = "wav") {
        guard let url = Bundle.main.url(forResource: name, withExtension: withExtension) else {
            return
        }
        
        let volume = audioSetting.soundVolume
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.volume = volume ? 1 : 0
            soundPlayer?.prepareToPlay()
            soundPlayer?.play()
        } catch {
            print("❌ \(error)")
        }
    }
}

struct 

OperationActionView{
    let klick = "klick"
}
