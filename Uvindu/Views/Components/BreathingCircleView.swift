//
//  BreathingCircleView.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Full-scale circular breathing guide designed for the 10-foot living room viewing experience.
/// Utilizes smooth scale transformations, dynamic color shifts, and living room ambient glows
/// to synchronize autonomic breathing rhythms.
struct BreathingCircleView: View {
    let phase: BreathingPhase
    let phaseProgress: Double
    let visualScale: CGFloat
    let remainingTimeText: String
    let baseColor: Color
    let patternName: String
    
    // Dynamic ring color based on breath phase
    private var phaseColor: Color {
        switch phase {
        case .inhale:
            return ZenithTheme.cyanAccent
        case .holdInhale:
            return ZenithTheme.emeraldAccent
        case .exhale:
            return ZenithTheme.indigoAccent
        case .holdExhale:
            return ZenithTheme.lavenderAccent
        }
    }
    
    var body: some View {
        VStack(spacing: 28) {
            ZStack {
                // Living Room Ambient Aura Blur (Expands outward on breath)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                phaseColor.opacity(0.35),
                                phaseColor.opacity(0.12),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 80,
                            endRadius: 280
                        )
                    )
                    .frame(width: 560, height: 560)
                    .scaleEffect(visualScale * 1.15)
                    .animation(.easeInOut(duration: 0.35), value: visualScale)
                    .blur(radius: 20)
                
                // Outer Pulsing Orbit Ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                phaseColor.opacity(0.5),
                                phaseColor.opacity(0.1),
                                phaseColor.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 440, height: 440)
                    .scaleEffect(visualScale * 1.05)
                    .animation(.easeInOut(duration: 0.3), value: visualScale)
                
                // Track Guide Ring (Subtle baseline)
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 14)
                    .frame(width: 370, height: 370)
                
                // Active Phase Progress Ring with Glowing Gradient
                Circle()
                    .trim(from: 0, to: CGFloat(max(0.01, phaseProgress)))
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                phaseColor,
                                phaseColor.opacity(0.7),
                                Color.white.opacity(0.9),
                                phaseColor
                            ]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 14, lineCap: .round)
                    )
                    .frame(width: 370, height: 370)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: phaseColor.opacity(0.6), radius: 10, x: 0, y: 0)
                    .animation(.linear(duration: 0.05), value: phaseProgress)
                
                // Core Expanding Breath Disc (Tactile lungs visual)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                phaseColor.opacity(0.45),
                                phaseColor.opacity(0.18),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 30,
                            endRadius: 170
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
                    )
                    .frame(width: 320, height: 320)
                    .scaleEffect(visualScale)
                    .animation(.easeInOut(duration: 0.3), value: visualScale)
                
                // Center Information Display
                VStack(spacing: 10) {
                    // Current Breath Phase Capsule Badge
                    Text(phase.rawValue.uppercased())
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundColor(phaseColor)
                        .kerning(4)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 7)
                        .background(
                            Capsule()
                                .fill(phaseColor.opacity(0.22))
                                .overlay(
                                    Capsule()
                                        .stroke(phaseColor.opacity(0.5), lineWidth: 1.5)
                                )
                        )
                        .shadow(color: phaseColor.opacity(0.4), radius: 6)
                    
                    // High-legibility Timer Digits
                    Text(remainingTimeText)
                        .font(ZenithTheme.timerDigit)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.7), radius: 10, x: 0, y: 4)
                    
                    // Breathing Technique Label
                    Text(patternName)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .frame(width: 540, height: 540)
            
            // Textual Guidance Instruction for Household
            Text(phase.instruction)
                .font(.system(size: 28, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.95))
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 750)
                .animation(.easeInOut(duration: 0.3), value: phase)
        }
    }
}
