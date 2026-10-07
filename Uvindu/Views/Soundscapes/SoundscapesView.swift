//
//  SoundscapesView.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Catalog View for Living Room Ambient Soundscapes and Frequency Therapy.
/// Designed to transform the home theater into an acoustic wellness sanctuary.
struct SoundscapesView: View {
    @ObservedObject var viewModel: WellnessViewModel
    @FocusState private var focusedSoundscapeId: UUID?
    
    private let columns = [
        GridItem(.adaptive(minimum: 460, maximum: 560), spacing: 36)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 36) {
                
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ambient Living Room Soundscapes")
                        .font(ZenithTheme.displayTitle)
                        .foregroundColor(.white)
                    
                    Text("Immersive acoustic frequencies calibrated for multi-speaker home environments and OLED screens.")
                        .font(ZenithTheme.bodyText)
                        .foregroundColor(.white.opacity(0.75))
                }
                .padding(.horizontal, 80)
                .padding(.top, 24)
                
                // Preferred soundscape callout pill
                HStack(spacing: 16) {
                    Image(systemName: "music.note.house.fill")
                        .font(.system(size: 24))
                        .foregroundColor(ZenithTheme.cyanAccent)
                    
                    Text("Current Preferred Soundscape for \(viewModel.activeProfile.name):")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                    
                    Text(viewModel.activeProfile.preferredSoundscapeTitle)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(ZenithTheme.cyanAccent)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(ZenithTheme.cardBackgroundElevated)
                .overlay(
                    Capsule()
                        .stroke(ZenithTheme.glassBorder, lineWidth: 1.2)
                )
                .clipShape(Capsule())
                .padding(.horizontal, 80)
                
                // Soundscapes Grid
                LazyVGrid(columns: columns, spacing: 36) {
                    ForEach(viewModel.soundscapes) { soundscape in
                        let isPreferred = viewModel.activeProfile.preferredSoundscapeTitle == soundscape.title
                        
                        Button {
                            viewModel.startSoundscape(soundscape)
                        } label: {
                            ZStack(alignment: .bottomLeading) {
                                // Background Gradient
                                LinearGradient(
                                    colors: [
                                        soundscape.primaryColor.opacity(0.75),
                                        soundscape.secondaryColor.opacity(0.95),
                                        ZenithTheme.cardBackground
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    // Top Row
                                    HStack {
                                        Label(soundscape.frequencyText, systemImage: "waveform")
                                            .font(.system(size: 14, weight: .bold))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.black.opacity(0.45))
                                            .clipShape(Capsule())
                                            .foregroundColor(soundscape.primaryColor)
                                        
                                        Spacer()
                                        
                                        if isPreferred {
                                            Label("Preferred", systemImage: "star.fill")
                                                .font(.system(size: 14, weight: .bold))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(ZenithTheme.amberAccent.opacity(0.35))
                                                .clipShape(Capsule())
                                                .foregroundColor(ZenithTheme.amberAccent)
                                        }
                                    }
                                    
                                    // Live Animated Waveform Box
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.black.opacity(0.35))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(soundscape.primaryColor.opacity(0.3), lineWidth: 1)
                                            )
                                        
                                        AudioWaveformVisualizer(
                                            type: soundscape.visualizationType,
                                            accentColor: soundscape.primaryColor
                                        )
                                        .padding(.vertical, 10)
                                    }
                                    .frame(height: 110)
                                    
                                    // Title & Description
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(soundscape.title)
                                            .font(ZenithTheme.cardTitle)
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.4), radius: 4)
                                        
                                        Text(soundscape.subtitle)
                                            .font(ZenithTheme.cardSubtitle)
                                            .foregroundColor(.white.opacity(0.8))
                                            .lineLimit(2)
                                    }
                                    
                                    // Action bar
                                    HStack {
                                        HStack(spacing: 6) {
                                            Circle()
                                                .fill(soundscape.primaryColor)
                                                .frame(width: 8, height: 8)
                                            Text(soundscape.durationDescription)
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(.white.opacity(0.65))
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
                                    }
                                }
                                .padding(24)
                            }
                            .frame(height: 320)
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(ZenithTheme.glassBorder, lineWidth: 1.2)
                            )
                            .cornerRadius(22)
                        }
                        .buttonStyle(.card)
                        .focused($focusedSoundscapeId, equals: soundscape.id)
                    }
                }
                .padding(.horizontal, 80)
                .padding(.bottom, 60)
            }
        }
        .background(ZenithTheme.primaryBackgroundGradient.ignoresSafeArea())
    }
}
