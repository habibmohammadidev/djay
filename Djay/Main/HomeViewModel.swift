//
//  HomeViewModel.swift
//  Djay
//

import AVFoundation
import Combine

class HomeViewModel {
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    @Published private var isPlaying = false
    
    @Published var frequency: Float = 440.0
    @Published var amplitude: Float = 0.5
    @Published var vibration: Float = 0.0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupAudio()
        observeChanges()
    }
    
    private var audioFormat: AVAudioFormat?
    
    private func setupAudio() {
        audioEngine.attach(playerNode)
        audioFormat = audioEngine.mainMixerNode.outputFormat(forBus: 0)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
        audioEngine.prepare()
    }
    
    private func observeChanges() {
        Publishers.CombineLatest3($frequency, $amplitude, $vibration)
            .sink { [weak self] _, _, _ in
                self?.updateSound()
            }
            .store(in: &cancellables)
    }
    
    func togglePlayback() {
        if isPlaying {
            stop()
        } else {
            start()
        }
    }
    
    private func start() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            try audioEngine.start()
            isPlaying = true
            playSound()
        } catch {
            print("Audio engine start failed: \(error)")
        }
    }
    
    private func stop() {
        playerNode.stop()
        audioEngine.stop()
        isPlaying = false
    }
    
    private func updateSound() {
        guard isPlaying else { return }
        playerNode.stop()
        playSound()
    }
    
    private func playSound() {
        guard let format = audioFormat else { return }
        
        let sampleRate = format.sampleRate
        let duration = 1.0
        let frameCount = AVAudioFrameCount(sampleRate * duration)
        
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
        
        buffer.frameLength = frameCount
        
        guard let channelData = buffer.floatChannelData?[0] else { return }
        
        let freq = Double(frequency)
        let amp = Double(amplitude)
        let vib = Double(vibration)
        
        for frame in 0..<Int(frameCount) {
            let time = Double(frame) / sampleRate
            let vibrato = sin(2.0 * .pi * vib * time) * 10.0
            channelData[frame] = Float(sin(2.0 * .pi * (freq + vibrato) * time) * amp)
        }
        
        playerNode.scheduleBuffer(buffer, at: nil, options: .loops)
        playerNode.play()
    }
}

extension HomeViewModel: AnyHomeViewModel {
    var buttonTitlePublisher: AnyPublisher<String, Never> {
        $isPlaying.map { $0 ? "Stop" : "Play" }.eraseToAnyPublisher()
    }

    var frequencyPublisher: AnyPublisher<Float, Never> {
        $frequency.eraseToAnyPublisher()
    }

    var amplitudePublisher: AnyPublisher<Float, Never> {
        $amplitude.eraseToAnyPublisher()
    }

    var vibrationPublisher: AnyPublisher<Float, Never> {
        $vibration.eraseToAnyPublisher()
    }
}
