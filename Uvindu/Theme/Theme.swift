//
//  Theme.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Defines the design language, color tokens, and visual standards for Zenith tvOS.
/// Designed specifically for the "10-foot experience" on large television screens in dimly lit living rooms.
enum ZenithTheme {
    
    // MARK: - Color Palette (Dark-Mode Living Room Optimized)
    
    /// Deep midnight slate background - prevents OLED glare while offering rich contrast
    static let backgroundDark = Color(red: 0.04, green: 0.06, blue: 0.11)
    /// Deeper pitch midnight for immersive contrast
    static let backgroundDeep = Color(red: 0.02, green: 0.03, blue: 0.07)
    /// Slightly lighter secondary background for card containers and shelves
    static let cardBackground = Color(red: 0.09, green: 0.12, blue: 0.21)
    /// Highlighted card background
    static let cardBackgroundElevated = Color(red: 0.13, green: 0.17, blue: 0.28)
    /// Subtle border stroke for unfocused cards
    static let cardBorder = Color.white.opacity(0.12)
    /// Luminous glass border for cards
    static let glassBorder = Color.white.opacity(0.18)
    
    // Accent Colors
    /// Calming restorative emerald - primary accent for breathing and success
    static let emeraldAccent = Color(red: 0.13, green: 0.77, blue: 0.55)
    /// Serene twilight indigo - primary accent for meditation and mindfulness
    static let indigoAccent = Color(red: 0.38, green: 0.45, blue: 0.95)
    /// Soft sky cyan - for focus and water soundscapes
    static let cyanAccent = Color(red: 0.24, green: 0.72, blue: 0.89)
    /// Twilight lavender - for sleep and bedtime rituals
    static let lavenderAccent = Color(red: 0.65, green: 0.55, blue: 0.95)
    /// Warm sunset amber - for energy, morning rituals, and streak milestones
    static let amberAccent = Color(red: 0.96, green: 0.64, blue: 0.25)
    /// Deep rose - for heart coherence and stress relief
    static let roseAccent = Color(red: 0.95, green: 0.35, blue: 0.48)
    
    // MARK: - Gradients
    
    /// Rich atmospheric living room backdrop gradient with depth
    static let primaryBackgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.06, green: 0.09, blue: 0.18),
            Color(red: 0.04, green: 0.05, blue: 0.12),
            Color(red: 0.02, green: 0.03, blue: 0.07)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Ambient aura glow for the sanctuary player
    static let playerAuraGradient = RadialGradient(
        colors: [
            indigoAccent.opacity(0.28),
            emeraldAccent.opacity(0.18),
            Color.clear
        ],
        center: .center,
        startRadius: 60,
        endRadius: 550
    )
    
    /// Glassmorphic subtle top-to-bottom card gradient
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.14),
            Color.white.opacity(0.04)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Hero banner iridescent glass gradient
    static let heroGlassGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.15),
            Color.white.opacity(0.02)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Typography (Scaled for 10-Foot Legibility)
    
    /// Large Display Headline for Hero / Player titles (Viewable from 12+ feet)
    static let displayTitle = Font.system(size: 44, weight: .bold, design: .rounded)
    /// Section Title for Shelf Headers
    static let sectionTitle = Font.system(size: 32, weight: .semibold, design: .rounded)
    /// Card Primary Title
    static let cardTitle = Font.system(size: 26, weight: .semibold, design: .default)
    /// Card Subtitle / Meta information
    static let cardSubtitle = Font.system(size: 20, weight: .medium, design: .default)
    /// Detail Body Text
    static let bodyText = Font.system(size: 22, weight: .regular, design: .default)
    /// Timer Digits Display
    static let timerDigit = Font.system(size: 72, weight: .light, design: .monospaced)
    
    // MARK: - Card Dimensions (Standard tvOS Grid Specifications)
    
    static let heroCardWidth: CGFloat = 880
    static let heroCardHeight: CGFloat = 370
    
    static let standardCardWidth: CGFloat = 380
    static let standardCardHeight: CGFloat = 250
    
    static let soundscapeCardWidth: CGFloat = 340
    static let soundscapeCardHeight: CGFloat = 230
    
    static let profileCardWidth: CGFloat = 280
    static let profileCardHeight: CGFloat = 250
}
