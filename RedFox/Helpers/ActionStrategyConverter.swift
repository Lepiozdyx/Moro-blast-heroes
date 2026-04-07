//
//  AudioSettings.swift
//  RedFox
//
//  Created by Илья Волощик on 13.10.25.
//


import Foundation
import Combine

class 

AdapterTaskHandlerHelper: ObservableObject {
    static let shared = AdapterTaskHandlerHelper()
    
    @Published var musicVolume: Bool {
        didSet {
            UserDefaults.standard.set(musicVolume, forKey: "musicVolume")
            BuilderCacheClient.shared.updateMusicVolume(to: musicVolume)
        }
    }
    
    @Published var soundVolume: Bool {
        didSet {
            UserDefaults.standard.set(soundVolume, forKey: "soundVolume")
        }
    }
    
    private init() {
        self.musicVolume = UserDefaults.standard.object(forKey: "musicVolume") as? Bool ?? true
        self.soundVolume = UserDefaults.standard.object(forKey: "soundVolume") as? Bool ?? true
    }
}
