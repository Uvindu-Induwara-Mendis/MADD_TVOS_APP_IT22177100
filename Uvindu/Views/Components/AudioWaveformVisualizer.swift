//
//  AudioWaveformVisualizer.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Animated audio visualizer component representing ambient living room acoustic streams.
/// Leverages lightweight procedural SwiftUI animation for tvOS GPU efficiency.
struct AudioWaveformVisualizer: View {
    let type: AudioVisualizationType
    let accentColor: Color
    var isPlaying: Bool = true
    
    @State private var phaseOffset: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            switch type {
            case .oceanWaves:
                // Undulating harmonic waveform
                OceanWaveRipples(color: accentColor, offset: phaseOffset)
                
            case .rainRipples:
                // Expanding concentric rain rings
                ConcentricRainRipples(color: accentColor, offset: phaseOffset)
                
            case .celestialOrb:
                // Rotating astral orbit
                CelestialParticleOrb(color: accentColor, rotation: phaseOffset)
                
            case .firesidePulse:
                // Warm flickering ember bars
                FiresideEmbersView(color: accentColor, offset: phaseOffset)
                
            case .binauralBeats, .forestBreeze:
                // Oscillating harmonic bars
                DynamicFrequencyBars(color: accentColor, offset: phaseOffset)
            }
        }
        .onAppear {
            if isPlaying {
                withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                    phaseOffset = 360.0
                }
            }
        }
    }
}

// MARK: - Procedural Visualizers

private struct OceanWaveRipples: View {
    let color: Color
    let offset: CGFloat
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<14) { index in
                let heightFactor = sin((Double(index) * 0.45) + (Double(offset) * 0.05))
                let barHeight = CGFloat(25 + abs(heightFactor) * 65)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 8, height: barHeight)
            }
        }
        .frame(height: 110)
    }
}

private struct ConcentricRainRipples: View {
    let color: Color
    let offset: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<4) { index in
                let scale = 0.4 + CGFloat(index) * 0.22 + (CGFloat(offset.truncatingRemainder(dividingBy: 90)) / 450)
                let opacity = max(0.1, 1.0 - Double(index) * 0.25)
                
                Circle()
                    .stroke(color.opacity(opacity), lineWidth: 2)
                    .frame(width: 140, height: 140)
                    .scaleEffect(scale)
            }
        }
    }
}

private struct CelestialParticleOrb: View {
    let color: Color
    let rotation: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [color.opacity(0.6), .clear], center: .center, startRadius: 10, endRadius: 70))
                .frame(width: 90, height: 90)
            
            ForEach(0..<8) { index in
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                    .offset(x: 55 * cos(Double(index) * .pi / 4))
                    .offset(y: 55 * sin(Double(index) * .pi / 4))
            }
            .rotationEffect(.degrees(rotation))
        }
    }
}

private struct FiresideEmbersView: View {
    let color: Color
    let offset: CGFloat
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<10) { index in
                let flicker = cos((Double(index) * 0.8) + (Double(offset) * 0.08))
                let height = CGFloat(20 + abs(flicker) * 55)
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        LinearGradient(
                            colors: [Color.yellow, color, Color.red.opacity(0.4)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 10, height: height)
            }
        }
    }
}

private struct DynamicFrequencyBars: View {
    let color: Color
    let offset: CGFloat
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<16) { index in
                let val = sin((Double(index) * 0.5) + (Double(offset) * 0.06))
                let height = CGFloat(18 + abs(val) * 70)
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(color.opacity(0.85))
                    .frame(width: 7, height: height)
            }
        }
    }
}
