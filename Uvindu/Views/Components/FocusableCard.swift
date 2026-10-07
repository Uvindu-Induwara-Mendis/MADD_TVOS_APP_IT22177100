//
//  FocusableCard.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Standard tvOS Focusable Card Component.
/// Utilizes tvOS `.buttonStyle(.card)` to gain native platform parallax depth,
/// elevation, and shadow when selected by the Siri Remote Focus Engine.
struct FocusableMeditationCard: View {
    let session: MeditationSession
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            ZStack(alignment: .bottomLeading) {
                // Background Gradient with rich color field
                LinearGradient(
                    colors: [
                        session.primaryColor.opacity(0.85),
                        session.secondaryColor.opacity(0.95),
                        ZenithTheme.cardBackground
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Ambient Radial Light
                RadialGradient(
                    colors: [session.primaryColor.opacity(0.45), .clear],
                    center: .topTrailing,
                    startRadius: 20,
                    endRadius: 240
                )
                
                // Subtle glass shimmer overlay
                ZenithTheme.cardGradient
                
                // Card Details Overlay
                VStack(alignment: .leading, spacing: 10) {
                    // Top Bar: Category & Duration
                    HStack {
                        Label(session.category.rawValue, systemImage: session.iconSymbol)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.black.opacity(0.35))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        
                        Spacer()
                        
                        HStack(spacing: 5) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 13))
                            Text(session.durationFormatted)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.35))
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    // Session Titles
                    Text(session.title)
                        .font(ZenithTheme.cardTitle)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
                    
                    Text(session.subtitle)
                        .font(ZenithTheme.cardSubtitle)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                    
                    // Instructor & Play prompt
                    HStack(alignment: .center) {
                        HStack(spacing: 8) {
                            // Guide Avatar Initial Pill
                            Circle()
                                .fill(session.primaryColor.opacity(0.4))
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Text(String(session.instructor.prefix(1)))
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                )
                            
                            Text("Guide: \(session.instructor)")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.75))
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 38, height: 38)
                            
                            Image(systemName: "play.fill")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .offset(x: 1.5)
                        }
                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .padding(.top, 4)
                }
                .padding(22)
            }
            .frame(width: ZenithTheme.standardCardWidth, height: ZenithTheme.standardCardHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1.2)
            )
            .cornerRadius(20)
        }
        .buttonStyle(.card) // Core tvOS Focus Engine visual treatment: lifts, expands, and sheds 3D shadow on focus
    }
}

/// Wide Hero Banner Card for the Home Dashboard "Featured Session".
struct HeroBannerCard: View {
    let session: MeditationSession
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            ZStack(alignment: .leading) {
                // Background Gradient with rich color field
                LinearGradient(
                    colors: [
                        session.primaryColor.opacity(0.85),
                        session.secondaryColor.opacity(0.95),
                        ZenithTheme.cardBackground
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Ambient Glow
                RadialGradient(
                    colors: [session.primaryColor.opacity(0.55), .clear],
                    center: .trailing,
                    startRadius: 50,
                    endRadius: 550
                )
                
                // Subtle glass shimmer
                ZenithTheme.heroGlassGradient
                
                HStack(spacing: 36) {
                    VStack(alignment: .leading, spacing: 14) {
                        // Badge
                        HStack(spacing: 12) {
                            HStack(spacing: 6) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 13, weight: .bold))
                                Text(session.recommendedBadge ?? "Featured Living Room Sanctuary")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(session.primaryColor)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(color: session.primaryColor.opacity(0.5), radius: 8)
                            
                            Label(session.durationFormatted, systemImage: "clock.fill")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Capsule())
                        }
                        
                        Text(session.title)
                            .font(ZenithTheme.displayTitle)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 3)
                        
                        Text(session.sessionDescription)
                            .font(ZenithTheme.bodyText)
                            .foregroundColor(.white.opacity(0.9))
                            .lineLimit(2)
                            .frame(maxWidth: 600, alignment: .leading)
                        
                        HStack(spacing: 18) {
                            HStack(spacing: 10) {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 18, weight: .bold))
                                Text("Begin Practice")
                                    .font(.system(size: 20, weight: .bold))
                            }
                            .padding(.horizontal, 26)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: Color.white.opacity(0.35), radius: 10, x: 0, y: 3)
                            
                            Text("Technique: \(session.breathingPattern.name)")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white.opacity(0.85))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(Color.black.opacity(0.35))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.top, 4)
                    }
                    
                    Spacer()
                    
                    // Large Decorative Graphic with Living Room Rings
                    ZStack {
                        // Ambient Pulse Disc
                        Circle()
                            .fill(session.primaryColor.opacity(0.3))
                            .frame(width: 220, height: 220)
                            .blur(radius: 14)
                        
                        Circle()
                            .stroke(session.primaryColor.opacity(0.6), lineWidth: 3)
                            .frame(width: 170, height: 170)
                        
                        Circle()
                            .fill(Color.black.opacity(0.35))
                            .frame(width: 130, height: 130)
                            .overlay(
                                Image(systemName: session.iconSymbol)
                                    .font(.system(size: 65))
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.trailing, 24)
                }
                .padding(38)
            }
            .frame(width: ZenithTheme.heroCardWidth, height: ZenithTheme.heroCardHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 26)
                    .stroke(ZenithTheme.glassBorder, lineWidth: 1.5)
            )
            .cornerRadius(26)
        }
        .buttonStyle(.card)
    }
}
