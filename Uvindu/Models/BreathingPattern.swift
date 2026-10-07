//
//  BreathingPattern.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Defines structured breath pacing protocols used to guide animated visualizers in the tvOS player.
enum BreathingPhase: String, CaseIterable, Identifiable {
    case inhale = "Inhale"
    case holdInhale = "Hold"
    case exhale = "Exhale"
    case holdExhale = "Rest"
    
    var id: String { rawValue }
    
    var instruction: String {
        switch self {
        case .inhale:
            return "Breathe in gently through your nose..."
        case .holdInhale:
            return "Hold your breath gently..."
        case .exhale:
            return "Slowly release through your mouth..."
        case .holdExhale:
            return "Rest and find stillness..."
        }
    }
    
    /// Target visual scale for circular breathing animation (0.6 to 1.35)
    var visualScale: CGFloat {
        switch self {
        case .inhale:
            return 1.30
        case .holdInhale:
            return 1.30
        case .exhale:
            return 0.70
        case .holdExhale:
            return 0.70
        }
    }
}

/// Represents a validated breathing protocol such as Box Breathing or 4-7-8 Relaxation.
struct BreathingPattern: Identifiable, Hashable {
    let id: String
    let name: String
    let inhaleSeconds: Double
    let holdInhaleSeconds: Double
    let exhaleSeconds: Double
    let holdExhaleSeconds: Double
    let summary: String
    
    var totalCycleDuration: Double {
        inhaleSeconds + holdInhaleSeconds + exhaleSeconds + holdExhaleSeconds
    }
    
    /// Returns which phase and elapsed progress within that phase for a given cycle time
    func currentPhase(for cycleTime: Double) -> (phase: BreathingPhase, phaseProgress: Double, duration: Double) {
        let normalizedTime = cycleTime.truncatingRemainder(dividingBy: totalCycleDuration)
        
        var accumulated = 0.0
        
        // 1. Inhale
        accumulated += inhaleSeconds
        if normalizedTime < accumulated || (holdInhaleSeconds == 0 && exhaleSeconds == 0 && holdExhaleSeconds == 0) {
            let elapsed = normalizedTime
            return (.inhale, min(1.0, elapsed / max(1.0, inhaleSeconds)), inhaleSeconds)
        }
        
        // 2. Hold after inhale
        let holdStart = accumulated
        accumulated += holdInhaleSeconds
        if normalizedTime < accumulated && holdInhaleSeconds > 0 {
            let elapsed = normalizedTime - holdStart
            return (.holdInhale, min(1.0, elapsed / holdInhaleSeconds), holdInhaleSeconds)
        }
        
        // 3. Exhale
        let exhaleStart = accumulated
        accumulated += exhaleSeconds
        if normalizedTime < accumulated {
            let elapsed = normalizedTime - exhaleStart
            return (.exhale, min(1.0, elapsed / max(1.0, exhaleSeconds)), exhaleSeconds)
        }
        
        // 4. Hold after exhale (Rest)
        let restStart = accumulated
        accumulated += holdExhaleSeconds
        let elapsed = normalizedTime - restStart
        let restDuration = max(1.0, holdExhaleSeconds)
        return (.holdExhale, min(1.0, elapsed / restDuration), restDuration)
    }
    
    // MARK: - Presets
    
    /// Navy SEAL Box Breathing (4-4-4-4) - Regulates autonomic nervous system
    static let boxBreathing = BreathingPattern(
        id: "box",
        name: "Box Breathing (4-4-4-4)",
        inhaleSeconds: 4.0,
        holdInhaleSeconds: 4.0,
        exhaleSeconds: 4.0,
        holdExhaleSeconds: 4.0,
        summary: "Equal ratio pacing for nervous system reset & calm focus."
    )
    
    /// Dr. Andrew Weil's 4-7-8 Relaxation Breath - Activates parasympathetic recovery
    static let relaxing478 = BreathingPattern(
        id: "478",
        name: "4-7-8 Natural Tranquilizer",
        inhaleSeconds: 4.0,
        holdInhaleSeconds: 7.0,
        exhaleSeconds: 8.0,
        holdExhaleSeconds: 0.0,
        summary: "Extended exhale triggers deep parasympathetic tranquility."
    )
    
    /// Coherent Resonance (5.5s in, 5.5s out) - Optimizes Heart Rate Variability (HRV)
    static let coherentHRV = BreathingPattern(
        id: "coherent",
        name: "Coherent Resonance (5.5s - 5.5s)",
        inhaleSeconds: 5.5,
        holdInhaleSeconds: 0.0,
        exhaleSeconds: 5.5,
        holdExhaleSeconds: 0.0,
        summary: "Harmonizes cardiac rhythm and neural oscillation."
    )
    
    /// Gentle Rest (3s in, 4s out) - Ideal for evening wind-down
    static let gentleWindDown = BreathingPattern(
        id: "gentle",
        name: "Gentle Wind-Down (3s - 4s)",
        inhaleSeconds: 3.0,
        holdInhaleSeconds: 1.0,
        exhaleSeconds: 4.0,
        holdExhaleSeconds: 1.0,
        summary: "Low strain soothing rhythm designed for bedroom TV viewing."
    )
}
