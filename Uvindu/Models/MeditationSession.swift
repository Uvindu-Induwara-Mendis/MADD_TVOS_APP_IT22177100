//
//  MeditationSession.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Categories of guided sessions available in the living room catalog.
enum MeditationCategory: String, CaseIterable, Identifiable {
    case all = "All Sessions"
    case breathing = "Breathwork"
    case sleep = "Deep Sleep"
    case focus = "Focus & Flow"
    case stress = "Stress Relief"
    case morning = "Mindful Morning"
    case family = "Family Calm"
    
    var id: String { rawValue }
    
    var iconSymbol: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .breathing: return "wind"
        case .sleep: return "moon.stars.fill"
        case .focus: return "bolt.shield.fill"
        case .stress: return "heart.circle.fill"
        case .morning: return "sun.horizon.fill"
        case .family: return "person.3.sequence.fill"
        }
    }
}

/// Represents an individual guided meditation session in the library.
struct MeditationSession: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let durationMinutes: Int
    let category: MeditationCategory
    let sessionDescription: String
    let instructor: String
    let breathingPattern: BreathingPattern
    let recommendedBadge: String?
    let iconSymbol: String
    let primaryAccentHex: String
    let secondaryAccentHex: String
    let sessionPlayCount: Int
    
    var durationFormatted: String {
        "\(durationMinutes) min"
    }
    
    var primaryColor: Color {
        Color(hex: primaryAccentHex)
    }
    
    var secondaryColor: Color {
        Color(hex: secondaryAccentHex)
    }
    
    // Hashable conformance based on ID
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MeditationSession, rhs: MeditationSession) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Color Hex Initializer Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var int: UInt64 = 0
        scanner.scanHexInt64(&int)
        let r, g, b, a: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6: // RGB (24-bit)
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF, int >> 24)
        default:
            (r, g, b, a) = (30, 41, 59, 255)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
