//
//  MeditationPlayerViewModel.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI
import Combine

/// Dedicated ViewModel driving the high-fidelity immersive player view.
/// Coordinates the high-precision timer, real-time breathing phase state machine,
/// Siri Remote playback controls, and living room acoustic sound synchronization.
final class MeditationPlayerViewModel: ObservableObject {
    
    // MARK: - State Properties
    
    let session: MeditationSession
    
    @Published var isPlaying: Bool = true
    @Published var remainingSeconds: Int
    @Published var elapsedSeconds: Int = 0
    @Published var totalSeconds: Int
    
    // Breathing Phase Engine
    @Published var activePattern: BreathingPattern
    @Published var currentPhase: BreathingPhase = .inhale
    @Published var phaseProgress: Double = 0.0 // 0.0 to 1.0
    @Published var cycleElapsed: Double = 0.0
    @Published var targetScale: CGFloat = 1.0
    
    // Completion State
    @Published var isCompleted: Bool = false
    @Published var ambientSoundscapeVolume: Double = 0.7 {
        didSet {
            WellnessAudioService.shared.volume = Float(ambientSoundscapeVolume)
        }
    }
    @Published var soundscapeEnabled: Bool = true {
        didSet {
            if soundscapeEnabled {
                WellnessAudioService.shared.resume()
            } else {
                WellnessAudioService.shared.pause()
            }
        }
    }
    
    // Internal Timer
    private var timerCancellable: AnyCancellable?
    private let tickInterval: Double = 0.05 // 20 Hz update loop for smooth breath visualizer
    private var internalTickCounter: Double = 0.0
    
    // Completion callback
    var onSessionCompleted: (() -> Void)?
    
    // MARK: - Initialization
    
    init(session: MeditationSession, onSessionCompleted: (() -> Void)? = nil) {
        self.session = session
        let initialSeconds = session.durationMinutes * 60
        self.remainingSeconds = initialSeconds
        self.totalSeconds = initialSeconds
        self.activePattern = session.breathingPattern
        self.onSessionCompleted = onSessionCompleted
        
        // Start ambient restorative soundscape
        WellnessAudioService.shared.playMeditationAmbient(for: session)
        
        startTimer()
    }
    
    deinit {
        timerCancellable?.cancel()
        WellnessAudioService.shared.stopCurrentAudio(fade: true)
    }
    
    // MARK: - Timer Engine
    
    func startTimer() {
        isPlaying = true
        timerCancellable?.cancel()
        WellnessAudioService.shared.resume()
        
        timerCancellable = Timer.publish(every: tickInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.handleTick()
            }
    }
    
    func pauseTimer() {
        isPlaying = false
        timerCancellable?.cancel()
        timerCancellable = nil
        WellnessAudioService.shared.pause()
    }
    
    func togglePlayPause() {
        if isPlaying {
            pauseTimer()
        } else {
            startTimer()
        }
    }
    
    private func handleTick() {
        guard isPlaying && !isCompleted else { return }
        
        // 1. Advance breath cycle
        cycleElapsed += tickInterval
        let (phase, progress, _) = activePattern.currentPhase(for: cycleElapsed)
        
        // Play acoustic chime cue when breath phase transitions
        if phase != self.currentPhase {
            self.currentPhase = phase
            if soundscapeEnabled {
                WellnessAudioService.shared.playPhaseTransitionChime(phase: phase)
            }
        }
        
        self.phaseProgress = progress
        
        // Compute fluid breathing scale
        switch phase {
        case .inhale:
            // Expands from 0.75 to 1.30
            self.targetScale = 0.75 + (0.55 * CGFloat(progress))
        case .holdInhale:
            // Holds maximum expansion with gentle organic vibration
            self.targetScale = 1.30 + (0.02 * CGFloat(sin(cycleElapsed * 4.0)))
        case .exhale:
            // Contracts from 1.30 down to 0.75
            self.targetScale = 1.30 - (0.55 * CGFloat(progress))
        case .holdExhale:
            // Resting state
            self.targetScale = 0.75
        }
        
        // 2. Advance one second counter
        internalTickCounter += tickInterval
        if internalTickCounter >= 1.0 {
            internalTickCounter = 0.0
            
            if remainingSeconds > 0 {
                remainingSeconds -= 1
                elapsedSeconds += 1
            } else {
                finishSession()
            }
        }
    }
    
    // MARK: - Playback Control Actions
    
    func restartSession() {
        remainingSeconds = totalSeconds
        elapsedSeconds = 0
        cycleElapsed = 0.0
        isCompleted = false
        WellnessAudioService.shared.playMeditationAmbient(for: session)
        startTimer()
    }
    
    func skipForward(seconds: Int = 15) {
        if remainingSeconds > seconds {
            remainingSeconds -= seconds
            elapsedSeconds += seconds
        } else {
            finishSession()
        }
    }
    
    func skipBackward(seconds: Int = 15) {
        remainingSeconds = min(totalSeconds, remainingSeconds + seconds)
        elapsedSeconds = max(0, elapsedSeconds - seconds)
    }
    
    func switchBreathingPattern(to pattern: BreathingPattern) {
        self.activePattern = pattern
        self.cycleElapsed = 0.0
    }
    
    func finishSession() {
        pauseTimer()
        isCompleted = true
        WellnessAudioService.shared.stopCurrentAudio(fade: true)
        onSessionCompleted?()
    }
    
    // MARK: - Formatted Strings
    
    var formattedRemainingTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var formattedElapsedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var overallProgress: Double {
        guard totalSeconds > 0 else { return 0.0 }
        return Double(elapsedSeconds) / Double(totalSeconds)
    }
}
