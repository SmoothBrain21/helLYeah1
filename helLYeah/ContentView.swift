//
//  ContentView.swift
//  helLYeah
//
//  Created by Nathan LaBar on 2/21/25.
//

import SwiftUI
import AVFoundation


class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private var audioPlayer: AVAudioPlayer?
    
    private init() { configureAudioSession() }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error configuring audio session: \(error.localizedDescription)")
        }
    }
    
    func playSound(named fileName: String, fileType: String = "m4a") {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
                print("Audio file \(fileName).\(fileType) not found")
                return
            }
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                DispatchQueue.main.async {
                    self.audioPlayer = player
                    self.audioPlayer?.play()
                }
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
}

// Preload colors in a dictionary
let colorDict: [String: Color] = [
    "KevinJames": .red, "AlexJonesBeiber": .blue, "OptimusPrime": .green, "Dodgeball": .orange,
    "Oooahah": Color(red: 0.4627, green: 0.8392, blue: 1.0), "HomeDepot": Color(red: 0.8627, green: 0.2, blue: 0.6),
    "AndrewSword": .black, "CreamCrop": .white, "Bane": .yellow, "Tyson": Color(red: 0.0, green: 0.7, blue: 0.6), "sw" : Color(red: 0.999, green: 0.7, blue: 0.645), "RocketFuel": Color(red: 0.0, green: 0.3, blue: 0.6), "KingKong" : Color(red: 0.335, green: 0.25, blue: 0.645)
]

struct ContentView: View {
    @StateObject private var audioManager = AudioManager.shared
    
    let sounds = [
        "KevinJames", "AlexJonesBeiber", "OptimusPrime", "Dodgeball",
        "Oooahah", "HomeDepot", "AndrewSword", "CreamCrop",
        "Bane", "Tyson", "KingKong", "RocketFuel"
    ]
    
    var body: some View {
        ZStack {
            // Background Image
            Image("DINOSAUR")
                .resizable()
                .scaleEffect(x: 1.9, y: 1.0)
                .opacity(0.7)
                .offset(x: -100)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                        ForEach(sounds, id: \.self) { sound in
                            Button(action: { audioManager.playSound(named: sound) }) {
                                Circle()
                                    .fill(colorDict[sound] ?? .gray)  // Use preloaded colors
                                    .frame(width: 90, height: 90)
                                    .shadow(radius: 5)
                                    .opacity(0.7)
                                
                            }
                        }
                    }
                    .padding()
                }
                
                // "HELL YEAH" Button
                
                    Button(action: playRandomSound) {
                        Text("HELL YEAH")
                            .font(.largeTitle)
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding()
                            .frame(width: 250, height: 80)
                            .background(Color.black.opacity(0.75))
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.red, lineWidth: 4)
                            )
                    }
                    .offset(y: -190)
                
            }
            .offset(y: 200)
        }
    }
    
    // Function to play a random sound
    func playRandomSound() {
        let unplayedSounds = sounds.shuffled()
        if let randomSound = unplayedSounds.first {
            audioManager.playSound(named: randomSound)
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
