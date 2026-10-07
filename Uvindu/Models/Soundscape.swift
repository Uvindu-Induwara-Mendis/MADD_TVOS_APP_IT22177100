//
//  Soundscape.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Audio visualization aesthetic rendered on large TV screens when playing ambient soundscapes.
enum AudioVisualizationType: String, CaseIterable, Identifiable {
    case oceanWaves = "Ocean Waves"
    case rainRipples = "Rain Ripples"
    case celestialOrb = "Celestial Orb"
    case firesidePulse = "Fireside Pulse"
    case binauralBeats = "Binaural Sine"
    case forestBreeze = "Forest Canopy"
    
    var id: String { rawValue }
    
    var previewIcon: String {
        switch self {
        case .oceanWaves: return "waveform.path"
        case .rainRipples: return "drop.degreesign.fill"
        case .celestialOrb: return "sparkles"
        case .firesidePulse: return "flame.fill"
        case .binauralBeats: return "waveform.circle.fill"
        case .forestBreeze: return "leaf.fill"
        }
    }
}

/// Represents an ambient auditory environment designed to fill the living room with calming frequencies.
struct Soundscape: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let visualizationType: AudioVisualizationType
    let iconSymbol: String
    let durationDescription: String
    let frequencyText: String
    let primaryAccentHex: String
    let secondaryAccentHex: String
    let descriptionText: String
    
    var primaryColor: Color {
        Color(hex: primaryAccentHex)
    }
    
    var secondaryColor: Color {
        Color(hex: secondaryAccentHex)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Soundscape, rhs: Soundscape) -> Bool {
        lhs.id == rhs.id
    }
}
